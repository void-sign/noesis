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

// main_tests.c - Main test file for the Noesis project

#include "../include/core/emotion.h"
#include "../include/core/logic.h"
#include "../include/core/memory.h"
#include "../include/core/perception.h"
#include "../include/utils/data.h"
#include "../include/utils/helper.h"
#include "utils/timer.h"

// Function to simulate printing (since no external libraries are used)
void print(const char* message) {
    while (*message) {
        __asm__ volatile (
            "movq $0x2000004, %%rax\n"  // syscall: write on macOS
            "movq $1, %%rdi\n"          // file descriptor: stdout
            "movq %0, %%rsi\n"          // pointer to message
            "movq $1, %%rdx\n"          // message length
            "syscall\n"
            :
            : "r"(message)
        );
        message++;
    }
}

// Test function for emotion system
void test_emotion() {
    initialize_emotion();
    process_emotion();
    manage_emotion();
    reset_emotion();
    
    print("Emotion system tests passed!\n");
}

// Test function for logic system
void test_logic() {
    initialize_logic();
    process_logic();
    manage_logic(3, 7);  // Example arguments for input_pain and input_pleasure
    reset_logic();

    print("Logic system tests passed!\n");
}

// Test function for memory system
void test_memory() {
    initialize_memory();
    
    void* ptr = allocate_memory(100);
    if (ptr == NULL) {
        print("Memory allocation failed!\n");
        return;
    }
    free_memory(ptr);

    reset_memory();
    print("Memory system tests passed!\n");
}

// Test function for perception system
void test_perception() {
    initialize_perception();
    process_perception();
    update_perception();
    reset_perception();

    print("Perception system tests passed!\n");
}

// Test function for data system
void test_data() {
    initialize_data();
    load_data("Sample data");
    process_data();
    save_data("destination_path");
    reset_data();

    print("Data system tests passed!\n");
}

// Test function for helper functions
void test_helper() {
    // Test string comparison
    if (compare_strings("test", "test") != 0) {
        print("String comparison failed!\n");
        return;
    }
    if (compare_strings("test", "diff") == 0) {
        print("String comparison failed!\n");
        return;
    }

    // Test string copy
    char dest[10];
    copy_string(dest, "hello");
    if (compare_strings(dest, "hello") != 0) {
        print("String copy failed!\n");
        return;
    }

    // Test string length
    if (string_length("hello") != 5) {
        print("String length test failed!\n");
        return;
    }

    reset_system();
    print("Helper functions tests passed!\n");
}

// Test function for timer system
void test_timer() {
    initialize_timer();
    start_timer();
    unsigned long elapsed = stop_timer();
    if (elapsed == 0) {
        print("Timer test failed!\n");
        return;
    }
    
    reset_timer();
    print("Timer system tests passed!\n");
}

// Main function to run all tests
int main() {
    test_emotion();
    test_logic();
    test_memory();
    test_perception();
    test_data();
    test_helper();
    test_timer();

    return 0;
}