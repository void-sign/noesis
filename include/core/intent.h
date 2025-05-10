#ifndef INTENT_H
#define INTENT_H

#include "noesis_lib.h"

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

#endif // INTENT_H