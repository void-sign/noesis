/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// io_functions.c - Pure C implementation of I/O operations previously in assembly

#include <unistd.h>  // For write and read syscalls
#include "../../include/utils/noesis_lib.h"

// Function to print a message to the terminal
// Replaces _noesis_print in io.s
void noesis_print(const char* message) {
    if (!message) return;
    
    // Calculate string length
    size_t length = 0;
    while (message[length] != '\0') {
        length++;
    }
    
    // Use write syscall directly
    write(STDOUT_FILENO, message, length);
}

// Function to read input into a buffer
// Replaces _noesis_read in io.s
int noesis_read(char* buffer, unsigned long size) {
    if (!buffer || size <= 1) {
        return 0; // Error - can't read into a buffer of size 0 or 1
    }
    
    // Use the helper function directly without assembly intermediary
    return write_test_to_buffer(buffer, size);
}

// Make sure the helper function prototype is available
extern int write_test_to_buffer(char* buffer, int size);
