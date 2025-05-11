// noesis_lib.c - Implementation of Noesis-specific utility functions

#include "../../include/utils/noesis_lib.h"

#undef va_list
#undef va_start
#undef va_arg
#undef va_end

// Custom implementation for variable argument handling
typedef char* noesis_va_list;
#define noesis_va_start(ap, param) (ap = (noesis_va_list)&param + sizeof(param))
#define noesis_va_arg(ap, type) (*(type*)((ap += sizeof(type)) - sizeof(type)))
#define noesis_va_end(ap) (ap = 0) // Replaced NULL with 0 to avoid dependency

// Function to print a message to the terminal
void noesis_print(const char* message) {
    while (*message) {
        __asm__ volatile (
            "movq $0x2000004, %%rax\n"  // syscall: write on macOS
            "movq $1, %%rdi\n"          // file descriptor: stdout
            "movq %0, %%rsi\n"         // pointer to message
            "movq $1, %%rdx\n"         // write 1 byte
            "syscall\n"
            :
            : "r"(message)
            : "rax", "rdi", "rsi", "rdx"
        );
        message++;
    }
}

// Function to simulate getting the current time (in seconds since epoch)
unsigned long noesis_get_time() {
    static unsigned long simulated_time = 0;
    return ++simulated_time; // Increment and return a simulated time value
}

// Memory allocation using system calls
void* noesis_malloc(noesis_size_t size) {
    void* ptr;
    __asm__ volatile (
        "movq $0x20000c5, %%rax\n"  // syscall: mmap on macOS
        "movq $0, %%rdi\n"          // address: NULL (let the kernel decide)
        "movq %1, %%rsi\n"          // size
        "movq $3, %%rdx\n"          // protection: PROT_READ | PROT_WRITE
        "movq $0x1002, %%r10\n"     // flags: MAP_PRIVATE | MAP_ANON
        "movq $-1, %%r8\n"          // file descriptor: -1 (not used)
        "movq $0, %%r9\n"           // offset: 0
        "syscall\n"
        "movq %%rax, %0\n"          // store result in ptr
        : "=r"(ptr)
        : "r"(size)
        : "rax", "rdi", "rsi", "rdx", "r10", "r8", "r9"
    );
    return ptr;
}

// String duplication using noesis_malloc
char* noesis_strdup(const char* str) {
    noesis_size_t len = 0;
    while (str[len] != '\0') {
        len++;
    }
    char* copy = (char*)noesis_malloc(len + 1);
    for (noesis_size_t i = 0; i <= len; i++) {
        copy[i] = str[i];
    }
    return copy;
}

// Memory deallocation using system calls
void noesis_free(void* ptr) {
    __asm__ volatile (
        "movq $0x20000c6, %%rax\n"  // syscall: munmap on macOS
        "movq %0, %%rdi\n"          // address
        "movq $0, %%rsi\n"          // size (not needed for munmap)
        "syscall\n"
        :
        : "r"(ptr)
        : "rax", "rdi", "rsi"
    );
}

// Allocate memory using noesis_malloc
void* allocate_memory(noesis_size_t size) {
    return noesis_malloc(size);
}

// Static file descriptor for log file
static int log_fd = -1;

// Function to read input from the user
void noesis_read(char* buffer, unsigned long size) {
    unsigned long i = 0;
    char c;
    while (i < size - 1) {
        __asm__ volatile (
            "movq $0x2000003, %%rax\n"  // syscall: read on macOS
            "movq $0, %%rdi\n"          // file descriptor: stdin
            "movq %1, %%rsi\n"         // pointer to buffer
            "movq $1, %%rdx\n"         // read 1 byte
            "syscall\n"
            : "=r"(c)
            : "r"(&buffer[i])
            : "rax", "rdi", "rsi", "rdx"
        );
        if (c == '\n') {
            buffer[i] = '\0'; // Replace newline with null terminator
            break;
        }
        buffer[i++] = c;
    }
    buffer[i] = '\0'; // Ensure null termination if input exceeds buffer size

    // Trim trailing whitespace or non-printable characters
    while (i > 0 && (buffer[i - 1] == ' ' || buffer[i - 1] == '\t' || buffer[i - 1] == '\n' || buffer[i - 1] == '\r')) {
        buffer[--i] = '\0';
    }

    // Debug log to verify buffer content and length after reading
    unsigned long len = 0;
    while (buffer[len] != '\0') len++;
}

// Enhanced string comparison to handle null terminators and edge cases
int noesis_strcmp(const char* str1, const char* str2) {
    while (*str1 && *str2) {
        if (*str1 != *str2) {
            return *(unsigned char*)str1 - *(unsigned char*)str2;
        }
        str1++;
        str2++;
    }
    return *(unsigned char*)str1 - *(unsigned char*)str2;
}

// Function to format a string into a buffer
void noesis_sbuffer(char* buffer, unsigned long size, const char* format, ...) {
    noesis_va_list args;
    noesis_va_start(args, format);
    unsigned long i = 0;
    while (*format && i < size - 1) {
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
            while (len > 0 && i < size - 1) {
                buffer[i++] = temp[--len];
            }
        } else {
            buffer[i++] = *format++;
        }
    }
    buffer[i] = '\0';
    noesis_va_end(args);
}