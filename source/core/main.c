// main.c - Entry point for the Noesis project

#include "../../include/core/memory.h"
#include "../../include/core/perception.h"
#include "../../include/core/logic.h"
#include "../../include/core/emotion.h"
#include "../../include/utils/noesis_lib.h" // Include Noesis utility functions

// Main function: Entry point for the program
int main() {
    // Initialize the synthetic consciousness system
    initialize_memory();      // Initialize memory management
    initialize_perception();  // Initialize perception system
    initialize_logic();       // Initialize logic processing
    initialize_emotion();     // Initialize emotion simulation

    char input[256];

    // Main loop: continuously run the consciousness process
    while (1) {
        // Prompt for user input
        noesis_print("Enter input (or 'exit' to quit): ");
        noesis_read(input, sizeof(input)); // Simulated input function

        // Exit condition
        if (noesis_strcmp(input, "exit") == 0) {
            noesis_print("Exiting system.\n");
            break;
        }

        // Process perception: Gathering and processing sensory data
        process_perception();

        // Process logic: Make decisions and process information
        process_logic();

        // Process emotion: Simulate emotional responses
        process_emotion();

        // Manage memory: Handle memory allocation and cleanup
        manage_memory();
    }

    // Program will never reach here, since it's in an infinite loop
    return 0;
}
