// noesis_lib.c - Implementation of Noesis-specific utility functions

#include "../../include/utils/noesis_lib.h"

// Function to simulate printing (character by character)
void noesis_print(const char* message) {
    while (*message) {
        // Simulate printing each character (e.g., to a serial console)
        volatile char ch = *message; // Use a volatile variable to simulate output
        (void)ch; // Prevent unused variable warning
        message++;
    }
}

// Function to simulate getting the current time (in seconds since epoch)
unsigned long noesis_get_time() {
    static unsigned long simulated_time = 0;
    return ++simulated_time; // Increment and return a simulated time value
}
