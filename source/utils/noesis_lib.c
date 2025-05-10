// noesis_lib.c - Implementation of Noesis-specific utility functions

#include "../../include/utils/noesis_lib.h"

// Function to simulate getting the current time (in seconds since epoch)
unsigned long noesis_get_time() {
    static unsigned long simulated_time = 0;
    return ++simulated_time; // Increment and return a simulated time value
}
