// logic.c - Implementation of central logic processing

#include "../../include/core/logic.h"
#include <stdio.h>
#include <string.h>

// Internal logic state (tracks the overall state of the system)
static int logic_state = 0;

// Enum for defining different types of intent (goals or motivations)
typedef enum {
    INTENT_NEUTRAL,      // No specific goal, idle state
    INTENT_SEEK_PLEASURE, // Seeking pleasure or positive experience
    INTENT_AVOID_PAIN,    // Avoiding discomfort or negative experiences
    INTENT_SOLVE_PROBLEM  // Problem-solving or logical thinking
} Intent;

static Intent current_intent = INTENT_NEUTRAL;  // Current intent of the system

// Initialize the logic system, setting initial state and intent
void initialize_logic() {
    logic_state = 0;               // Reset logic state
    current_intent = INTENT_NEUTRAL;  // Set intent to neutral
    printf("[LOGIC] Initialized\n");
}

// Reflect on the current state of logic (similar to mindfulness or self-awareness)
void reflect_logic_state() {
    printf("[LOGIC] Reflecting... State: %d | Intent: %d\n", logic_state, current_intent);

    // Adjust intent based on logic state (this can be expanded for more complex reflection)
    if (logic_state < -5) {
        current_intent = INTENT_AVOID_PAIN;
    } else if (logic_state > 5) {
        current_intent = INTENT_SEEK_PLEASURE;
    } else {
        current_intent = INTENT_SOLVE_PROBLEM;
    }
}

// Learn from the outcome of previous actions (success or failure)
void learn_from_result(int outcome) {
    if (outcome > 0) {
        logic_state++;  // Positive outcome, increase the state
    } else {
        logic_state--;  // Negative outcome, decrease the state
    }
    reflect_logic_state();  // Re-evaluate logic state after learning
}

// Decide on actions based on the current intent (determines behavior)
void decide_action() {
    switch (current_intent) {
        case INTENT_AVOID_PAIN:
            printf("[ACTION] Retreat / Protect\n");
            break;
        case INTENT_SEEK_PLEASURE:
            printf("[ACTION] Engage / Explore\n");
            break;
        case INTENT_SOLVE_PROBLEM:
            printf("[ACTION] Think / Analyze\n");
            break;
        default:
            printf("[ACTION] Idle\n");
            break;
    }
}

// Main logic processing function
void process_logic() {
    reflect_logic_state();  // Reflect on the current state of the logic
    decide_action();        // Decide what action to take based on the intent
}

// Manage deeper logic and advanced reasoning (future scope for AI or deeper reasoning)
void manage_logic() {
    printf("[LOGIC] Managing deeper logic\n");
    // Placeholder for more complex decision-making or emotional processing in the future
}

// Reset the logic system to its initial state
void reset_logic() {
    logic_state = 0;               // Reset logic state
    current_intent = INTENT_NEUTRAL;  // Reset intent to neutral
    printf("[LOGIC] Reset\n");
}

// Handle external events (e.g., sensor input, user actions, etc.)
void handle_external_event(LogicEvent* event) {
    if (!event || !event->topic) return;  // Ensure the event is valid

    // Adjust the logic state based on external events
    if (strcmp(event->topic, "pain_detected") == 0) {
        logic_state -= 2;  // If pain is detected, decrease logic state
    } else if (strcmp(event->topic, "pleasure_detected") == 0) {
        logic_state += 2;  // If pleasure is detected, increase logic state
    }

    reflect_logic_state();  // Re-evaluate logic state after event handling
}

// Generate an output event to send to other systems (e.g., control actions like movement, UI updates)
LogicEvent generate_output_event() {
    LogicEvent event;

    // Create an event based on the current intent
    switch (current_intent) {
        case INTENT_AVOID_PAIN:
            event.topic = "act_escape";  // Event for escaping or avoiding pain
            break;
        case INTENT_SEEK_PLEASURE:
            event.topic = "act_approach";  // Event for approaching or seeking pleasure
            break;
        case INTENT_SOLVE_PROBLEM:
            event.topic = "act_analyze";  // Event for analyzing or solving a problem
            break;
        default:
            event.topic = "act_idle";  // Event for idle state or doing nothing
            break;
    }

    event.payload = NULL;  // Currently, no additional data attached to the event
    return event;
}
