#ifndef PERCEPTION_H
#define PERCEPTION_H

// We'll use the standard va_list from stdarg.h instead of defining our own
// This avoids conflicts with system headers

// Function to initialize the perception system
void initialize_perception();

// Function to process sensory input and convert it into usable data
void process_perception();

// Function to handle sensory data and update the internal state
void update_perception();

// Function to reset the perception system to its initial state
void reset_perception();

#endif // PERCEPTION_H