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

// quantum.c – core gate & circuit logic (no libc)
#include "../../include/quantum/quantum.h"
#include "../data/gate_defs.h"

#define MAX_QUBITS 16
#define MAX_GATES  256

static Qubit qubits[MAX_QUBITS];
static Gate  gates[MAX_GATES];
static Circuit circuit;

void q_init() {
    for (int i = 0; i < MAX_QUBITS; i++) {
        qubits[i].id = i;
        qubits[i].allocated = 0;
    }
    circuit.num_qubits = 0;
    circuit.num_gates = 0;
}

Qubit* q_alloc() {
    for (int i = 0; i < MAX_QUBITS; i++) {
        if (!qubits[i].allocated) {
            qubits[i].allocated = 1;
            if (i + 1 > circuit.num_qubits)
                circuit.num_qubits = i + 1;
            return &qubits[i];
        }
    }
    return 0; // out of qubits
}

int q_add_gate(const char* name, int targets[], int ntargets) {
    if (circuit.num_gates >= MAX_GATES)
        return -1;

    Gate* g = &gates[circuit.num_gates];
    int i;
    for (i = 0; i < GATE_TABLE_LEN; i++) {
        if (str_eq(GATE_TABLE[i].name, name)) {
            g->type = GATE_TABLE[i].type;
            break;
        }
    }
    if (i == GATE_TABLE_LEN)
        return -2; // unknown gate

    g->ntargets = ntargets;
    for (int j = 0; j < ntargets; j++)
        g->targets[j] = targets[j];

    circuit.gates[circuit.num_gates++] = *g;
    return 0;
}

Circuit* q_get_circuit() {
    for (int i = 0; i < circuit.num_gates; i++)
        circuit.gates[i] = gates[i];
    return &circuit;
}

// --- utils ---

int str_eq(const char* a, const char* b) {
    while (*a && *b) {
        if (*a != *b) return 0;
        a++; b++;
    }
    return *a == *b;
}
