```c
// helper.c - Implementation of helper functions in the Noesis project

#include "utils/helper.h"

// Function to compare two strings (simple comparison)
int compare_strings(const char* str1, const char* str2) {
    // Compare strings character by character
    while (*str1 && (*str1 == *str2)) {
        str1++;
        str2++;
    }
    return *(unsigned char*)str1 - *(unsigned char*)str2;
}

// Function to copy a string from source to destination
void copy_string(char* dest, const char* src) {
    // Copy characters from src to dest until null terminator is found
    while ((*dest++ = *src++)) {
        // Copy each character from src to dest
    }
}

// Function to calculate the length of a string
int string_length(const char* str) {
    int length = 0;
    // Iterate through each character in the string to find its length
    while (*str++) {
        length++;
    }
    return length;
}

// Function to reset the system (generic helper)
void reset_system() {
    // Placeholder function to reset system-related states
    // Implement system-wide reset behavior here
}
```
