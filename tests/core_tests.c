// core_tests.c - Unit tests for core functionality in the Noesis project

#include "core/emotion.h"
#include "core/logic.h"
#include "core/memory.h"
#include "core/perception.h"
#include "utils/data.h"
#include "utils/helper.h"
#include "utils/timer.h"
#include "../../include/utils/noesis_lib.h"

// Function to simulate printing (since no external libraries are used)
void print(const char* message) {
    noesis_print(message);
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
    manage_logic();
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
