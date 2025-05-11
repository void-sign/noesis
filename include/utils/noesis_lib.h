// noesis_lib.h - Header file for Noesis-specific utility functions

#ifndef NOESIS_LIB_H
#define NOESIS_LIB_H

// Define NOESIS_NULL as a replacement for NULL
#ifndef NOESIS_NULL
#define NOESIS_NULL ((void*)0)
#endif

// Define noesis_size_t as an unsigned integer type
typedef unsigned long noesis_size_t;

// Function to write a message to the terminal
void noesis_print(const char* message);

// Function to simulate getting the current time (in seconds since epoch)
unsigned long noesis_get_time();

// Log function with variable argument support
void noesis_log(const char* format, ...);

// Memory allocation function
void* noesis_malloc(noesis_size_t size);

// String duplication function
char* noesis_strdup(const char* str);

// Memory deallocation function
void noesis_free(void* ptr);

// Function to read input from the user
void noesis_read(char* buffer, unsigned long size);

// Function to compare two strings
int noesis_strcmp(const char* str1, const char* str2);

#endif // NOESIS_LIB_H
