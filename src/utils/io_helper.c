/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// C helper for noesis_read
// This provides support functions for the assembly implementation

// Include noesis_libc with both short names and standard names
#include <noesis_libc.h>  // Include all noesis_libc functionality

// Helper function called from assembly to read from stdin into the buffer
// Returns the number of bytes read (excluding null terminator)
int write_test_to_buffer(char* buffer, int size) {
    // Validate buffer parameters
    if (buffer == NULL || size <= 1) {
        return 0; // Error - can't read into a buffer of size 0 or 1
    }

    // Since we can't use stdio, just write a test message to the buffer
    // This is a temporary solution until we have proper nlibc I/O
    char test_msg[] = "Test input data";
    int i = 0;
    
    while (test_msg[i] != '\0' && i < size - 1) {
        buffer[i] = test_msg[i];
        i++;
    }
    
    buffer[i] = '\0';
    return i; // Return the actual number of bytes copied

    // If fgets fails, return 0
    buffer[0] = '\0';
    return 0;
}
