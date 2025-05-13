/* 
 * This file provides implementations for the noesis_libc functions
 * without relying on the standard C library headers
 */

/* Define necessary types that would normally come from stdio.h */
typedef unsigned long size_t;
typedef long ssize_t;
typedef __builtin_va_list va_list;

typedef struct _NLIBC_FILE {
    int fd;          /* File descriptor */
    int flags;       /* File flags */
    int error;       /* Error indicator */
    int eof;         /* EOF indicator */
    char* buffer;    /* I/O buffer */
    size_t buf_size; /* Buffer size */
    size_t buf_pos;  /* Current position in buffer */
    size_t buf_end;  /* End of valid data in buffer */
    int buf_mode;    /* Buffering mode */
} NLIBC_FILE;

#define va_start(v,l) __builtin_va_start(v,l)
#define va_end(v) __builtin_va_end(v)
#define va_arg(v,l) __builtin_va_arg(v,l)
#define NULL ((void *)0)

/* Low-level I/O Functions */
extern ssize_t write(int fd, const void *buf, size_t count);

/* I/O Functions */
int nlibc_printf(const char* format, ...) {
    // Simple direct implementation that writes to stdout (fd 1)
    const int STDOUT_FD = 1;
    
    // Handle only simple strings without formatting
    if (format) {
        size_t len = 0;
        while (format[len]) len++;
        write(STDOUT_FD, format, len);
    }
    
    return 0; // Return success
}

int nlibc_fprintf(NLIBC_FILE* stream, const char* format, ...) {
    // Simple implementation that ignores stream and just uses standard output
    return nlibc_printf(format);
}

/* Add other implementations as needed */

/* Memory Management */
void* nlibc_malloc(size_t size) {
    // Simple implementation using sbrk (we declare it here)
    extern void* sbrk(long increment);
    
    // Align size to proper boundary
    size = (size + 7) & ~7;
    
    // Request memory from the system
    void* ptr = sbrk(size);
    if (ptr == (void*)-1)
        return NULL;
    
    return ptr;
}

void nlibc_free(void* ptr) {
    // This is a simple stub - in a real implementation 
    // we would need to track and reuse memory
    (void)ptr; // Avoid unused parameter warning
}

/* Define global file handles */
NLIBC_FILE* nlibc_stdin = NULL;
NLIBC_FILE* nlibc_stdout = NULL;
NLIBC_FILE* nlibc_stderr = NULL;

/* Initialize basic file handles for stdin/stdout/stderr */
static NLIBC_FILE _stdin  = {0}; // fd 0
static NLIBC_FILE _stdout = {1}; // fd 1
static NLIBC_FILE _stderr = {2}; // fd 2

/* Initialize function to set up the file handles */
void __attribute__((constructor)) nlibc_init(void) {
    nlibc_stdin = &_stdin;
    nlibc_stdout = &_stdout;
    nlibc_stderr = &_stderr;
}