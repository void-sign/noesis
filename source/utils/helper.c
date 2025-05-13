/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// helper.c - Implementation of helper functions in the Noesis project

#include "../../include/utils/helper.h"
#include "../../include/utils/noesis_lib.h" // Add this include for noesis_print

// Forward declaration of internal function
static void custom_output(const char* message);

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
    // Reset system-related states
    // Example: Resetting global variables or system configurations
    // Add actual reset logic here as needed
    custom_output("System reset successfully.\n");
}

// Function to output a message using platform-specific methods
static void custom_output(const char* message) {
    // Implementation using noesis_print
    noesis_print(message);
}
