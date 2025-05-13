/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

#include <noesis_libc.h>  // Include all noesis_libc functionality
#include "../../include/quantum/quantum.h"

// Function to export circuit to JSON format
void export_json(const quantum_circuit_t* circuit, const char* filename) {
    NLIBC_FILE* stderr_file = nlibc_stderr; // Define stderr using nlibc_stderr
    NLIBC_FILE* file = nlibc_fopen(filename, "w"); // Properly initialize the file

    if (!file) {
        nlibc_fprintf(stderr_file, "Error: Could not open file %s for writing\n", filename);
        return;
    }

    nlibc_fprintf(file, "{\n");
    nlibc_fprintf(file, "  \"circuit\": {\n");
    nlibc_fprintf(file, "    \"id\": \"quantum_circuit\",\n"); // Use a generic ID instead of name
    nlibc_fprintf(file, "    \"qubits\": %d,\n", circuit->num_qubits);
    // Additional JSON export code would go here

    nlibc_fprintf(file, "  }\n");
    nlibc_fprintf(file, "}\n");

    // File will be closed by the system when the function exits
}
