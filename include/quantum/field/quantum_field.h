/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */


// quantum_field.h - Header for quantum field calculations
// Part of the Noesis Quantum Module

#ifndef QUANTUM_FIELD_H
#define QUANTUM_FIELD_H

#include "../quantum.h"

// Field operation types
typedef enum {
    FIELD_OP_NONE,
    FIELD_OP_SCALAR,
    FIELD_OP_VECTOR,
    FIELD_OP_TENSOR
} FieldOpType;

// Quantum field structure
typedef struct {
    int dimensions;
    int size[3];
    float* data;
} QuantumField;

// Initialize a quantum field
QuantumField* qf_create(int dimensions, int* size);

// Free a quantum field
void qf_destroy(QuantumField* field);

// Apply a quantum operation to a field
int qf_apply_operation(QuantumField* field, FieldOpType op_type, const void* op_data);

// Convert a circuit to a field representation
QuantumField* qf_from_circuit(const Circuit* circuit);

#endif // QUANTUM_FIELD_H