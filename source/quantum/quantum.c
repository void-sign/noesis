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
