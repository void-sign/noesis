// logic.c - Central logic processing

#include "../../include/core/logic.h"

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

// A basic function to output messages (replace stdio functionality)
void custom_output(const char* message) {
    // For simplicity, we assume the output is handled elsewhere (e.g., logging system or hardware output)
    // This function can be customized to direct the output to the relevant platform (e.g., LEDs, screen, or network)
}

// Initialize the logic system, setting initial state and intent
void initialize_logic() {
    logic_state = 0;               // Reset logic state
    current_intent = INTENT_NEUTRAL;  // Set intent to neutral
    custom_output("[LOGIC] Initialized\n");
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
    custom_output("[LOGIC] Reflecting... State Updated\n");
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
            custom_output("[ACTION] Retreat / Protect\n");
            break;
        case INTENT_SEEK_PLEASURE:
            custom_output("[ACTION] Engage / Explore\n");
            break;
        case INTENT_SOLVE_PROBLEM:
            custom_output("[ACTION] Think / Analyze\n");
            break;
        default:
            custom_output("[ACTION] Idle\n");
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
        custom_output("[LOGIC] High pain detected, retreating\n");
        decision_result = -1;  // Decision: retreat or avoid
    }
    else if (input_pleasure > 5) {
        // High pleasure detected, approach or engage more
        custom_output("[LOGIC] High pleasure detected, engaging further\n");
        decision_result = 1;  // Decision: approach or engage
    }
    else {
        // Neutral input, proceed with analysis
        custom_output("[LOGIC] Neutral input, analyzing situation\n");
        decision_result = 0;  // Decision: analyze or wait
    }

    return decision_result;  // Return the result of the decision-making process
}

// Reset the logic system to its initial state
void reset_logic() {
    logic_state = 0;               // Reset logic state
    current_intent = INTENT_NEUTRAL;  // Reset intent to neutral
    custom_output("[LOGIC] Reset\n");
}

// Handle external events (e.g., sensor input, user actions, etc.)
void handle_external_event(LogicEvent* event) {
    if (!event || !event->topic) return;  // Ensure the event is valid

    // Adjust the logic state based on external events
    if (event->topic == "pain_detected") {
        logic_state -= 2;  // If pain is detected, decrease logic state
    } else if (event->topic == "pleasure_detected") {
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
