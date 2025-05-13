/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
 * intent.c - Implementation of intent handling in the Noesis project
 */

 // Define NOESIS_USE_SHORT_NAMES to enable short function names like 'out'
#define NOESIS_USE_SHORT_NAMES

// Include noesis_libc header
#include <noesis_libc.h>  // Include all noesis_libc functionality

#include "../../include/core/intent.h"
#include "../../include/core/memory.h" // For memory management
#include "../../include/utils/data.h"   // For storing and retrieving data
#include "../../include/utils/noesis_lib.h" // For noesis_scmp and noesis_ss
#include "../../include/utils/io_functions.h" // For custom I/O functions

#ifndef NULL
#define NULL ((void*)0)
#endif

// Memory for storing intentions
#define MAX_INTENTIONS 100
static Intention *intention_memory[MAX_INTENTIONS];
static int intention_count = 0;

// Custom function to get UTC timestamp
static void log_with_timestamp(const char *message, const char *description) {
    (void)message; // Mark as unused
    (void)description; // Mark as unused
    unsigned long seconds_since_epoch = noesis_get_time(); // Simulated time function
    unsigned long days = seconds_since_epoch / 86400;
    unsigned long seconds_in_day = seconds_since_epoch % 86400;
    unsigned long hours = seconds_in_day / 3600;
    unsigned long minutes = (seconds_in_day % 3600) / 60;
    unsigned long seconds = seconds_in_day % 60;

    char timestamp[32]; // Format: Day HH:MM:SS
    noesis_sbuffer(timestamp, sizeof(timestamp), "Day %lu %02lu:%02lu:%02lu", days, hours, minutes, seconds);
}

// Initialize the Intent system
void init_intent_system(void) {
    // Removed debug log for initialization
}

// Create a new intention
Intention *create_intention(const char *description, int priority) {
    Intention *new_intention = (Intention *)noesis_malloc(sizeof(Intention));
    if (!new_intention) {
        return NOESIS_NULL;
    }
    new_intention->description = noesis_strdup(description);
    new_intention->priority = priority;
    new_intention->is_active = 0;
    return new_intention;
}

// Activate an intention
void activate_intention(Intention *intention) {
    if (intention) {
        intention->is_active = 1;
        log_with_timestamp("Activated intention", intention->description);
    }
}

// Deactivate an intention
void deactivate_intention(Intention *intention) {
    if (intention) {
        intention->is_active = 0;
        log_with_timestamp("Deactivated intention", intention->description);
    }
}

// Free an intention
void free_intention(Intention *intention) {
    if (intention) {
        noesis_free(intention->description);
        noesis_free(intention);
    }
}

// Learn from input and create or modify intentions
void learn_from_input(const char *input) {
    // Analyze input and decide on a new intention or modify an existing one
    for (int i = 0; i < intention_count; i++) {
        if (noesis_ss(intention_memory[i]->description, input)) {
            // Boost priority if input matches an existing intention
            intention_memory[i]->priority++;
            log_with_timestamp("Updated intention priority", intention_memory[i]->description);
            return;
        }
    }

    // Create a new intention if no match is found
    if (intention_count < MAX_INTENTIONS) {
        Intention *new_intention = create_intention(input, 1); // Default priority 1
        if (new_intention) {
            intention_memory[intention_count++] = new_intention;
            log_with_timestamp("Learned new intention", new_intention->description);
        }
    } else {
        log_with_timestamp("Memory full, cannot learn new intention", "");
    }
}

// Free all stored intentions
void free_all_intentions(void) {
    for (int i = 0; i < intention_count; i++) {
        free_intention(intention_memory[i]);
    }
    intention_count = 0;
}

// Add a function to handle input and output using noesis_lib
void handle_io() {
    char input[256];
    int max_attempts = 10; // Add maximum attempts to prevent infinite loops
    int attempts = 0;
    int read_bytes = 0;
    
    // Clear input buffer before first use
    for (int i = 0; i < 256; i++) {
        input[i] = 0;
    }
    
    out("Debug: Starting handle_io function\n");
    
    while (attempts < max_attempts) {
        out("Enter input: ");
        
        // Call noesis_read to read a full line of input
        read_bytes = noesis_read(input, sizeof(input));
        
        if (read_bytes < 0 || read_bytes >= 255) {
            // Error or buffer overflow, break the loop
            out("Input error detected, exiting.\n");
            break;
        }
        
        if (read_bytes == 0) {
            // No input received, prompt again
            out("No input received, please try again.\n");
            continue;
        }
        
        // Remove newline if present
        for (int i = 0; i < read_bytes; i++) {
            if (input[i] == '\n' || input[i] == '\r') {
                input[i] = '\0';
                read_bytes = i;
                break;
            }
        }
        
        // Ensure null termination
        input[read_bytes] = '\0';
        
        attempts++;
        
        // Check for exit command with safe string comparison
        int is_exit = 1;
        if (read_bytes == 4) { // "exit" has 4 characters
            const char* exit_str = "exit";
            for (int i = 0; i < 4; i++) {
                if (input[i] != exit_str[i]) {
                    is_exit = 0;
                    break;
                }
            }
        } else {
            is_exit = 0;
        }
        
        if (is_exit) {
            out("Exiting program.\n");
            break;
        }
        
        // Process valid input
        out("You entered: ");
        out(input);
        out("\n");
        
        // Learn from valid input
        learn_from_input(input);
    }
    
    if (attempts >= max_attempts) {
        out("Maximum input attempts reached, exiting.\n");
    }
}

// API functions used in noesis_api.c
void* intent_init() {
    init_intent_system();
    return (void*)1; // Non-NULL pointer to indicate success
}

void intent_cleanup(void* module) {
    // Clean up resources
    (void)module; // Avoid unused parameter warning
    free_all_intentions();
}

void* intent_process(void* module, void* input) {
    // Process input and generate intentions
    (void)module; // Avoid unused parameter warning

    // Create a sample intention based on the input
    static Intention *result = NULL;

    if (result) {
        free_intention(result);
    }

    const char* input_str = (const char*)input;
    if (input_str && *input_str) {
        result = create_intention(input_str, 1);
        activate_intention(result);
    } else {
        result = create_intention("default intention", 0);
    }

    return result;
}

const char* intent_to_string(void* module, void* intent_result) {
    (void)module; // Avoid unused parameter warning

    Intention *intent = (Intention*)intent_result;
    static char result_buffer[256];

    if (intent && intent->description) {
        noesis_sbuffer(result_buffer, sizeof(result_buffer), 
                     "Intent: %s (Priority: %d, Active: %d)", 
                     intent->description, intent->priority, intent->is_active);
    } else {
        noesis_sbuffer(result_buffer, sizeof(result_buffer), "No intent available");
    }

    return result_buffer;
}
