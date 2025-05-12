// export.h – export quantum circuit to QASM or JSON

#ifndef EXPORT_H
#define EXPORT_H

#include "quantum.h"

// Export the current circuit to OpenQASM buffer
// Returns number of bytes written on success, negative value on error
int export_qasm(char* buffer, int max_len, const quantum_circuit_t* circuit);

// Export the current circuit to JSON format (e.g., for Amazon Braket)
// Returns 0 on success, non-zero on error
int export_json(const char* filepath, const quantum_circuit_t* circuit);

#endif
