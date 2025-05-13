/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

#include "../../include/utils/noesis_lib.h"

// C implementation of string length function (formerly in slen.s)
noesis_size_t noesis_strlen(const char* str) {
    const char* s = str;
    while (*s) {
        s++;
    }
    return s - str;
}

// C implementation of string comparison function (formerly in scomp.s)
int noesis_strcmp(const char* s1, const char* s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(unsigned char*)s1 - *(unsigned char*)s2;
}

// C implementation of memory copy function (formerly in mcopy.s)
void* noesis_memcpy(void* dest, const void* src, noesis_size_t n) {
    char* d = (char*)dest;
    const char* s = (const char*)src;
    
    for (noesis_size_t i = 0; i < n; i++) {
        d[i] = s[i];
    }
    
    return dest;
}

// Implementation of write_message (formerly in write.s)
void noesis_print(const char* message) {
    // Calculate length manually
    noesis_size_t length = noesis_strlen(message);
    
    // Use syscall (platform independent implementation)
    #ifdef __APPLE__
    // macOS syscall
    long syscall_num = 0x2000004; // write syscall for macOS
    #else
    // Linux syscall
    long syscall_num = 1; // write syscall for Linux
    #endif
    
    long result;
    __asm__ volatile (
        "movq %1, %%rax\n"    // syscall number
        "movq $1, %%rdi\n"    // file descriptor: stdout
        "movq %2, %%rsi\n"    // message buffer
        "movq %3, %%rdx\n"    // message length
        "syscall\n"
        "movq %%rax, %0\n"    // store result
        : "=r" (result)
        : "r" (syscall_num), "r" (message), "r" (length)
        : "rax", "rdi", "rsi", "rdx", "rcx", "r11"
    );
}

// C implementation of string search function (formerly in asm)
char* noesis_ss(const char* haystack, const char* needle) {
    if (!*needle) {
        return (char*)haystack;
    }
    
    while (*haystack) {
        const char* h = haystack;
        const char* n = needle;
        
        while (*h && *n && (*h == *n)) {
            h++;
            n++;
        }
        
        if (!*n) {
            return (char*)haystack;
        }
        
        haystack++;
    }
    
    return NOESIS_NULL;
}

// C implementation of noesis_read function (formerly in io.s)
int noesis_read(char* buffer, unsigned long size) {
    if (!buffer || size == 0) {
        return 0;
    }
    
    #ifdef __APPLE__
    // macOS syscall
    long syscall_num = 0x2000003; // read syscall for macOS
    #else
    // Linux syscall
    long syscall_num = 0; // read syscall for Linux
    #endif
    
    long bytes_read;
    __asm__ volatile (
        "movq %1, %%rax\n"    // syscall number
        "movq $0, %%rdi\n"    // file descriptor: stdin
        "movq %2, %%rsi\n"    // buffer
        "movq %3, %%rdx\n"    // buffer size
        "syscall\n"
        "movq %%rax, %0\n"    // store result
        : "=r" (bytes_read)
        : "r" (syscall_num), "r" (buffer), "r" (size)
        : "rax", "rdi", "rsi", "rdx", "rcx", "r11"
    );
    
    // Ensure null termination
    if (bytes_read > 0 && bytes_read < (long)size) {
        buffer[bytes_read] = '\0';
    }
    
    return bytes_read > 0 ? (int)bytes_read : 0;
}

// Implementation for write_test_to_buffer (formerly called by io.s)
int write_test_to_buffer(char* buffer, unsigned long size) {
    if (!buffer || size < 5) {
        return 0;
    }
    
    // Write "test" to the buffer
    buffer[0] = 't';
    buffer[1] = 'e';
    buffer[2] = 's';
    buffer[3] = 't';
    buffer[4] = '\0';
    
    return 4;
}
