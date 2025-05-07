// helper.h - Header file for utility functions in the Noesis project

#ifndef HELPER_H
#define HELPER_H

// Function to compare two strings (simple comparison)
int compare_strings(const char* str1, const char* str2);

// Function to copy a string from source to destination
void copy_string(char* dest, const char* src);

// Function to calculate the length of a string
int string_length(const char* str);

// Function to reset the system (generic helper)
void reset_system();

#endif // HELPER_H
