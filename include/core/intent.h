#ifndef INTENT_H
#define INTENT_H

#include "../utils/noesis_lib.h" // Corrected relative path to noesis_lib.h

// Structure representing an intention
typedef struct {
    char *description; // Description of the intention
    int priority;      // Priority level of the intention
    int is_active;     // Whether the intention is currently active (0 or 1)
} Intention;

// Initialize the Intent system
void init_intent_system(void);

// Create a new intention
Intention *create_intention(const char *description, int priority);

// Activate an intention
void activate_intention(Intention *intention);

// Deactivate an intention
void deactivate_intention(Intention *intention);

// Free an intention
void free_intention(Intention *intention);

// Add declaration for handle_io
void handle_io();

// API functions used in noesis_api.c
void* intent_init();
void intent_cleanup(void* module);
void* intent_process(void* module, void* input);
const char* intent_to_string(void* module, void* intent_result);

#endif // INTENT_H