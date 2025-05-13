/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

#include <noesis_libc.h>  // Include all noesis_libc functionality
#include "../../include/quantum/quantum.h"

// Function to export circuit to JSON format
void export_json(const quantum_circuit_t* circuit, const char* filename) {
    FILE* file = open(filename, "w");
    if (!file) {
        fout(stderr, "Error: Could not open file %s for writing\n", filename);
        return;
    }

    fout(file, "{\n");
    fout(file, "  \"circuit\": {\n");
    fout(file, "    \"name\": \"%s\",\n", circuit->name);
    fout(file, "    \"qubits\": %d,\n", circuit->num_qubits);
    // Additional JSON export code would go here

    fout(file, "  }\n");
    fout(file, "}\n");

    close(file);
}
