// noesis_lib.h - Header file for Noesis-specific utility functions

#ifndef NOESIS_LIB_H
#define NOESIS_LIB_H

// Define NOESIS_NULL as a replacement for NULL
#ifndef NOESIS_NULL
#define NOESIS_NULL ((void*)0)
#endif

// Function to simulate printing (character by character)
void noesis_print(const char* message);

// Function to simulate getting the current time (in seconds since epoch)
unsigned long noesis_get_time();

#endif // NOESIS_LIB_H
