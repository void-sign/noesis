/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

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
