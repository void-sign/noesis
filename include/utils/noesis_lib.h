/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
 * noesis_lib.h - Header file for noesis utility functions
 */

#ifndef NOESIS_LIB_H
#define NOESIS_LIB_H

// Include noesis_api.h for common type definitions
#include "../api/noesis_api.h"

// Use noesis_size_t from noesis_api.h

// Define NOESIS_NULL as a replacement for NULL
#ifndef NOESIS_NULL
#define NOESIS_NULL ((void*)0)
#endif

// Function to write a message to the terminal (C implementation)
void noesis_print(const char* message);

// Function to simulate getting the current time (in seconds since epoch)
unsigned long noesis_get_time();

// Memory allocation function
void* noesis_malloc(noesis_size_t size);

// String duplication function
char* noesis_strdup(const char* str);

// Memory deallocation function
void noesis_free(void* ptr);

// Function to read input from the user (C implementation)
// Returns the number of bytes read (or 0 on error)
int noesis_read(char* buffer, unsigned long size);

// Function to compare two strings (C implementation)
int noesis_strcmp(const char* str1, const char* str2);

// Function for calculating string length (C implementation)
noesis_size_t noesis_strlen(const char* str);

// Function to copy memory (C implementation)
void* noesis_memcpy(void* dest, const void* src, noesis_size_t n);

// Function to format a string into a buffer
void noesis_sbuffer(char* buffer, unsigned long size, const char* format, ...);

// Define custom variable argument handling
typedef char* noesis_va_list;
#define noesis_va_start(ap, param) (ap = (noesis_va_list)&param + sizeof(param))
#define noesis_va_arg(ap, type) (*(type*)((ap += sizeof(type)) - sizeof(type)))
#define noesis_va_end(ap) (ap = 0) // Replaced NULL with 0 to avoid dependency

// String search function (C implementation)
char *noesis_ss(const char *haystack, const char *needle);

// Alias functions
char* noesis_sdup(const char* s);
int noesis_scmp(const char* s1, const char* s2);
void noesis_printf(const char* format, ...);

// Function to read a line of text
char* noesis_read_line(void);

#endif // NOESIS_LIB_H
