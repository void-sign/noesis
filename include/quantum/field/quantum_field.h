// Header file for quantum field simulation

#ifndef QUANTUM_FIELD_H
#define QUANTUM_FIELD_H

// Define a custom size_t type
typedef unsigned long long int size_t;

// Define the quantum field node structure
typedef struct {
    double field_value; // Value of the quantum field at this node
    double velocity;    // Rate of change of the field value
    double conscious_factor; // A factor representing "conscious-like" activity
} QuantumNode;

// Function declarations
double custom_exp(double x);
double custom_sin(double x);
void initialize_nodes(QuantumNode *nodes, size_t grid_size, double center, double width);
void simulate_quantum_field(QuantumNode *nodes, size_t grid_size, double delta_t, double delta_x, double mass);
void print_field(QuantumNode *nodes, size_t grid_size);

#endif // QUANTUM_FIELD_H