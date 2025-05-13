/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Licensed under the Noesis License.
 */

#include "../../include/stdlib/stdlib.h"
#include "../../include/string/string.h"

/* Helper function to reverse string in-place */
static void reverse_str(char* start, char* end) {
    char temp;
    while (start < end) {
        temp = *start;
        *start++ = *end;
        *end-- = temp;
    }
}

/* 
 * Convert an integer to a string with the specified base
 * Supports bases from 2 to 36
 * Returns the original buffer pointer
 */
char* nlibc_itoa(int value, char* str, int base) {
    /* Validate arguments */
    if (str == NULL || base < 2 || base > 36) {
        return NULL;
    }
    
    int i = 0;
    int is_negative = 0;
    
    /* Handle 0 explicitly */
    if (value == 0) {
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }
    
    /* Handle negative numbers for base 10 */
    if (value < 0 && base == 10) {
        is_negative = 1;
        value = -value;
    }
    
    /* Convert to the specified base */
    while (value != 0) {
        int remainder = value % base;
        str[i++] = (remainder < 10) ? (remainder + '0') : (remainder - 10 + 'a');
        value = value / base;
    }
    
    /* Add negative sign if needed */
    if (is_negative) {
        str[i++] = '-';
    }
    
    /* Null terminate the string */
    str[i] = '\0';
    
    /* Reverse the string */
    reverse_str(str, str + i - 1);
    
    return str;
}

/* 
 * Convert a long integer to a string with the specified base
 * Supports bases from 2 to 36
 * Returns the original buffer pointer
 */
char* nlibc_ltoa(long value, char* str, int base) {
    /* Validate arguments */
    if (str == NULL || base < 2 || base > 36) {
        return NULL;
    }
    
    int i = 0;
    int is_negative = 0;
    
    /* Handle 0 explicitly */
    if (value == 0) {
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }
    
    /* Handle negative numbers for base 10 */
    if (value < 0 && base == 10) {
        is_negative = 1;
        value = -value;
    }
    
    /* Convert to the specified base */
    while (value != 0) {
        long remainder = value % base;
        str[i++] = (remainder < 10) ? (remainder + '0') : (remainder - 10 + 'a');
        value = value / base;
    }
    
    /* Add negative sign if needed */
    if (is_negative) {
        str[i++] = '-';
    }
    
    /* Null terminate the string */
    str[i] = '\0';
    
    /* Reverse the string */
    reverse_str(str, str + i - 1);
    
    return str;
}

/* 
 * Convert a long long integer to a string with the specified base
 * Supports bases from 2 to 36
 * Returns the original buffer pointer
 */
char* nlibc_lltoa(long long value, char* str, int base) {
    /* Validate arguments */
    if (str == NULL || base < 2 || base > 36) {
        return NULL;
    }
    
    int i = 0;
    int is_negative = 0;
    
    /* Handle 0 explicitly */
    if (value == 0) {
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }
    
    /* Handle negative numbers for base 10 */
    if (value < 0 && base == 10) {
        is_negative = 1;
        value = -value;
    }
    
    /* Convert to the specified base */
    while (value != 0) {
        long long remainder = value % base;
        str[i++] = (remainder < 10) ? (remainder + '0') : (remainder - 10 + 'a');
        value = value / base;
    }
    
    /* Add negative sign if needed */
    if (is_negative) {
        str[i++] = '-';
    }
    
    /* Null terminate the string */
    str[i] = '\0';
    
    /* Reverse the string */
    reverse_str(str, str + i - 1);
    
    return str;
}
