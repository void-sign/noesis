// backend.h – interface to quantum hardware backends

#ifndef BACKEND_H
#define BACKEND_H

#include "quantum.h"

// Types of supported backends
typedef enum {
    BACKEND_STUB,
    BACKEND_IBM
} backend_type_t;

// Initialize backend
void backend_init(backend_type_t type);

// Send circuit to backend and run
int backend_run(const quantum_circuit_t* circuit);

// Set output file path for exported QASM
void backend_set_output(const char* path);

#endif
