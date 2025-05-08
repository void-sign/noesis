// quantum.h – define qubit, gate, and circuit struct

#ifndef QUANTUM_H
#define QUANTUM_H

#define MAX_TARGETS  3
#define MAX_GATES    256
#define MAX_QUBITS   16

typedef struct {
    int id;
    int allocated;
} Qubit;

typedef enum {
    GATE_H,
    GATE_X,
    GATE_Y,
    GATE_Z,
    GATE_S,
    GATE_T,
    GATE_CX,
    GATE_CCX,
    GATE_MEASURE,
    GATE_UNKNOWN
} GateType;

typedef struct {
    GateType type;
    int targets[MAX_TARGETS];
    int ntargets;
} Gate;

typedef struct {
    int num_qubits;
    int num_gates;
    Gate gates[MAX_GATES];
} Circuit;

// interface
void     q_init();                                // clear qubits and circuit
Qubit*   q_alloc();                               // allocate qubit
int      q_add_gate(const char* name, int*, int); // add gate to circuit
Circuit* q_get_circuit();                         // return circuit object

// internal utils
int str_eq(const char*, const char*);             // compare string (no libc)

// typedef for middleware use
typedef Circuit quantum_circuit_t;

#endif
