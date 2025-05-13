/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */


// data.h - Header file for data management in the Noesis project

#ifndef DATA_H
#define DATA_H

#define NULL (void*)0

// Function to initialize the data system
void initialize_data();

// Function to load data into the system from a specified source
void load_data(char* source);

// Function to process data for further use by the system
void process_data();

// Function to save data to a specified destination
void save_data();

// Function to reset the data system
void reset_data();

#endif // DATA_H
