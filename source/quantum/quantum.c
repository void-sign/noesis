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

// quantum.c – core gate & circuit logic
#include "../include/quantum/quantum.h"
#include "../include/api/noesis_api.h"
#include "../data/gate_defs.h"
#include <stdlib.h>

#define MAX_QUBITS 16
#define MAX_GATES  256

// Define the Noesis API structure
typedef struct {
    int (*init)(void);
    int (*process)(const char*, char*, int);
    void (*cleanup)(void);
} NoesisAPI;

// Dynamic loading function declaration
NoesisAPI* load_noesis_api(const char* lib_path);

static Qubit qubits[MAX_QUBITS];
static Gate  gates[MAX_GATES];
static Circuit circuit;

// API reference - will be NULL in standalone mode
static NoesisAPI *noesis_api = NULL;

void q_init() {
    for (int i = 0; i < MAX_QUBITS; i++) {
        qubits[i].id = i;
        qubits[i].allocated = 0;
    }
    circuit.num_qubits = 0;
    circuit.num_gates = 0;
    
    // Try to load Noesis API if not in standalone mode
    #ifndef STANDALONE_MODE
    if (!noesis_api) {
        const char* lib_paths[] = {
            getenv("NOESIS_LIB"),
            "/usr/local/lib/libnoesis_core.so",
            "/usr/local/lib/libnoesis_core.dylib", // macOS
            "/usr/lib/libnoesis_core.so",
            "../noesis/lib/libnoesis_core.so",
            "../noesis/lib/libnoesis_core.dylib", // macOS
            NULL
        };
        
        for (int i = 0; lib_paths[i] != NULL; i++) {
            if (lib_paths[i]) {
                noesis_api = load_noesis_api(lib_paths[i]);
                if (noesis_api) break;
            }
        }
        
        // Initialize Noesis if API was loaded
        if (noesis_api && noesis_api->init) {
            noesis_api->init();
        }
    }
    #endif
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
    unsigned int i;
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

// --- Noesis Core integration ---

int q_process_with_noesis(const char* input, char* output, int max_len) {
    #ifdef STANDALONE_MODE
    // In standalone mode, provide minimal functionality
    const char* standalone_msg = "Running in standalone mode. Noesis Core not available.";
    int len = 0;
    while (*standalone_msg && len < max_len - 1) {
        output[len++] = *standalone_msg++;
    }
    output[len] = '\0';
    return len;
    #else
    // Use Noesis Core if available
    if (noesis_api && noesis_api->process) {
        return noesis_api->process(input, output, max_len);
    } else {
        const char* error_msg = "Noesis Core API not available.";
        int len = 0;
        while (*error_msg && len < max_len - 1) {
            output[len++] = *error_msg++;
        }
        output[len] = '\0';
        return len;
    }
    #endif
}

// Implementation of the load_noesis_api function
// This function dynamically loads the Noesis Core API from a shared library
NoesisAPI* load_noesis_api(const char* lib_path) {
    // In a real implementation, we would use dlopen/LoadLibrary to load the library
    // and dlsym/GetProcAddress to get function pointers
    
    // Simplified implementation for now - just return NULL
    // to indicate the API is not available
    return NULL;
}
