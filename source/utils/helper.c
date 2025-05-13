/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

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

// helper.c - Implementation of helper functions in the Noesis project

#include "../../include/utils/helper.h"

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