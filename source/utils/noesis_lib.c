/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software under the following conditions:
 *
 * 1. The Software may be used, copied, modified, merged, published, distributed,
 *    sublicensed, and sold under the terms specified in this license.
 *
 * 2. Redistribution of the Software or modifications thereof must include the
 *    original copyright notice and this license.
 *
 * 3. Any use of the Software in production or commercial environments must provide
 *    clear attribution to the original author(s) as defined in the copyright notice.
 *
 * 4. The Software may not be used for any unlawful purpose, or in a way that could
 *    harm other humans, animals, or living beings, either directly or indirectly.
 *
 * 5. Any modifications made to the Software must be clearly documented and made
 *    available under the same Noesis License or a compatible license.
 *
 * 6. If the Software is a core component of a profit-generating system, 
 *    the user must donate 10% of the net profit directly resulting from such
 *    use to a recognized non-profit or charitable foundation supporting humans 
 *    or other living beings.
 */

// noesis_lib.c - Implementation of Noesis-specific utility functions

#include "../../include/utils/noesis_lib.h"

// External assembly functions for I/O operations
extern void noesis_print(const char* message);
extern int noesis_read(char* buffer, unsigned long size);

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

// Custom implementation of strstr
char* noesis_ss(const char* haystack, const char* needle) {
    if (!*needle) {
        return (char*)haystack;
    }
    for (; *haystack; haystack++) {
        const char* h = haystack;
        const char* n = needle;
        while (*h && *n && *h == *n) {
            h++;
            n++;
        }
        if (!*n) {
            return (char*)haystack;
        }
    }
    return NOESIS_NULL;
}

// Merged functions from custom_lib.c into noesis_lib.c

// Custom implementation of printf-like function
void noesis_write(const char* format, ...) {
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

// Function to compare two strings
int noesis_scmp(const char* str1, const char* str2) {
    while (*str1 && (*str1 == *str2)) {
        str1++;
        str2++;
    }
    return *(unsigned char*)str1 - *(unsigned char*)str2;
}