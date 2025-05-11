/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software under the following conditions:
 *
 * 1. The Software may be used, copied, modified, merged, published, distributed,
 *    sublicensed, and sold under the terms specified in this license.
 *
 * 2. Redistribution of the Software or modifications thereof must include the
 *    original copyright notice and this license.
 *
 * 3. Any use of the Software in production or commercial environments must provide
 *    clear attribution to the original author(s) as defined in the copyright notice.
 *
 * 4. The Software may not be used for any unlawful purpose, or in a way that could
 *    harm other humans, animals, or living beings, either directly or indirectly.
 *
 * 5. Any modifications made to the Software must be clearly documented and made
 *    available under the same Noesis License or a compatible license.
 *
 * 6. If the Software is a core component of a profit-generating system, 
 *    the user must donate 10% of the net profit directly resulting from such
 *    use to a recognized non-profit or charitable foundation supporting humans 
 *    or other living beings.
 */

// timer.c - Implementation of timer utilities in the Noesis project

#include "../../include/utils/timer.h"
#include "../../include/utils/noesis_lib.h"

// Variable to store the start time of the timer
static unsigned long start_time = 0;

// Function to initialize the timer system
void initialize_timer() {
    // Initialize the start time to 0
    start_time = 0;
    noesis_print("Timer initialized.\n");
}

// Function to start the timer
void start_timer() {
    // Set the start time to a simulated system tick value
    start_time = noesis_get_time(); // Use Noesis-specific time simulation
    noesis_print("Timer started.\n");
}

// Function to stop the timer and return the elapsed time
unsigned long stop_timer() {
    // Simulate stopping the timer and calculating elapsed time
    // In a real system, this would be replaced with actual time measurements
    if (start_time == 0) {
        return 0; // If the timer hasn't started, return 0
    }
    unsigned long elapsed_time = 100; // Placeholder for elapsed time (replace with actual calculation)
    start_time = 0; // Reset the timer after stopping
    return elapsed_time;
}

// Function to reset the timer
void reset_timer() {
    // Reset the timer by setting the start time to 0
    start_time = 0;
}
