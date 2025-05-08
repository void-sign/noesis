// gate_defs.h – definitions of supported quantum gates

#ifndef GATE_DEFS_H
#define GATE_DEFS_H

#define MAX_QUBITS 16
#define MAX_GATES_PER_CIRCUIT 1024
#define MAX_TARGETS 3

// Supported gate names
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
