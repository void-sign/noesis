/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Licensed under the Noesis License.
 */

#include "../../include/stdio/stdio.h"
#include "../../include/sys/syscall.h"
#include "../../include/unistd/unistd.h"
#include "../../include/string/string.h"

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

/* Implementation of remove function - delete a file */
int nlibc_remove(const char* pathname) {
    /* Use unlink syscall to remove the file */
    return nlibc_unlink(pathname);
}

/* Implementation of rename function - rename a file */
int nlibc_rename(const char* oldname, const char* newname) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* old path */
        "movq %2, %%rsi\n"    /* new path */
        "movq $0x2000034, %%rax\n"  /* rename syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (oldname), "r" (newname)
        : "rax", "rdi", "rsi"
    );
    
    return result;
}

/* Implementation of tmpfile function - create a temporary file */
FILE* nlibc_tmpfile(void) {
    char template[] = "/tmp/nlibc_tmpXXXXXX";
    int fd;
    
    /* Use mkstemp to create a unique temporary file */
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* template */
        "movq $0x20000C3, %%rax\n"  /* mkstemp syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (fd)
        : "r" (template)
        : "rax", "rdi"
    );
    
    if (fd < 0) {
        return NULL;
    }
    
    /* Create a FILE structure for the open file descriptor */
    FILE* fp = (FILE*)temp_malloc(sizeof(FILE));
    if (!fp) {
        nlibc_close(fd);
        return NULL;
    }
    
    /* Initialize the FILE structure */
    fp->fd = fd;
    fp->flags = _FILE_FLAG_READ | _FILE_FLAG_WRITE | _FILE_FLAG_OPEN;
    fp->error = 0;
    fp->eof = 0;
    fp->buffer = NULL;
    fp->buf_size = 0;
    fp->buf_pos = 0;
    fp->buf_end = 0;
    fp->buf_mode = _IONBF;
    
    /* Ensure the file is deleted when closed */
    /* This is implementation specific - on Unix systems we should use unlink */
    nlibc_unlink(template);
    
    return fp;
}

/* Implementation of tmpnam function - generate a temporary filename */
char* nlibc_tmpnam(char* s) {
    static char static_buf[L_tmpnam];
    static unsigned int tmpcount = 0;
    
    char* buffer = s ? s : static_buf;
    
    /* Simple implementation: create a path in /tmp with a unique counter */
    nlibc_sprintf(buffer, "/tmp/nlibc_%u_%u", (unsigned int)nlibc_getpid(), tmpcount++);
    
    return buffer;
}

/* Implementation of fileno function - get the file descriptor for a stream */
int nlibc_fileno(FILE* stream) {
    if (!stream) {
        return -1;
    }
    
    return stream->fd;
}

/* Implementation of setvbuf function - change stream buffering */
int nlibc_setvbuf(FILE* stream, char* buf, int mode, size_t size) {
    if (!stream) {
        return -1;
    }
    
    /* Free any existing buffer */
    if (stream->buffer && stream->buffer != buf && stream != nlibc_stdin && 
        stream != nlibc_stdout && stream != nlibc_stderr) {
        temp_free(stream->buffer, stream->buf_size);
        stream->buffer = NULL;
    }
    
    /* Set the buffering mode */
    stream->buf_mode = mode;
    
    if (mode == _IONBF) {
        /* No buffering */
        stream->buffer = NULL;
        stream->buf_size = 0;
    } else {
        /* Full or line buffering */
        if (size == 0) {
            size = BUFSIZ; /* Use default size if 0 is specified */
        }
        
        /* If buf is NULL, allocate a buffer */
        if (!buf) {
            stream->buffer = (char*)temp_malloc(size);
            if (!stream->buffer) {
                stream->buf_mode = _IONBF;
                stream->buf_size = 0;
                return -1;
            }
        } else {
            /* Use the provided buffer */
            stream->buffer = buf;
        }
        
        stream->buf_size = size;
    }
    
    /* Reset buffer pointers */
    stream->buf_pos = 0;
    stream->buf_end = 0;
    
    return 0;
}

/* Implementation of setbuf function - change stream buffering */
void nlibc_setbuf(FILE* stream, char* buf) {
    if (buf) {
        nlibc_setvbuf(stream, buf, _IOFBF, BUFSIZ);
    } else {
        nlibc_setvbuf(stream, NULL, _IONBF, 0);
    }
}
