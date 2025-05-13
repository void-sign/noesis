/* 
 * This file provides bare-minimum implementations for the noesis_libc functions
 * without relying on the standard C library
 */

/* Basic type definitions needed for our implementations */
typedef unsigned long size_t;
typedef long ssize_t;

/* Define our own file structure rather than using FILE */
typedef struct {
    int fd;          /* File descriptor */
    int flags;       /* File flags */
    int error;       /* Error indicator */
    int eof;         /* EOF indicator */
} NLIBC_FILE;

/* Define NULL macro */
#define NULL ((void*)0)

/* Define va_list and related macros */
typedef __builtin_va_list va_list;
#define va_start(v,l) __builtin_va_start(v,l)
#define va_end(v) __builtin_va_end(v)
#define va_arg(v,l) __builtin_va_arg(v,l)

/* File operations syscalls */
#define O_RDONLY    0x0000
#define O_WRONLY    0x0001
#define O_RDWR      0x0002
#define O_CREAT     0x0200
#define O_TRUNC     0x0400
#define O_APPEND    0x0008

/* System-specific open function - defined using raw syscall */
static int syscall_open(const char* pathname, int flags, int mode) {
    int fd;
#ifdef __APPLE__
    /* macOS syscall convention */
    __asm__ volatile(
        "movq $0x2000005, %%rax\n" /* macOS open syscall number */
        "movq %1, %%rdi\n"         /* pathname */
        "movl %2, %%esi\n"         /* flags */
        "movl %3, %%edx\n"         /* mode */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r"(fd)
        : "r"(pathname), "r"(flags), "r"(mode)
        : "%rax", "%rdi", "%rsi", "%rdx"
    );
#else
    /* Linux syscall convention */
    __asm__ volatile(
        "movq $2, %%rax\n"     /* Linux open syscall number */
        "movq %1, %%rdi\n"     /* pathname */
        "movl %2, %%esi\n"     /* flags */
        "movl %3, %%edx\n"     /* mode */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r"(fd)
        : "r"(pathname), "r"(flags), "r"(mode)
        : "%rax", "%rdi", "%rsi", "%rdx"
    );
#endif
    return fd;
}

/* System-specific close function - defined using raw syscall */
static int syscall_close(int fd) {
    int ret;
#ifdef __APPLE__
    /* macOS syscall convention */
    __asm__ volatile(
        "movq $0x2000006, %%rax\n" /* macOS close syscall number */
        "movl %1, %%edi\n"         /* fd */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r"(ret)
        : "r"(fd)
        : "%rax", "%rdi"
    );
#else
    /* Linux syscall convention */
    __asm__ volatile(
        "movq $3, %%rax\n"     /* Linux close syscall number */
        "movl %1, %%edi\n"     /* fd */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r"(ret)
        : "r"(fd)
        : "%rax", "%rdi"
    );
#endif
    return ret;
}

/* System-specific write function - defined using raw syscall to avoid libc dependency */
static long syscall_write(int fd, const void* buf, size_t count) {
    long ret;
#ifdef __APPLE__
    /* macOS syscall convention */
    __asm__ volatile(
        "movq $0x2000004, %%rax\n" /* macOS write syscall number */
        "movq %1, %%rdi\n"         /* fd */
        "movq %2, %%rsi\n"         /* buffer */
        "movq %3, %%rdx\n"         /* count */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r"(ret)
        : "r"((long)fd), "r"(buf), "r"(count)
        : "%rax", "%rdi", "%rsi", "%rdx"
    );
#else
    /* Linux syscall convention */
    __asm__ volatile(
        "movq $1, %%rax\n"     /* Linux write syscall number */
        "movq %1, %%rdi\n"     /* fd */
        "movq %2, %%rsi\n"     /* buffer */
        "movq %3, %%rdx\n"     /* count */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r"(ret)
        : "r"((long)fd), "r"(buf), "r"(count)
        : "%rax", "%rdi", "%rsi", "%rdx"
    );
#endif
    return ret;
}

/* String length function */
static size_t strlen_internal(const char* s) {
    const char* p = s;
    while (*p) p++;
    return p - s;
}

/* I/O Functions */
int nlibc_printf(const char* format, ...) {
    /* Simple implementation that only handles string literals without formatting */
    if (!format) return 0;
    
    /* Get string length and write to stdout */
    size_t len = strlen_internal(format);
    return (int)syscall_write(1, format, len);
}

int nlibc_fprintf(NLIBC_FILE* stream, const char* format, ...) {
    /* Simple implementation that uses the stream's fd */
    if (!format || !stream) return 0;
    
    int fd = stream->fd;
    size_t len = strlen_internal(format);
    return (int)syscall_write(fd, format, len);
}

/* Add other implementations as needed */

/* Memory Management */
void* nlibc_malloc(size_t size) {
    /* Simple implementation using sbrk syscall */
    long ret;
    void* ptr;

#ifdef __APPLE__
    /* macOS brk syscall convention - we use 0x2000036 for sbrk(0) to get current brk value */
    __asm__ volatile(
        "movq $0x2000036, %%rax\n" /* macOS brk syscall number */
        "xorq %%rdi, %%rdi\n"      /* 0 parameter to get current brk */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r"(ret)
        :
        : "%rax", "%rdi"
    );
    
    ptr = (void*)ret;
    
    /* Now increment the brk by size */
    __asm__ volatile(
        "movq $0x2000036, %%rax\n" /* macOS brk syscall number */
        "addq %1, %%rdi\n"         /* ptr + size */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r"(ret)
        : "r"(size), "r"(ptr)
        : "%rax", "%rdi"
    );
#else
    /* Linux brk syscall convention */
    __asm__ volatile(
        "movq $12, %%rax\n"    /* Linux brk syscall number */
        "xorq %%rdi, %%rdi\n"  /* 0 parameter to get current brk */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r"(ptr)
        :
        : "%rax", "%rdi"
    );
    
    /* Now increment the brk by size */
    __asm__ volatile(
        "movq $12, %%rax\n"    /* Linux brk syscall number */
        "addq %1, %2\n"
        "movq %2, %%rdi\n"     /* new brk value = current + size */
        "syscall\n"
        : "=r"(ret)
        : "r"(size), "r"(ptr)
        : "%rax", "%rdi"
    );
#endif

    return ptr;
}

void nlibc_free(void* ptr) {
    /* Simple stub - with this implementation we don't actually free memory */
    (void)ptr; /* Avoid unused parameter warning */
}

/* Define global file handles */
NLIBC_FILE* nlibc_stdin = NULL;
NLIBC_FILE* nlibc_stdout = NULL;
NLIBC_FILE* nlibc_stderr = NULL;

/* Initialize basic file handles for stdin/stdout/stderr */
static NLIBC_FILE _stdin  = {0, 0, 0, 0};  /* fd 0, flags 0, error 0, eof 0 */
static NLIBC_FILE _stdout = {1, 0, 0, 0};  /* fd 1, flags 0, error 0, eof 0 */
static NLIBC_FILE _stderr = {2, 0, 0, 0};  /* fd 2, flags 0, error 0, eof 0 */

/* Initialize function to set up the file handles */
void __attribute__((constructor)) nlibc_init(void) {
    nlibc_stdin = &_stdin;
    nlibc_stdout = &_stdout;
    nlibc_stderr = &_stderr;
}

/* String operations - implemented without standard library */
char* nlibc_strcpy(char* dest, const char* src) {
    char* original_dest = dest;
    
    if (!dest || !src) return dest;
    
    while ((*dest++ = *src++));
    
    return original_dest;
}

size_t nlibc_strlen(const char* s) {
    if (!s) return 0;
    
    return strlen_internal(s);
}

int nlibc_strcmp(const char* s1, const char* s2) {
    if (!s1 || !s2) return s1 ? 1 : (s2 ? -1 : 0);
    
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(unsigned char*)s1 - *(unsigned char*)s2;
}

void* nlibc_memcpy(void* dest, const void* src, size_t n) {
    char* d = (char*)dest;
    const char* s = (const char*)src;
    
    if (!dest || !src) return dest;
    
    while (n--) {
        *d++ = *s++;
    }
    
    return dest;
}