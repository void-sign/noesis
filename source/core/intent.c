#include "intent.h"
#include "noesis_lib.h"

// Initialize the Intent system
void init_intent_system(void) {
    noesis_log("Intent system initialized.");
}

// Create a new intention
Intention *create_intention(const char *description, int priority) {
    Intention *new_intention = (Intention *)noesis_malloc(sizeof(Intention));
    if (!new_intention) {
        return NOESIS_NULL;
    }
    new_intention->description = noesis_strdup(description);
    new_intention->priority = priority;
    new_intention->is_active = 0;
    return new_intention;
}

// Activate an intention
void activate_intention(Intention *intention) {
    if (intention) {
        intention->is_active = 1;
        noesis_log("Activated intention: %s", intention->description);
    }
}

// Deactivate an intention
void deactivate_intention(Intention *intention) {
    if (intention) {
        intention->is_active = 0;
        noesis_log("Deactivated intention: %s", intention->description);
    }
}

// Free an intention
void free_intention(Intention *intention) {
    if (intention) {
        noesis_free(intention->description);
        noesis_free(intention);
    }
}