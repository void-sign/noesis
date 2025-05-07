// main.c - Entry point for the Noesis project

#include "../../include/core/memory.h"
#include "../../include/core/perception.h"
#include "../../include/core/logic.h"
#include "../../include/core/emotion.h"

// Main function: Entry point for the program
int main() {
    // Initialize the synthetic consciousness system
    initialize_memory();      // Initialize memory management
    initialize_perception();  // Initialize perception system
    initialize_logic();       // Initialize logic processing
    initialize_emotion();     // Initialize emotion simulation

    // Main loop: continuously run the consciousness process
    while (1) {
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
