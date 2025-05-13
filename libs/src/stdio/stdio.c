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
#include <stdarg.h> /* For va_list */

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

/* Maximum number of open files */
#define MAX_OPEN_FILES 64

/* Additional file flags */
#define _FILE_FLAG_APPEND   0x0004
#define _FILE_FLAG_BINARY   0x0008

/* Static file tables */
static NLIBC_FILE _stdin = { STDIN_FD, _FILE_FLAG_READ | _FILE_FLAG_OPEN, 0, 0, NULL, 0, 0, 0, _IONBF };
static NLIBC_FILE _stdout = { STDOUT_FD, _FILE_FLAG_WRITE | _FILE_FLAG_OPEN, 0, 0, NULL, 0, 0, 0, _IONBF };
static NLIBC_FILE _stderr = { STDERR_FD, _FILE_FLAG_WRITE | _FILE_FLAG_OPEN, 0, 0, NULL, 0, 0, 0, _IONBF };

/* Public file pointers */
NLIBC_FILE* nlibc_stdin = &_stdin;
NLIBC_FILE* nlibc_stdout = &_stdout;
NLIBC_FILE* nlibc_stderr = &_stderr;

/* Array of all open file streams */
static NLIBC_FILE* open_files[MAX_OPEN_FILES] = { &_stdin, &_stdout, &_stderr };

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
static int init_file_stream(NLIBC_FILE* fp, int fd, int flags) {
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
NLIBC_FILE* nlibc_fopen(const char* pathname, const char* mode) {
    int flags = 0;
    int open_mode = 0;
    NLIBC_FILE* fp;
    
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
    
    /* Allocate and initialize NLIBC_FILE structure */
    fp = (NLIBC_FILE*)temp_malloc(sizeof(NLIBC_FILE));  /* Use temporary malloc */
    if (!fp) {
        sys_close(fd);
        return NULL;
    }
    
    init_file_stream(fp, fd, flags);
    
    return fp;
}

/* Close a file */
int nlibc_fclose(NLIBC_FILE* stream) {
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
        temp_free(stream->buffer, stream->buf_size);
    }
    
    /* Remove from open files array */
    for (int i = 0; i < MAX_OPEN_FILES; i++) {
        if (open_files[i] == stream) {
            open_files[i] = NULL;
            break;
        }
    }
    
    /* If this is not a standard stream, free the NLIBC_FILE structure */
    if (stream != nlibc_stdin && stream != nlibc_stdout && stream != nlibc_stderr) {
        temp_free(stream, sizeof(NLIBC_FILE));
    } else {
        stream->flags &= ~_FILE_FLAG_OPEN;
    }
    
    return (result == 0) ? 0 : EOF;
}

/* Read data from a file */
size_t nlibc_fread(void* ptr, size_t size, size_t nmemb, NLIBC_FILE* stream) {
    if (!ptr || !stream || size == 0 || nmemb == 0 || !(stream->flags & _FILE_FLAG_READ)) {
        return 0;
    }
    
    size_t total_size = size * nmemb;
    ssize_t bytes_read = sys_read(stream->fd, ptr, total_size);
    
    if (bytes_read <= 0) {
        if (bytes_read == 0) {
            stream->eof = 1;
        } else {
            stream->error = 1;
        }
        return 0;
    }
    
    return bytes_read / size;
}

/* Write data to a file */
size_t nlibc_fwrite(const void* ptr, size_t size, size_t nmemb, NLIBC_FILE* stream) {
    if (!ptr || !stream || size == 0 || nmemb == 0 || !(stream->flags & _FILE_FLAG_WRITE)) {
        return 0;
    }
    
    size_t total_size = size * nmemb;
    ssize_t bytes_written = sys_write(stream->fd, ptr, total_size);
    
    if (bytes_written <= 0) {
        stream->error = 1;
        return 0;
    }
    
    return bytes_written / size;
}

/* Set file position */
int nlibc_fseek(NLIBC_FILE* stream, long offset, int whence) {
    if (!stream) {
        return -1;
    }
    
    /* Call lseek system call */
    off_t result = nlibc_lseek(stream->fd, offset, whence);
    
    if (result == -1) {
        stream->error = 1;
        return -1;
    }
    
    /* Reset EOF flag */
    stream->eof = 0;
    
    return 0;
}

/* Get current file position */
long nlibc_ftell(NLIBC_FILE* stream) {
    if (!stream) {
        return -1;
    }
    
    /* Call lseek with zero offset in SEEK_CUR mode to get current position */
    off_t result = nlibc_lseek(stream->fd, 0, SEEK_CUR);
    
    if (result == -1) {
        stream->error = 1;
        return -1;
    }
    
    return (long)result;
}

/* Reset file position to the beginning */
void nlibc_rewind(NLIBC_FILE* stream) {
    if (stream) {
        nlibc_fseek(stream, 0, SEEK_SET);
        nlibc_clearerr(stream);
    }
}

/* Flush a file's buffer */
int nlibc_fflush(NLIBC_FILE* stream) {
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

/* Character input/output functions */

/* Get a character from a stream */
int nlibc_fgetc(NLIBC_FILE* stream) {
    if (!stream || !(stream->flags & _FILE_FLAG_READ)) {
        return EOF;
    }
    
    unsigned char c;
    if (sys_read(stream->fd, &c, 1) <= 0) {
        stream->eof = 1;
        return EOF;
    }
    
    return c;
}

/* Wrapper for fgetc */
int nlibc_getc(NLIBC_FILE* stream) {
    return nlibc_fgetc(stream);
}

/* Get a character from stdin */
int nlibc_getchar(void) {
    return nlibc_fgetc(nlibc_stdin);
}

/* Put a character to a stream */
int nlibc_fputc(int c, NLIBC_FILE* stream) {
    if (!stream || !(stream->flags & _FILE_FLAG_WRITE)) {
        return EOF;
    }
    
    unsigned char ch = (unsigned char)c;
    if (sys_write(stream->fd, &ch, 1) != 1) {
        stream->error = 1;
        return EOF;
    }
    
    return c;
}

/* Wrapper for fputc */
int nlibc_putc(int c, NLIBC_FILE* stream) {
    return nlibc_fputc(c, stream);
}

/* Put a character to stdout */
int nlibc_putchar(int c) {
    return nlibc_fputc(c, nlibc_stdout);
}

/* Get a string from a stream */
char* nlibc_fgets(char* s, int size, NLIBC_FILE* stream) {
    if (!stream || !s || size <= 0 || !(stream->flags & _FILE_FLAG_READ)) {
        return NULL;
    }
    
    int i = 0;
    int c;
    
    while (i < size - 1) {
        c = nlibc_fgetc(stream);
        
        if (c == EOF) {
            if (i == 0) {
                return NULL;
            } else {
                break;
            }
        }
        
        s[i++] = (char)c;
        
        if (c == '\n') {
            break;
        }
    }
    
    if (i < size) {
        s[i] = '\0';
    }
    
    return s;
}

/* Put a string to a stream */
int nlibc_fputs(const char* s, NLIBC_FILE* stream) {
    if (!stream || !s || !(stream->flags & _FILE_FLAG_WRITE)) {
        return EOF;
    }
    
    size_t len = 0;
    while (s[len]) {
        len++;
    }
    
    if (sys_write(stream->fd, s, len) != (ssize_t)len) {
        stream->error = 1;
        return EOF;
    }
    
    return 0;
}

/* Put a string to stdout with newline */
int nlibc_puts(const char* s) {
    if (nlibc_fputs(s, nlibc_stdout) == EOF) {
        return EOF;
    }
    
    return nlibc_putc('\n', nlibc_stdout);
}

/* Push a character back to input stream */
int nlibc_ungetc(int c, NLIBC_FILE* stream) {
    /* Simplified implementation - would need a proper buffer mechanism for real usage */
    if (!stream || c == EOF) {
        return EOF;
    }
    
    /* This is a very simplified implementation that doesn't actually work properly */
    /* In a real implementation, we would need to handle buffering */
    return EOF;
}

/* Helper function for simple formatted output */
static int format_output(char* buffer, size_t size, const char* format, va_list args) {
    /* This is a very simplified implementation that supports only %d, %s, and %c */
    size_t i = 0;
    size_t buffer_pos = 0;
    
    while (format[i] && buffer_pos < size - 1) {
        if (format[i] == '%') {
            i++;
            switch (format[i]) {
                case 'd': {
                    int val = va_arg(args, int);
                    
                    /* Convert integer to string */
                    char num_buffer[20];
                    int num_pos = 0;
                    int temp = val;
                    
                    if (val == 0) {
                        if (buffer_pos < size - 1) {
                            buffer[buffer_pos++] = '0';
                        }
                    } else {
                        if (val < 0) {
                            if (buffer_pos < size - 1) {
                                buffer[buffer_pos++] = '-';
                            }
                            temp = -val;
                        }
                        
                        /* Generate digits in reverse order */
                        while (temp > 0 && num_pos < 19) {
                            num_buffer[num_pos++] = '0' + (temp % 10);
                            temp /= 10;
                        }
                        
                        /* Copy digits in correct order */
                        while (num_pos > 0 && buffer_pos < size - 1) {
                            buffer[buffer_pos++] = num_buffer[--num_pos];
                        }
                    }
                    break;
                }
                case 's': {
                    char* str = va_arg(args, char*);
                    if (str) {
                        while (*str && buffer_pos < size - 1) {
                            buffer[buffer_pos++] = *str++;
                        }
                    }
                    break;
                }
                case 'c': {
                    char c = (char)va_arg(args, int);
                    if (buffer_pos < size - 1) {
                        buffer[buffer_pos++] = c;
                    }
                    break;
                }
                case '%': {
                    if (buffer_pos < size - 1) {
                        buffer[buffer_pos++] = '%';
                    }
                    break;
                }
                default:
                    /* Unsupported format specifier */
                    if (buffer_pos < size - 1) {
                        buffer[buffer_pos++] = '%';
                    }
                    if (buffer_pos < size - 1) {
                        buffer[buffer_pos++] = format[i];
                    }
            }
            i++;
        } else {
            buffer[buffer_pos++] = format[i++];
        }
    }
    
    buffer[buffer_pos] = '\0';
    return buffer_pos;
}

/* Formatted output functions */

/* Print formatted output to stdout */
int nlibc_printf(const char* format, ...) {
    va_list args;
    int result;
    
    va_start(args, format);
    result = nlibc_vprintf(format, args);
    va_end(args);
    
    return result;
}

/* Print formatted output to a stream */
int nlibc_fprintf(NLIBC_FILE* stream, const char* format, ...) {
    va_list args;
    int result;
    
    va_start(args, format);
    result = nlibc_vfprintf(stream, format, args);
    va_end(args);
    
    return result;
}

/* Print formatted output to a string */
int nlibc_sprintf(char* str, const char* format, ...) {
    va_list args;
    int result;
    
    va_start(args, format);
    result = nlibc_vsprintf(str, format, args);
    va_end(args);
    
    return result;
}

/* Print formatted output to a string with size limit */
int nlibc_snprintf(char* str, size_t size, const char* format, ...) {
    va_list args;
    int result;
    
    va_start(args, format);
    result = nlibc_vsnprintf(str, size, format, args);
    va_end(args);
    
    return result;
}

/* Print formatted output to stdout using va_list */
int nlibc_vprintf(const char* format, va_list args) {
    /* For simplicity, format to a temporary buffer and then output */
    char buffer[1024]; /* Fixed size buffer - not ideal but simple */
    int len = format_output(buffer, sizeof(buffer), format, args);
    
    if (sys_write(STDOUT_FD, buffer, len) != len) {
        return -1;
    }
    
    return len;
}

/* Print formatted output to a stream using va_list */
int nlibc_vfprintf(NLIBC_FILE* stream, const char* format, va_list args) {
    if (!stream || !(stream->flags & _FILE_FLAG_WRITE)) {
        return -1;
    }
    
    /* For simplicity, format to a temporary buffer and then output */
    char buffer[1024]; /* Fixed size buffer - not ideal but simple */
    int len = format_output(buffer, sizeof(buffer), format, args);
    
    if (sys_write(stream->fd, buffer, len) != len) {
        return -1;
    }
    
    return len;
}

/* Print formatted output to a string using va_list */
int nlibc_vsprintf(char* str, const char* format, va_list args) {
    if (!str) {
        return -1;
    }
    
    return format_output(str, (size_t)-1, format, args); /* Assuming no limit */
}

/* Print formatted output to a string with size limit using va_list */
int nlibc_vsnprintf(char* str, size_t size, const char* format, va_list args) {
    if (!str || size == 0) {
        return -1;
    }
    
    return format_output(str, size, format, args);
}

/* Helper function to skip whitespace */
static void skip_whitespace(const char** input) {
    while (**input == ' ' || **input == '\t' || **input == '\n' || **input == '\r') {
        (*input)++;
    }
}

/* Basic implementation of sscanf-like functionality */
static int parse_input(const char* input, const char* format, va_list args) {
    int items_assigned = 0;
    
    while (*format && *input) {
        if (*format == '%') {
            format++; /* Skip % */
            
            /* Handle format specifiers */
            switch (*format) {
                case 'd': {
                    /* Parse integer */
                    int* p_int = va_arg(args, int*);
                    if (!p_int) {
                        /* NULL pointer, skip this value */
                        while (*input >= '0' && *input <= '9') {
                            input++;
                        }
                    } else {
                        int val = 0;
                        int negative = 0;
                        
                        skip_whitespace(&input);
                        
                        if (*input == '-') {
                            negative = 1;
                            input++;
                        } else if (*input == '+') {
                            input++;
                        }
                        
                        if (*input >= '0' && *input <= '9') {
                            while (*input >= '0' && *input <= '9') {
                                val = val * 10 + (*input - '0');
                                input++;
                            }
                            
                            *p_int = negative ? -val : val;
                            items_assigned++;
                        } else {
                            /* Not a number */
                            return items_assigned;
                        }
                    }
                    break;
                }
                case 's': {
                    /* Parse string */
                    char* p_str = va_arg(args, char*);
                    
                    skip_whitespace(&input);
                    
                    if (p_str) {
                        while (*input && *input != ' ' && *input != '\t' && *input != '\n' && *input != '\r') {
                            *p_str++ = *input++;
                        }
                        *p_str = '\0';
                        items_assigned++;
                    } else {
                        /* NULL pointer, skip this string */
                        while (*input && *input != ' ' && *input != '\t' && *input != '\n' && *input != '\r') {
                            input++;
                        }
                    }
                    break;
                }
                case 'c': {
                    /* Parse character */
                    char* p_char = va_arg(args, char*);
                    
                    if (p_char) {
                        *p_char = *input++;
                        items_assigned++;
                    } else {
                        input++; /* Skip character */
                    }
                    break;
                }
                default:
                    /* Unsupported format specifier */
                    return items_assigned;
            }
            
            format++;
        } else if (*format == ' ' || *format == '\t' || *format == '\n' || *format == '\r') {
            /* Skip whitespace in format and input */
            skip_whitespace(&format);
            skip_whitespace(&input);
        } else if (*format == *input) {
            /* Match literal characters */
            format++;
            input++;
        } else {
            /* Mismatch */
            return items_assigned;
        }
    }
    
    return items_assigned;
}

/* Formatted input functions */

/* Read formatted input from stdin */
int nlibc_scanf(const char* format, ...) {
    /* This is a very simplified implementation */
    char buffer[1024]; /* Fixed size buffer - not ideal but simple */
    
    if (nlibc_fgets(buffer, sizeof(buffer), nlibc_stdin) == NULL) {
        return EOF;
    }
    
    va_list args;
    int result;
    
    va_start(args, format);
    result = parse_input(buffer, format, args);
    va_end(args);
    
    return result;
}

/* Read formatted input from a stream */
int nlibc_fscanf(NLIBC_FILE* stream, const char* format, ...) {
    if (!stream || !(stream->flags & _FILE_FLAG_READ)) {
        return EOF;
    }
    
    /* This is a very simplified implementation */
    char buffer[1024]; /* Fixed size buffer - not ideal but simple */
    
    if (nlibc_fgets(buffer, sizeof(buffer), stream) == NULL) {
        return EOF;
    }
    
    va_list args;
    int result;
    
    va_start(args, format);
    result = parse_input(buffer, format, args);
    va_end(args);
    
    return result;
}

/* Read formatted input from a string */
int nlibc_sscanf(const char* str, const char* format, ...) {
    if (!str) {
        return EOF;
    }
    
    va_list args;
    int result;
    
    va_start(args, format);
    result = parse_input(str, format, args);
    va_end(args);
    
    return result;
}

/* Buffer handling functions */

/* Set buffering mode for a stream */
int nlibc_setvbuf(NLIBC_FILE* stream, char* buf, int mode, size_t size) {
    if (!stream) {
        return -1;
    }
    
    /* Free existing buffer if it was allocated by us */
    if (stream->buffer && stream->buf_size > 0) {
        temp_free(stream->buffer, stream->buf_size);
        stream->buffer = NULL;
    }
    
    stream->buf_mode = mode;
    
    if (mode == _IONBF) {
        /* No buffering */
        stream->buffer = NULL;
        stream->buf_size = 0;
        stream->buf_pos = 0;
        stream->buf_end = 0;
        return 0;
    }
    
    /* Use provided buffer or allocate one */
    if (size == 0) {
        size = BUFSIZ; /* Use default size if 0 is specified */
    }
    
    if (buf) {
        stream->buffer = buf;
        stream->buf_size = size;
    } else {
        stream->buffer = temp_malloc(size);
        if (!stream->buffer) {
            stream->buf_mode = _IONBF;
            return -1;
        }
        stream->buf_size = size;
    }
    
    stream->buf_pos = 0;
    stream->buf_end = 0;
    
    return 0;
}

/* Set buffering for a stream */
void nlibc_setbuf(NLIBC_FILE* stream, char* buf) {
    if (buf) {
        nlibc_setvbuf(stream, buf, _IOFBF, BUFSIZ);
    } else {
        nlibc_setvbuf(stream, NULL, _IONBF, 0);
    }
}

/* Error status */
int nlibc_ferror(NLIBC_FILE* stream) {
    return stream ? stream->error : 0;
}

/* EOF indicator */
int nlibc_feof(NLIBC_FILE* stream) {
    return stream ? stream->eof : 0;
}

/* Clear error and EOF indicators */
void nlibc_clearerr(NLIBC_FILE* stream) {
    if (stream) {
        stream->error = 0;
        stream->eof = 0;
    }
}

/* Get file descriptor associated with stream */
int nlibc_fileno(NLIBC_FILE* stream) {
    return stream ? stream->fd : -1;
}
