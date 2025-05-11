// noesis_lib.c - Implementation of Noesis-specific utility functions

#include "../../include/utils/noesis_lib.h"

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

// Log function with variable argument support
void noesis_log(const char* format, ...) {
    // Simple implementation to print the log message
    const char* prefix = "[LOG]: ";
    noesis_print(prefix);
    noesis_print(format);
}

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
        if (c == '\n') break;
        buffer[i++] = c;
    }
    buffer[i] = '\0';
}

// Function to compare two strings
int noesis_strcmp(const char* str1, const char* str2) {
    while (*str1 && (*str1 == *str2)) {
        str1++;
        str2++;
    }
    return *(unsigned char*)str1 - *(unsigned char*)str2;
}
