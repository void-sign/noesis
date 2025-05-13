/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// timer.h - Header file for timer utilities in the Noesis project

#ifndef TIMER_H
#define TIMER_H

// Function to initialize the timer system
void initialize_timer();

// Function to start the timer
void start_timer();

// Function to stop the timer and return the elapsed time
unsigned long stop_timer();

// Function to reset the timer
void reset_timer();

#endif // TIMER_H
