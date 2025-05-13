/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

#include "../../../include/quantum/field/quantum_field.h"

// Include stdlib.h which provides malloc and free declarations needed for new and del macros
#include <stdlib/stdlib.h>
#include <noesis_libc.h>  // Include all noesis_libc functionality with short names

// Helper function - allocate memory for a field
static float* allocate_field_memory(int dimensions, int* size) {
    int total_size = 1;
    for (int i = 0; i < dimensions && i < 3; i++) {
        total_size *= size[i];
    }
    return (float*)new(sizeof(float) * total_size);
}

// Initialize a quantum field
QuantumField* qf_create(int dimensions, int* size) {
    QuantumField* field = (QuantumField*)new(sizeof(QuantumField));
    if (!field) return NULL;

    field->dimensions = dimensions > 3 ? 3 : dimensions;
    for (int i = 0; i < field->dimensions; i++) {
        field->size[i] = size[i];
    }

    field->data = allocate_field_memory(field->dimensions, field->size);
    if (!field->data) {
        del(field);
        return NULL;
    }

    // Initialize with zeros
    int total_size = 1;
    for (int i = 0; i < field->dimensions; i++) {
        total_size *= field->size[i];
    }

    for (int i = 0; i < total_size; i++) {
        field->data[i] = 0.0f;
    }

    return field;
}

// Free a quantum field
void qf_destroy(QuantumField* field) {
    if (field) {
        if (field->data) {
            del(field->data);
        }
        del(field);
    }
}

// Apply a quantum operation to a field
int qf_apply_operation(QuantumField* field, FieldOpType op_type, const void* op_data) {
    if (!field || !field->data) return -1;

    // Just a simple implementation for now
    int total_size = 1;
    for (int i = 0; i < field->dimensions; i++) {
        total_size *= field->size[i];
    }

    // Different operations based on type
    switch (op_type) {
        case FIELD_OP_SCALAR: {
            float scalar = *(const float*)op_data;
            for (int i = 0; i < total_size; i++) {
                field->data[i] *= scalar;
            }
            break;
        }
        case FIELD_OP_VECTOR:
        case FIELD_OP_TENSOR:
        case FIELD_OP_NONE:
        default:
            // Other operations not implemented yet
            return -1;
    }

    return 0;
}

// Convert a circuit to a field representation
QuantumField* qf_from_circuit(const Circuit* circuit) {
    if (!circuit) return NULL;

    // Create a 2D field: qubits x time (gates)
    int size[2] = { circuit->num_qubits, circuit->num_gates };
    QuantumField* field = qf_create(2, size);

    if (!field) return NULL;

    // Generate field representation (simplified)
    for (int g = 0; g < circuit->num_gates; g++) {
        for (int t = 0; t < circuit->gates[g].ntargets; t++) {
            int qubit = circuit->gates[g].targets[t];
            if (qubit >= 0 && qubit < circuit->num_qubits) {
                field->data[qubit * circuit->num_gates + g] = 1.0f;
            }
        }
    }

    return field;
}
