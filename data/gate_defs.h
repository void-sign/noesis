/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
// gate_defs.h – definitions of supported quantum gates

#ifndef GATE_DEFS_H
#define GATE_DEFS_H

#include "../include/quantum/quantum.h"

#define MAX_QUBITS 16
#define MAX_GATES_PER_CIRCUIT 1024
#define MAX_TARGETS 3

// Gate table entry structure
typedef struct {
    const char* name;
    GateType type;
} GateTableEntry;

// Gate table definition
static const GateTableEntry GATE_TABLE[] = {
    {"H",       GATE_H},
    {"X",       GATE_X},
    {"Y",       GATE_Y},
    {"Z",       GATE_Z},
    {"S",       GATE_S},
    {"T",       GATE_T},
    {"CX",      GATE_CX},
    {"CCX",     GATE_CCX},
    {"MEASURE", GATE_MEASURE},
};

#define GATE_TABLE_LEN (sizeof(GATE_TABLE) / sizeof(GATE_TABLE[0]))

// Supported gate names (for backward compatibility)
static const char* SUPPORTED_GATES[] = {
    "H",   // Hadamard
    "X",   // Pauli-X
    "Y",   // Pauli-Y
    "Z",   // Pauli-Z
    "CX",  // Controlled-X
    "CY",  // Controlled-Y
    "CZ",  // Controlled-Z
    "CCX", // Toffoli
    "RX",  // Rotation-X
    "RY",  // Rotation-Y
    "RZ",  // Rotation-Z
    "MEASURE",
    0      // null terminator
};

#endif
