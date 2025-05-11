// custom_stdlib.c - Custom implementation of library functions

#include "../../include/utils/noesis_lib.h"

// Custom implementation
int noesis_scmp(const char* s1, const char* s2) {
    while (*s1 && *s2) {
        if (*s1 != *s2) {
            return *(unsigned char*)s1 - *(unsigned char*)s2;
        }
        s1++;
        s2++;
    }
    return *(unsigned char*)s1 - *(unsigned char*)s2;
}

// Custom implementation of strdup
char* noesis_sdup(const char* s) {
    unsigned long len = 0;
    while (s[len] != '\0') {
        len++;
    }
    char* copy = (char*)noesis_malloc(len + 1);
    for (unsigned long i = 0; i <= len; i++) {
        copy[i] = s[i];
    }
    return copy;
}

// Custom implementation of printf-like function
void noesis_printf(const char* format, ...) {
    noesis_va_list args;
    noesis_va_start(args, format);
    char buffer[1024];
    unsigned long i = 0;
    while (*format && i < sizeof(buffer) - 1) {
        if (*format == '%' && *(format + 1) == 'd') {
            format += 2;
            int value = noesis_va_arg(args, int);
            char temp[12];
            int len = 0;
            if (value < 0) {
                buffer[i++] = '-';
                value = -value;
            }
            do {
                temp[len++] = '0' + (value % 10);
                value /= 10;
            } while (value && len < 11);
            while (len > 0 && i < sizeof(buffer) - 1) {
                buffer[i++] = temp[--len];
            }
        } else {
            buffer[i++] = *format++;
        }
    }
    buffer[i] = '\0';
    noesis_va_end(args);
    noesis_print(buffer);
}

// Custom implementation of malloc
void* noesis_malloc(unsigned long size) {
    void* ptr;
    asm volatile (
        "mov $9, %%rax;" // syscall number for mmap
        "mov $0, %%rdi;" // addr = NULL
        "mov %[size], %%rsi;" // length = size
        "mov $3, %%rdx;" // prot = PROT_READ | PROT_WRITE
        "mov $34, %%r10;" // flags = MAP_PRIVATE | MAP_ANONYMOUS
        "mov $-1, %%r8;" // fd = -1
        "mov $0, %%r9;" // offset = 0
        "syscall;"
        "mov %%rax, %[ptr];" // store result in ptr
        : [ptr] "=r" (ptr)
        : [size] "r" (size)
        : "rax", "rdi", "rsi", "rdx", "r10", "r8", "r9"
    );
    return ptr;
}

// Custom implementation of free
void noesis_free(void* ptr) {
    asm volatile (
        "mov $11, %%rax;" // syscall number for munmap
        "movq %[ptr], %%rdi;" // addr = ptr (explicitly cast to 64-bit)
        "mov $0x1000, %%rsi;" // length = 4096 (page size)
        "syscall;"
        :
        : [ptr] "r" ((unsigned long)ptr) // cast ptr to 64-bit
        : "rax", "rdi", "rsi"
    );
}
