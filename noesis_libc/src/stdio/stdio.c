/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Licensed under the Noesis License.
 */

#include "../../include/stdio/stdio.h"
#include "../../include/sys/syscall.h"
#include "../../include/unistd/unistd.h"
#include "../../include/stdlib/stdlib.h"
#include "../../include/string/string.h"
/* We can't use stdlib.h directly due to type conflicts */

/* Temporary system call wrappers for memory allocation */
static void* temp_malloc(size_t size) {
    void* ptr;

    /* Use mmap directly to allocate memory */
    __asm__ volatile (
        "movq $0x20000c5, %%rax\n"  /* mmap syscall for macOS */
        "movq $0, %%rdi\n"          /* addr = NULL */
        "movq %1, %%rsi\n"          /* length = size */
        "movl $3, %%edx\n"          /* prot = PROT_READ | PROT_WRITE */
        "movl $0x1002, %%r10d\n"    /* flags = MAP_PRIVATE | MAP_ANON */
        "movq $-1, %%r8\n"          /* fd = -1 */
        "movq $0, %%r9\n"           /* offset = 0 */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r" (ptr)
        : "r" (size)
        : "rax", "rdi", "rsi", "rdx", "r10", "r8", "r9"
    );

    /* Check for errors */
    if (ptr == (void*)-1) {
        return NULL;
    }

    return ptr;
}

static void temp_free(void* ptr, size_t size) {
    if (ptr == NULL) {
        return;
    }

    /* Use munmap to free the memory */
    __asm__ volatile (
        "movq $0x2000049, %%rax\n"  /* munmap syscall for macOS */
        "movq %0, %%rdi\n"          /* addr = ptr */
        "movq %1, %%rsi\n"          /* length = size */
        "syscall\n"
        :
        : "r" (ptr), "r" (size)
        : "rax", "rdi", "rsi"
    );
}

/* Define standard file descriptor values */
#define STDIN_FD  0
#define STDOUT_FD 1
#define STDERR_FD 2

/* Define buffer sizes */
#define NLIBC_BUFSIZ 8192

/* Maximum number of open files */
#define MAX_OPEN_FILES 64

/* File structure */
struct _FILE {
    int fd;                 /* File descriptor */
    int flags;              /* File state flags */
    int error;              /* Error indicator */
    int eof;                /* EOF indicator */
    unsigned char* buffer;  /* I/O buffer */
    int buf_size;           /* Buffer size */
    int buf_pos;            /* Current position in buffer */
    int buf_end;            /* End of data in buffer */
    int buf_mode;           /* Buffering mode */
};

/* File flags */
#define _FILE_FLAG_READ     0x0001
#define _FILE_FLAG_WRITE    0x0002
#define _FILE_FLAG_APPEND   0x0004
#define _FILE_FLAG_BINARY   0x0008
#define _FILE_FLAG_OPEN     0x0010

/* Static file tables */
static FILE _stdin = { STDIN_FD, _FILE_FLAG_READ | _FILE_FLAG_OPEN, 0, 0, NULL, 0, 0, 0, _IONBF };
static FILE _stdout = { STDOUT_FD, _FILE_FLAG_WRITE | _FILE_FLAG_OPEN, 0, 0, NULL, 0, 0, 0, _IONBF };
static FILE _stderr = { STDERR_FD, _FILE_FLAG_WRITE | _FILE_FLAG_OPEN, 0, 0, NULL, 0, 0, 0, _IONBF };

/* Public file pointers */
FILE* nlibc_stdin = &_stdin;
FILE* nlibc_stdout = &_stdout;
FILE* nlibc_stderr = &_stderr;

/* Array of all open file streams */
static FILE* open_files[MAX_OPEN_FILES] = { &_stdin, &_stdout, &_stderr };

/* System call wrapper for write */
static ssize_t sys_write(int fd, const void* buf, size_t count) {
    ssize_t result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* fd */
        "movq %2, %%rsi\n"    /* buf */
        "movq %3, %%rdx\n"    /* count */
        "movq $0x2000004, %%rax\n"    /* write syscall number on macOS */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r" (result)
        : "r" ((long)fd), "r" (buf), "r" (count)
        : "rax", "rdi", "rsi", "rdx"
    );
    
    return result;
}

/* System call wrapper for read */
static ssize_t sys_read(int fd, void* buf, size_t count) {
    ssize_t result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* fd */
        "movq %2, %%rsi\n"    /* buf */
        "movq %3, %%rdx\n"    /* count */
        "movq $0x2000003, %%rax\n"    /* read syscall number on macOS */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r" (result)
        : "r" ((long)fd), "r" (buf), "r" (count)
        : "rax", "rdi", "rsi", "rdx"
    );
    
    return result;
}

/* System call wrapper for open */
static int sys_open(const char* pathname, int flags, int mode) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* pathname */
        "movl %2, %%esi\n"    /* flags */
        "movl %3, %%edx\n"    /* mode */
        "movq $0x2000005, %%rax\n"    /* open syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (pathname), "r" (flags), "r" (mode)
        : "rax", "rdi", "rsi", "rdx"
    );
    
    return result;
}

/* System call wrapper for close */
static int sys_close(int fd) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* fd */
        "movq $0x2000006, %%rax\n"    /* close syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" ((long)fd)
        : "rax", "rdi"
    );
    
    return result;
}

/* Initialize a file stream */
static int init_file_stream(FILE* fp, int fd, int flags) {
    fp->fd = fd;
    fp->flags = flags | _FILE_FLAG_OPEN;
    fp->error = 0;
    fp->eof = 0;
    fp->buffer = NULL;
    fp->buf_size = 0;
    fp->buf_pos = 0;
    fp->buf_end = 0;
    fp->buf_mode = _IONBF;  /* Unbuffered by default */
    
    /* Register in open_files list */
    for (int i = 0; i < MAX_OPEN_FILES; i++) {
        if (open_files[i] == NULL) {
            open_files[i] = fp;
            break;
        }
    }
    
    return 0;
}

/* Open a file */
FILE* nlibc_fopen(const char* pathname, const char* mode) {
    int flags = 0;
    int open_mode = 0;
    FILE* fp;
    
    /* Parse mode string */
    switch (mode[0]) {
        case 'r':
            flags = _FILE_FLAG_READ;
            open_mode = 0;  /* O_RDONLY */
            break;
        
        case 'w':
            flags = _FILE_FLAG_WRITE;
            open_mode = 1 | 0x0200;  /* O_WRONLY | O_CREAT | O_TRUNC */
            break;
        
        case 'a':
            flags = _FILE_FLAG_WRITE | _FILE_FLAG_APPEND;
            open_mode = 1 | 0x0200 | 8;  /* O_WRONLY | O_CREAT | O_APPEND */
            break;
        
        default:
            return NULL;  /* Invalid mode */
    }
    
    /* Check for '+' modifier */
    if (nlibc_strchr(mode, '+')) {
        flags |= _FILE_FLAG_READ | _FILE_FLAG_WRITE;
        open_mode = 2;  /* O_RDWR */
        
        /* Apply create/append flags if needed */
        if (mode[0] == 'w')
            open_mode |= 0x0200 | 0x0400;  /* O_CREAT | O_TRUNC */
        else if (mode[0] == 'a')
            open_mode |= 0x0200 | 8;  /* O_CREAT | O_APPEND */
    }
    
    /* Check for 'b' modifier (binary mode - ignored on Unix-like platforms) */
    if (nlibc_strchr(mode, 'b')) {
        flags |= _FILE_FLAG_BINARY;
    }
    
    /* Open the file */
    int fd = sys_open(pathname, open_mode, 0666);
    if (fd < 0) {
        return NULL;
    }
    
    /* Allocate and initialize FILE structure */
    fp = (FILE*)temp_malloc(sizeof(FILE));  /* Use temporary malloc */
    if (!fp) {
        sys_close(fd);
        return NULL;
    }
    
    init_file_stream(fp, fd, flags);
    
    return fp;
}

/* Close a file */
int nlibc_fclose(FILE* stream) {
    int result = 0;
    
    if (!stream) {
        return EOF;
    }
    
    /* Flush any buffered data */
    nlibc_fflush(stream);
    
    /* Close the file descriptor */
    if (stream->fd >= 0) {
        result = sys_close(stream->fd);
    }
    
    /* Free the buffer if we allocated one */
    if (stream->buffer && stream != nlibc_stdin && stream != nlibc_stdout && stream != nlibc_stderr) {
        nlibc_free(stream->buffer);
    }
    
    /* Remove from open files array */
    for (int i = 0; i < MAX_OPEN_FILES; i++) {
        if (open_files[i] == stream) {
            open_files[i] = NULL;
            break;
        }
    }
    
    /* If this is not a standard stream, free the FILE structure */
    if (stream != nlibc_stdin && stream != nlibc_stdout && stream != nlibc_stderr) {
        nlibc_free(stream);
    } else {
        stream->flags &= ~_FILE_FLAG_OPEN;
    }
    
    return (result == 0) ? 0 : EOF;
}

/* Flush a file's buffer */
int nlibc_fflush(FILE* stream) {
    if (!stream || !(stream->flags & _FILE_FLAG_OPEN)) {
        return EOF;
    }
    
    /* If in write mode and we have data in the buffer */
    if ((stream->flags & _FILE_FLAG_WRITE) && stream->buf_pos > 0) {
        ssize_t written = sys_write(stream->fd, stream->buffer, stream->buf_pos);
        
        if (written < 0 || written != (ssize_t)stream->buf_pos) {
            stream->error = 1;
            return EOF;
        }
        
        stream->buf_pos = 0;
    }
    
    /* If in read mode, discard the buffer */
    if (stream->flags & _FILE_FLAG_READ) {
        stream->buf_pos = 0;
        stream->buf_end = 0;
    }
    
    return 0;
}

/* Write character to file */
int nlibc_fputc(int c, FILE* stream) {
    unsigned char ch = (unsigned char)c;
    
    if (!stream || !(stream->flags & _FILE_FLAG_OPEN) || !(stream->flags & _FILE_FLAG_WRITE)) {
        return EOF;
    }
    
    /* If unbuffered or no buffer available, write directly */
    if (stream->buf_mode == _IONBF || !stream->buffer) {
        if (sys_write(stream->fd, &ch, 1) != 1) {
            stream->error = 1;
            return EOF;
        }
        return c;
    }
    
    /* If buffer is full, flush it */
    if (stream->buf_pos >= stream->buf_size) {
        if (nlibc_fflush(stream) == EOF) {
            return EOF;
        }
    }
    
    /* Add character to buffer */
    stream->buffer[stream->buf_pos++] = ch;
    
    /* If line buffered and we see a newline, flush */
    if (stream->buf_mode == _IOLBF && ch == '\n') {
        if (nlibc_fflush(stream) == EOF) {
            return EOF;
        }
    }
    
    return c;
}

/* Write a character to stdout */
int nlibc_putchar(int c) {
    return nlibc_fputc(c, nlibc_stdout);
}

/* Write a string to a file */
int nlibc_fputs(const char* s, FILE* stream) {
    if (!s || !stream) {
        return EOF;
    }
    
    while (*s) {
        if (nlibc_fputc(*s++, stream) == EOF) {
            return EOF;
        }
    }
    
    return 0;
}

/* Write a string to stdout followed by a newline */
int nlibc_puts(const char* s) {
    if (nlibc_fputs(s, nlibc_stdout) == EOF) {
        return EOF;
    }
    
    return nlibc_fputc('\n', nlibc_stdout) == EOF ? EOF : 0;
}

/* Read a character from a file */
int nlibc_fgetc(FILE* stream) {
    unsigned char c;
    
    if (!stream || !(stream->flags & _FILE_FLAG_OPEN) || !(stream->flags & _FILE_FLAG_READ)) {
        return EOF;
    }
    
    /* If EOF was previously reached */
    if (stream->eof) {
        return EOF;
    }
    
    /* If we have data in the buffer */
    if (stream->buf_pos < stream->buf_end) {
        return stream->buffer[stream->buf_pos++];
    }
    
    /* Need to read more data */
    ssize_t bytes_read = sys_read(stream->fd, &c, 1);
    
    if (bytes_read <= 0) {
        stream->eof = (bytes_read == 0);
        stream->error = (bytes_read < 0);
        return EOF;
    }
    
    return c;
}

/* Read a character from stdin */
int nlibc_getchar(void) {
    return nlibc_fgetc(nlibc_stdin);
}

/* Read a line from a file */
char* nlibc_fgets(char* s, int size, FILE* stream) {
    int c;
    int i = 0;
    
    if (!s || size <= 0 || !stream) {
        return NULL;
    }
    
    /* Read characters until newline, EOF, or buffer full */
    while (i < size - 1) {
        c = nlibc_fgetc(stream);
        
        if (c == EOF) {
            /* EOF with no characters read */
            if (i == 0) {
                return NULL;
            }
            break;
        }
        
        s[i++] = (char)c;
        
        /* Break on newline */
        if (c == '\n') {
            break;
        }
    }
    
    /* Null terminate the string */
    s[i] = '\0';
    return s;
}

/* Basic implementation of printf (supports only %s, %c, %d) */
int nlibc_printf(const char* format, ...) {
    va_list ap;
    int result;
    
    va_start(ap, format);
    result = nlibc_vfprintf(nlibc_stdout, format, ap);
    va_end(ap);
    
    return result;
}

/* Write formatted data to a file stream */
int nlibc_fprintf(FILE* stream, const char* format, ...) {
    va_list ap;
    int result;
    
    va_start(ap, format);
    result = nlibc_vfprintf(stream, format, ap);
    va_end(ap);
    
    return result;
}

/* Write formatted data to a string */
int nlibc_sprintf(char* str, const char* format, ...) {
    va_list ap;
    int result;
    
    va_start(ap, format);
    result = nlibc_vsnprintf(str, SIZE_MAX, format, ap);
    va_end(ap);
    
    return result;
}

/* Simplified version of vfprintf (supports %d, %s, %c) */
int nlibc_vfprintf(FILE* stream, const char* format, va_list ap) {
    int written = 0;
    const char* p = format;
    
    if (!stream || !format) {
        return -1;
    }
    
    while (*p) {
        /* Handle format specifiers */
        if (*p == '%') {
            p++;  /* Skip '%' */
            
            /* Handle format specifier */
            switch (*p) {
                case 'd': {  /* Integer */
                    int val = va_arg(ap, int);
                    char buf[32];  /* Buffer for number */
                    int len = 0;
                    int is_neg = 0;
                    
                    if (val < 0) {
                        is_neg = 1;
                        val = -val;
                    }
                    
                    /* Convert number to string (backward) */
                    do {
                        buf[len++] = '0' + (val % 10);
                        val /= 10;
                    } while (val);
                    
                    /* Add negative sign if needed */
                    if (is_neg) {
                        nlibc_fputc('-', stream);
                        written++;
                    }
                    
                    /* Print digits in correct order */
                    while (len > 0) {
                        nlibc_fputc(buf[--len], stream);
                        written++;
                    }
                    break;
                }
                
                case 's': {  /* String */
                    char* str = va_arg(ap, char*);
                    if (!str) str = "(null)";
                    
                    while (*str) {
                        nlibc_fputc(*str++, stream);
                        written++;
                    }
                    break;
                }
                
                case 'c': {  /* Character */
                    char ch = (char)va_arg(ap, int);
                    nlibc_fputc(ch, stream);
                    written++;
                    break;
                }
                
                case '%': {  /* Literal '%' */
                    nlibc_fputc('%', stream);
                    written++;
                    break;
                }
                
                default: {
                    /* Unknown format specifier, just print it */
                    nlibc_fputc('%', stream);
                    nlibc_fputc(*p, stream);
                    written += 2;
                }
            }
        } else {
            /* Regular character */
            nlibc_fputc(*p, stream);
            written++;
        }
        
        p++;  /* Move to next character */
    }
    
    return written;
}

/* Very simplified implementation of vsnprintf (supports %d, %s, %c) */
int nlibc_vsnprintf(char* str, size_t size, const char* format, va_list ap) {
    int written = 0;
    const char* p = format;
    size_t remaining = size;
    
    if (!str || !format || size == 0) {
        return -1;
    }
    
    /* Reserve space for null terminator */
    remaining--;
    
    while (*p && remaining > 0) {
        /* Handle format specifiers */
        if (*p == '%') {
            p++;  /* Skip '%' */
            
            /* Handle format specifier */
            switch (*p) {
                case 'd': {  /* Integer */
                    int val = va_arg(ap, int);
                    char buf[32];  /* Buffer for number */
                    int len = 0;
                    int is_neg = 0;
                    
                    if (val < 0) {
                        is_neg = 1;
                        val = -val;
                    }
                    
                    /* Convert number to string (backward) */
                    do {
                        buf[len++] = '0' + (val % 10);
                        val /= 10;
                    } while (val);
                    
                    /* Add negative sign if needed */
                    if (is_neg && remaining > 0) {
                        *str++ = '-';
                        written++;
                        remaining--;
                    }
                    
                    /* Print digits in correct order */
                    while (len > 0 && remaining > 0) {
                        *str++ = buf[--len];
                        written++;
                        remaining--;
                    }
                    break;
                }
                
                case 's': {  /* String */
                    char* s = va_arg(ap, char*);
                    if (!s) s = "(null)";
                    
                    while (*s && remaining > 0) {
                        *str++ = *s++;
                        written++;
                        remaining--;
                    }
                    break;
                }
                
                case 'c': {  /* Character */
                    char ch = (char)va_arg(ap, int);
                    if (remaining > 0) {
                        *str++ = ch;
                        written++;
                        remaining--;
                    }
                    break;
                }
                
                case '%': {  /* Literal '%' */
                    if (remaining > 0) {
                        *str++ = '%';
                        written++;
                        remaining--;
                    }
                    break;
                }
                
                default: {
                    /* Unknown format specifier, just print it */
                    if (remaining > 1) {
                        *str++ = '%';
                        *str++ = *p;
                        written += 2;
                        remaining -= 2;
                    } else if (remaining > 0) {
                        *str++ = '%';
                        written += 1;
                        remaining -= 1;
                    }
                }
            }
        } else {
            /* Regular character */
            *str++ = *p;
            written++;
            remaining--;
        }
        
        p++;  /* Move to next character */
    }
    
    /* Add null terminator */
    *str = '\0';
    
    return written;
}

/* Error status */
int nlibc_ferror(FILE* stream) {
    return stream ? stream->error : 0;
}

/* EOF indicator */
int nlibc_feof(FILE* stream) {
    return stream ? stream->eof : 0;
}

/* Clear error and EOF indicators */
void nlibc_clearerr(FILE* stream) {
    if (stream) {
        stream->error = 0;
        stream->eof = 0;
    }
}

/* Get file descriptor associated with stream */
int nlibc_fileno(FILE* stream) {
    return stream ? stream->fd : -1;
}
