/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
/* 
/*
/* 
// noesis_lib_tests.c - Unit tests for Noesis-specific utility functions

#include "../include/utils/noesis_lib.h"
#include "../include/utils/timer.h"

// Test function for noesis_print
void test_noesis_print() {
    noesis_print("Testing noesis_print function.\n");
}

// Test function for noesis_get_time
void test_noesis_get_time() {
    unsigned long time1 = noesis_get_time();
    unsigned long time2 = noesis_get_time();

    if (time2 > time1) {
        noesis_print("noesis_get_time test passed.\n");
    } else {
        noesis_print("noesis_get_time test failed.\n");
    }
}

// Main function to run all tests
int main() {
    test_noesis_print();
    test_noesis_get_time();

    return 0;
}
