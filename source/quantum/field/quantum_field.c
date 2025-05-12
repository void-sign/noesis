/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software under the following conditions:
 *
 * 1. The Software may be used, copied, modified, merged, published, distributed,
 *    sublicensed, and sold under the terms specified in this license.
 *
 * 2. Redistribution of the Software or modifications thereof must include the
 *    original copyright notice and this license.
 *
 * 3. Any use of the Software in production or commercial environments must provide
 *    clear attribution to the original author(s) as defined in the copyright notice.
 *
 * 4. The Software may not be used for any unlawful purpose, or in a way that could
 *    harm other humans, animals, or living beings, either directly or indirectly.
 *
 * 5. Any modifications made to the Software must be clearly documented and made
 *    available under the same Noesis License or a compatible license.
 *
 * 6. If the Software is a core component of a profit-generating system, 
 *    the user must donate 10% of the net profit directly resulting from such
 *    use to a recognized non-profit or charitable foundation supporting humans 
 *    or other living beings.
 */

#include "quantum_field.h"

// Approximation of exponential function
double custom_exp(double x) {
    double sum = 1.0;
    double term = 1.0;
    for (int i = 1; i < 20; i++) { // 20 terms for approximation
        term *= x / i;
        sum += term;
    }
    return sum;
}

// Approximation of sine function
double custom_sin(double x) {
    double sum = x;
    double term = x;
    int sign = -1;
    for (int i = 3; i < 20; i += 2) { // 20 terms for approximation
        term *= x * x / (i * (i - 1));
        sum += sign * term;
        sign = -sign;
    }
    return sum;
}

// Initialize the quantum nodes
void initialize_nodes(QuantumNode *nodes, size_t grid_size, double center, double width) {
    for (size_t i = 0; i < grid_size; i++) {
        double x = (double)i / grid_size;
        double diff = x - center;
        nodes[i].field_value = custom_exp(-(diff * diff) / (2.0 * width * width));
        nodes[i].velocity = 0.0;
        nodes[i].conscious_factor = 0.5 + 0.5 * custom_sin(2 * 3.141592653589793 * x); // Example conscious-like activity
    }
}

// Simulate the quantum dynamics with conscious-like factor
void simulate_quantum_field(QuantumNode *nodes, size_t grid_size, double delta_t, double delta_x, double mass) {
    QuantumNode temp[grid_size];
    for (size_t i = 1; i < grid_size - 1; i++) {
        double laplacian = (nodes[i + 1].field_value - 2 * nodes[i].field_value + nodes[i - 1].field_value) / (delta_x * delta_x);
        temp[i].field_value = 2 * nodes[i].field_value - nodes[i].velocity + delta_t * delta_t * (laplacian - mass * mass * nodes[i].field_value);
        temp[i].velocity = nodes[i].field_value;
        temp[i].conscious_factor = nodes[i].conscious_factor; // Keep conscious factor
    }

    // Update the nodes
    for (size_t i = 0; i < grid_size; i++) {
        nodes[i] = temp[i];
    }
}

// Print the state of the quantum field
void print_field(QuantumNode *nodes, size_t grid_size) {
    for (size_t i = 0; i < grid_size; i++) {
        // Note: As no standard library is allowed, no actual printing is done.
        // Replace this with a suitable output mechanism if needed.
    }
}