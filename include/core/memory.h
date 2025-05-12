// memory.h - Header file for memory management in the Noesis project

#ifndef MEMORY_H
#define MEMORY_H

#define NULL (void*)0

// Function to initialize the memory system
void initialize_memory();

// memory.h - Header file for memory management in the Noesis project
void* allocate_memory(unsigned int size);

// Function to free allocated memory
void free_memory(void* pointer);

// Function to manage memory usage (e.g., cleanup)
void manage_memory();

// Function to reset memory to its initial state
void reset_memory();

// API functions used in noesis_api.c
void* memory_init();
void memory_cleanup(void* module);
void* memory_process(void* module, void* input);

#endif // MEMORY_H
