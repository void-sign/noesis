/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// main.c - Entry point for the Noesis project

// Define NOESIS_USE_SHORT_NAMES to enable short function names like 'out'
#define NOESIS_USE_SHORT_NAMES

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

    // Version info only (title is now displayed by display_noesis_title in perception.c)
    out("Version 1.2.0 - May 2025\n");

    // Initialize intent system (this initializes the intent handling)
    init_intent_system();

    // Call the central control function from intent.c
    // This will handle input/output as the "consciousness" center
    out("Starting cognitive IO interface...\n\n");
    handle_io();  // This will show "Enter input: " and process user interactions

    out("\nNOESIS system terminated normally.\n");

    return 0;
}
