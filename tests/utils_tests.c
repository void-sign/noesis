// utils_tests.c - Unit tests for utility functions in the Noesis project

#include "utils/data.h"
#include "utils/helper.h"
#include "utils/timer.h"

// Function to simulate printing (since no external libraries are used)
void print(const char* message) {
    while (*message) {
        // Simple loop to print each character (you can replace with actual printing logic)
        message++;
    }
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

// Main function to run all utility tests
int main() {
    test_data();
    test_helper();
    test_timer();

    return 0;
}
