/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
 * intent_shell.c - Shell script-based implementation of intent handling for Noesis
 */

// Define NOESIS_USE_SHORT_NAMES to enable short function names like 'out'
#define NOESIS_USE_SHORT_NAMES

// Include noesis_libc header
#include <noesis_libc.h>  // Include all noesis_libc functionality

#include "../../include/core/intent.h"
#include "../../include/core/memory.h" // For memory management
#include "../../include/utils/data.h"   // For storing and retrieving data

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
    // Initialize intention memory
    for (int i = 0; i < MAX_INTENTIONS; i++) {
        intention_memory[i] = NULL;
    }
    intention_count = 0;
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

// Shell command execution helper function
static int execute_shell_command(const char* command, char* output_buffer, int buffer_size) {
    FILE* pipe = popen(command, "r");
    if (!pipe) {
        return -1;
    }
    
    int bytes_read = 0;
    if (fgets(output_buffer, buffer_size - 1, pipe) != NULL) {
        bytes_read = noesis_strlen(output_buffer);
        
        // Remove newline if present
        if (bytes_read > 0 && output_buffer[bytes_read-1] == '\n') {
            output_buffer[bytes_read-1] = '\0';
            bytes_read--;
        }
    }
    
    pclose(pipe);
    return bytes_read;
}

// Add a function to handle input and output using shell script
void handle_io() {
    char input[256];
    int max_attempts = 5; // Maximum number of interaction attempts
    int attempts = 0;
    
    out("\nNOESIS Interactive Shell\n");
    out("Type 'exit' or 'quit' to exit\n");
    
    // Start the input/output loop
    while (attempts < max_attempts) {
        // Initialize buffer
        for (unsigned long i = 0; i < sizeof(input); i++) {
            input[i] = 0;
        }
        
        // Use shell script to prompt for and read input
        // The command will execute io_handler.fish with the readp operation
        int read_bytes = execute_shell_command("./scripts/fish/io_handler.fish readp \"Talk: \"", input, sizeof(input));
        
        // Handle error cases
        if (read_bytes < 0) {
            out("Error reading input\n");
            break;
        }
        
        // Handle empty input cases
        if (read_bytes == 0) {
            // For empty input, use default "help" command
            const char* default_cmd = "help";
            int cmd_len = 0;
            while (default_cmd[cmd_len]) {
                input[cmd_len] = default_cmd[cmd_len];
                cmd_len++;
            }
            input[cmd_len] = '\0';
            read_bytes = cmd_len;
        }
        
        // Ensure buffer is null-terminated
        input[sizeof(input) - 1] = '\0';
        
        // Log what we received from the user
        out("Input: ");
        out(input);
        out("\n");
    
        // Check for exit command first
        if (noesis_scmp(input, "exit") == 0 || noesis_scmp(input, "quit") == 0) {
            out("Exiting program.\n");
            break;
        }
        
        // Increment attempts counter for all types of input
        // Both empty inputs and "help" commands count as attempts
        attempts++;
        
        // Process valid input by learning from it
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
