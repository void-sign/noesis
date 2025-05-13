/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
 * logic.c - Central logic processing
 */

#include "../../include/core/logic.h"
#include "../../include/utils/noesis_lib.h" // For custom system calls

// Internal logic state (tracks the overall state of the system)
static int logic_state = 0;

static Intent current_intent = INTENT_NEUTRAL;  // Current intent of the system

// Initialize the logic system, setting initial state and intent
void initialize_logic() {
    logic_state = 0;               // Reset logic state
    current_intent = INTENT_NEUTRAL;  // Set intent to neutral
}

// Reflect on the current state of logic (similar to mindfulness or self-awareness)
void reflect_logic_state() {
    // Example of handling logic state without stdio (output to custom system instead)
    if (logic_state < -5) {
        current_intent = INTENT_AVOID_PAIN;
    } else if (logic_state > 5) {
        current_intent = INTENT_SEEK_PLEASURE;
    } else {
        current_intent = INTENT_SOLVE_PROBLEM;
    }

    // Example of how to reflect (outputting to a custom system)
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
    // Instead of printing, the action would be forwarded to the action system
    switch (current_intent) {
        case INTENT_AVOID_PAIN:
            break;
        case INTENT_SEEK_PLEASURE:
            break;
        case INTENT_SOLVE_PROBLEM:
            break;
        default:
            break;
    }
}

// Main logic processing function
void process_logic() {
    reflect_logic_state();  // Reflect on the current state of the logic
    decide_action();        // Decide what action to take based on the intent
}

// manage_logic() - Manage deeper logic, decision-making, or emotional processing
// This function now accepts input and returns a result

int manage_logic(int input_pain, int input_pleasure) {
    int decision_result = 0;  // Default result (no action)

    // Example of deeper decision-making based on pain and pleasure inputs
    if (input_pain > 5) {
        // High pain detected, avoid further harm
        decision_result = -1;  // Decision: retreat or avoid
    }
    else if (input_pleasure > 5) {
        // High pleasure detected, approach or engage more
        decision_result = 1;  // Decision: approach or engage
    }
    else {
        // Neutral input, proceed with analysis
        decision_result = 0;  // Decision: analyze or wait
    }

    return decision_result;  // Return the result of the decision-making process
}

// Reset the logic system to its initial state
void reset_logic() {
    logic_state = 0;               // Reset logic state
    current_intent = INTENT_NEUTRAL;  // Reset intent to neutral
}

// Handle external events (e.g., sensor input, user actions, etc.)
void handle_external_event(LogicEvent* event) {
    if (!event || !event->topic) return;  // Ensure the event is valid

    // Adjust the logic state based on external events
    if (event->topic) {
        // Compare strings manually without using standard library
        const char* pain_detected = "pain_detected";
        const char* pleasure_detected = "pleasure_detected";
        int i = 0;

        // Check if event->topic matches "pain_detected"
        while (pain_detected[i] != '\0' && event->topic[i] != '\0' && pain_detected[i] == event->topic[i]) {
            i++;
        }
        if (pain_detected[i] == '\0' && event->topic[i] == '\0') {
            logic_state -= 2;  // If pain is detected, decrease logic state
        } else {
            i = 0;
            // Check if event->topic matches "pleasure_detected"
            while (pleasure_detected[i] != '\0' && event->topic[i] != '\0' && pleasure_detected[i] == event->topic[i]) {
                i++;
            }
            if (pleasure_detected[i] == '\0' && event->topic[i] == '\0') {
                logic_state += 2;  // If pleasure is detected, increase logic state
            }
        }
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

// Updated custom_output function to use noesis_print
void custom_output(const char* message) {
    noesis_print(message); // Use Noesis-specific print function
}

// API functions used in noesis_api.c
void* logic_init() {
    initialize_logic();
    return (void*)1; // Non-NULL pointer to indicate success
}

void logic_cleanup(void* module) {
    // Clean up resources if needed
    (void)module; // Avoid unused parameter warning
}

void* logic_process(void* module, void* input) {
    // Process input and apply logical reasoning
    (void)module; // Avoid unused parameter warning

    // Simple processing - if input is non-NULL, learn from it
    if (input) {
        const char* input_str = (const char*)input;
        int input_length = 0;
        while (input_str[input_length]) input_length++;

        // Basic learning: positive if input is longer than 10 chars
        learn_from_result(input_length > 10 ? 1 : -1);
    }

    // Create a result indicating the current state
    static char result_buffer[64];
    noesis_sbuffer(result_buffer, sizeof(result_buffer), 
                 "Logic state: %d, Intent: %d", 
                 logic_state, current_intent);

    return result_buffer;
}
