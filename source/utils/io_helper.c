/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// C helper for noesis_read
// This provides support functions for the assembly implementation

// Include standard C headers for fgets and stdin
#include <stdio.h>

// Include noesis_libc with both short names and standard names
#include <noesis_libc.h>  // Include all noesis_libc functionality

// Helper function called from assembly to read from stdin into the buffer
// Returns the number of bytes read (excluding null terminator)
int write_test_to_buffer(char* buffer, int size) {
    // Validate buffer parameters
    if (buffer == NULL || size <= 1) {
        return 0; // Error - can't read into a buffer of size 0 or 1
    }

    // Actually read from stdin
    if (fgets(buffer, size, stdin) != NULL) {
        // Remove trailing newline if present
        int length = len(buffer);
        if (length > 0 && buffer[length-1] == '\n') {
            buffer[length-1] = '\0';
            length--;
        }
        return length; // Return the actual number of bytes read
    }

    // If fgets fails, return 0
    buffer[0] = '\0';
    return 0;
}
