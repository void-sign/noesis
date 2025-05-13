/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

#include <noesis_libc.h>  // Include all noesis_libc functionality
#include "../../include/quantum/quantum.h"

// Static buffer for storing the generated JSON
static char json_buffer[4096];
static int buffer_pos = 0;

// Helper function to append a string to the buffer
static void append_to_buffer(const char* str) {
    while (*str && buffer_pos < sizeof(json_buffer) - 1) {
        json_buffer[buffer_pos++] = *str++;
    }
    json_buffer[buffer_pos] = '\0'; // Ensure null termination
}

// Function to export circuit to JSON format - returns the JSON string
const char* export_json(const quantum_circuit_t* circuit, const char* filename) {
    // Reset buffer
    buffer_pos = 0;
    json_buffer[0] = '\0';
    
    // We ignore the filename parameter now, since we're not writing to a file
    (void)filename;
    
    if (!circuit) {
        append_to_buffer("{ \"error\": \"Invalid circuit\" }");
        return json_buffer;
    }

    // Start building the JSON
    append_to_buffer("{\n");
    append_to_buffer("  \"circuit\": {\n");
    
    // Add circuit ID
    append_to_buffer("    \"id\": \"quantum_circuit\",\n");
    
    // Add number of qubits
    char temp[32];
    noesis_sbuffer(temp, sizeof(temp), "    \"qubits\": %d,\n", circuit->num_qubits);
    append_to_buffer(temp);
    
    // Add number of gates
    noesis_sbuffer(temp, sizeof(temp), "    \"gates\": %d,\n", circuit->num_gates);
    append_to_buffer(temp);
    
    // Add gate list
    append_to_buffer("    \"gate_list\": [\n");
    
    // Add gates (simplified implementation)
    for (int i = 0; i < circuit->num_gates && i < MAX_GATES; i++) {
        append_to_buffer("      {\n");
        
        // Add gate type
        noesis_sbuffer(temp, sizeof(temp), "        \"type\": %d,\n", circuit->gates[i].type);
        append_to_buffer(temp);
        
        // Add targets
        append_to_buffer("        \"targets\": [");
        for (int j = 0; j < circuit->gates[i].ntargets; j++) {
            noesis_sbuffer(temp, sizeof(temp), "%d", circuit->gates[i].targets[j]);
            append_to_buffer(temp);
            
            if (j < circuit->gates[i].ntargets - 1) {
                append_to_buffer(", ");
            }
        }
        append_to_buffer("]\n");
        
        // Close gate object
        append_to_buffer("      }");
        
        // Add comma if not the last gate
        if (i < circuit->num_gates - 1) {
            append_to_buffer(",");
        }
        append_to_buffer("\n");
    }
    
    // Close gate list
    append_to_buffer("    ]\n");
    
    // Close circuit and root objects
    append_to_buffer("  }\n");
    append_to_buffer("}\n");
    
    return json_buffer;
}
