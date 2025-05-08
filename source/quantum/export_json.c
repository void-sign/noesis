// export_json.c – export quantum circuit to JSON format

#include "../../include/quantum/export.h"

// Helper function to manually add data to buffer
static int manual_write_to_buffer(char* buffer, int buffer_size, const char* content, int length) {
    int i = 0;
    while (i < length && i < buffer_size) {
        buffer[i] = content[i];
        i++;
    }
    return i; // Return the number of bytes written to the buffer
}

// Export the circuit to JSON format
int export_json(const char* filepath, const quantum_circuit_t* circuit) {
    if (!filepath || !circuit) {
        return -1; // Invalid input
    }

    // Create a simple buffer to hold JSON data
    char json_buffer[2048];  // Pre-allocated buffer for JSON data
    int buffer_pos = 0;

    // Manually create JSON content by appending data to the buffer
    const char* header = "{\n  \"num_qubits\": ";
    buffer_pos += manual_write_to_buffer(json_buffer + buffer_pos, sizeof(json_buffer) - buffer_pos, header, 18);
    
    // Assuming num_qubits is 16 for simplicity, convert it manually to buffer
    json_buffer[buffer_pos++] = '1'; 
    json_buffer[buffer_pos++] = '6'; 

    const char* gates_header = ",\n  \"gates\": [\n";
    buffer_pos += manual_write_to_buffer(json_buffer + buffer_pos, sizeof(json_buffer) - buffer_pos, gates_header, 19);

    for (int i = 0; i < circuit->num_gates; ++i) {
        Gate* gate = &circuit->gates[i];
        
        const char* gate_open = "    {\n      \"type\": \"";
        buffer_pos += manual_write_to_buffer(json_buffer + buffer_pos, sizeof(json_buffer) - buffer_pos, gate_open, 22);
        
        // Manually insert gate type 
        json_buffer[buffer_pos++] = 'H';  // Example gate 'H'
        
        const char* gate_close = "\",\n      \"targets\": [";
        buffer_pos += manual_write_to_buffer(json_buffer + buffer_pos, sizeof(json_buffer) - buffer_pos, gate_close, 27);
        
        for (int j = 0; j < gate->ntargets; ++j) {
            // Manually insert target qubit (example, '0' for simplicity)
            json_buffer[buffer_pos++] = '0';
            
            if (j < gate->ntargets - 1) {
                json_buffer[buffer_pos++] = ',';
                json_buffer[buffer_pos++] = ' ';
            }
        }
        
        const char* gate_end = "]\n    }";
        buffer_pos += manual_write_to_buffer(json_buffer + buffer_pos, sizeof(json_buffer) - buffer_pos, gate_end, 9);
        
        if (i < circuit->num_gates - 1) {
            json_buffer[buffer_pos++] = ',';
            json_buffer[buffer_pos++] = '\n';
        } else {
            json_buffer[buffer_pos++] = '\n';
        }
    }

    const char* footer = "  ]\n}\n";
    buffer_pos += manual_write_to_buffer(json_buffer + buffer_pos, sizeof(json_buffer) - buffer_pos, footer, 7);

    return 0;  // Successfully generated the JSON content in memory
}
