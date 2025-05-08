// logic.h - Header file for central logic processing

#ifndef LOGIC_H
#define LOGIC_H

#define NULL (void*)0

// Structure for event handling (for external platform communication)
typedef struct {
    const char* topic;  // Topic of the event
    void* payload;      // Data associated with the event
} LogicEvent;

// Enum for defining different types of intent (goals or motivations)
typedef enum {
    INTENT_NEUTRAL,      // No specific goal, idle state
    INTENT_SEEK_PLEASURE, // Seeking pleasure or positive experience
    INTENT_AVOID_PAIN,    // Avoiding discomfort or negative experiences
    INTENT_SOLVE_PROBLEM  // Problem-solving or logical thinking
} Intent;

// A basic function to output messages (replace stdio functionality)
void custom_output(const char* message);

// Initialize the logic system (starting state of the logic)
void initialize_logic();

// Process the central logic on each cycle (core decision-making process)
void process_logic();

// Manage deeper logic, for future expansion (like advanced reasoning)
int manage_logic(int input_pain, int input_pleasure);

// Reflect on the current state of the logic system (like mindfulness)
void reflect_logic_state();

// Learn from the outcome (positive or negative results from previous actions)
void learn_from_result(int outcome);

// Decide actions based on the current intent and state
void decide_action();

// Reset the logic system back to its initial state
void reset_logic();

// Handle external events (e.g., sensor data, user input, etc.)
void handle_external_event(LogicEvent* event);

// Generate an output event to communicate with other systems (e.g., movement, UI)
LogicEvent generate_output_event(void); // Explicitly specify the return type

#endif // LOGIC_H
