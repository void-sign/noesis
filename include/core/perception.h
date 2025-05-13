/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
 * perception.h - Header file for perception processing
 */

#ifndef PERCEPTION_H
#define PERCEPTION_H

// Function declarations for perception processing
void initialize_perception();

// Function to process sensory input and convert it into usable data
void process_perception();

// Function to handle sensory data and update the internal state
void update_perception();

// Function to reset the perception system to its initial state
void reset_perception();

// API functions used in noesis_api.c
void* perception_init();
void perception_cleanup(void* module);
void* perception_process(void* module, const char* input, unsigned long input_length);

#endif // PERCEPTION_H
