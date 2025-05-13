/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// main.c - Entry point for the Noesis project

// Include noesis_libc header
#include <noesis_libc.h>  // Include all noesis_libc functionality

// Then include project headers
#include "../../include/core/memory.h"
#include "../../include/core/perception.h"
#include "../../include/core/logic.h"
#include "../../include/core/emotion.h"
#include "../../include/utils/noesis_lib.h" // Include Noesis utility functions
#include "../../include/core/intent.h" // Include declaration for handle_io

// Main function: Entry point for the program
int main() {
    // Initialize the synthetic consciousness system
    initialize_memory();      // Initialize memory management
    initialize_perception();  // Initialize perception system
    initialize_logic();       // Initialize logic processing
    initialize_emotion();     // Initialize emotion simulation

    // Welcome message
    out("NOESIS Synthetic Consciousness System\n");
    out("====================================\n");
    out("Version 0.1.2 - May 2025\n\n");

    // Create a buffer for user input
    char buffer[128] = {0};

    out("Enter a command or type 'help' for assistance.\n");
    out("noesis> ");

    // Read user input
    int bytes_read = noesis_read(buffer, sizeof(buffer));

    if (bytes_read > 0) {
        out("You entered: %s\n", buffer);

        // Process the command (placeholder for future implementation)
        if (cmp(buffer, "help") == 0) {
            out("Available commands:\n");
            out("  help - Display this help message\n");
            out("  exit - Exit the program\n");
        }
    } else {
        out("No input received.\n");
    }

    out("\nNOESIS system terminated normally.\n");

    return 0;
}
