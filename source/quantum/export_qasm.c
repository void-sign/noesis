/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// export_qasm.c – minimal QASM-like output

#include <noesis_libc.h>  // Include all noesis_libc functionality
#include "../../include/quantum/quantum.h"
#include "../../include/quantum/export.h"

#define BUF_SIZE 4096

static int write_str(char *buf, const char *s) {
    int i = 0;
    while (s[i]) {
        buf[i] = s[i];
        i++;
    }
    return i;
}

static int write_int(char *buf, int val) {
    int i = 0;
    if (val >= 100) buf[i++] = '0' + (val / 100);
    if (val >= 10)  buf[i++] = '0' + ((val / 10) % 10);
    buf[i++] = '0' + (val % 10);
    return i;
}

static int gate_to_text(GateType type, char *out) {
    if (type == GATE_H)  return write_str(out, "H");
    if (type == GATE_X)  return write_str(out, "X");
    if (type == GATE_Y)  return write_str(out, "Y");
    if (type == GATE_Z)  return write_str(out, "Z");
    if (type == GATE_S)  return write_str(out, "S");
    if (type == GATE_T)  return write_str(out, "T");
    if (type == GATE_CX) return write_str(out, "CX");
    if (type == GATE_CCX)return write_str(out, "CCX");
    if (type == GATE_MEASURE) return write_str(out, "MEASURE");
    return 0;
}

int export_qasm(char *buffer, int max_len, const Circuit *circuit) {
    int pos = 0;
    
    // Check for valid buffer and size
    if (!buffer || max_len <= 0) return -1;
    
    // Ensure space for header
    if (pos + 20 >= max_len) return -1;  // Conservative estimate for header
    pos += write_str(buffer + pos, "# qubits: ");
    pos += write_int(buffer + pos, circuit->num_qubits);
    if (pos + 1 >= max_len) return -1;
    buffer[pos++] = '\n';

    for (int i = 0; i < circuit->num_gates; ++i) {
        const Gate *g = &circuit->gates[i];
        char instr[8];
        int n = gate_to_text(g->type, instr);
        
        // Ensure space for gate instruction and following space
        if (pos + n + 1 >= max_len) return -1;
        for (int j = 0; j < n; ++j) buffer[pos++] = instr[j];
        buffer[pos++] = ' ';

        for (int j = 0; j < g->ntargets; ++j) {
            // Ensure space for target qubit representation (q[XX],)
            // Worst case: q[100] = 5 chars + potential comma = 6 chars
            if (pos + 6 >= max_len) return -1;
            buffer[pos++] = 'q';
            buffer[pos++] = '[';
            pos += write_int(buffer + pos, g->targets[j]);
            buffer[pos++] = ']';
            if (j != g->ntargets - 1) {
                if (pos + 1 >= max_len) return -1;
                buffer[pos++] = ',';
            }
        }
        
        // Ensure space for newline
        if (pos + 1 >= max_len) return -1;
        buffer[pos++] = '\n';
    }

    // Ensure space for null terminator
    if (pos + 1 > max_len) return -1;
    buffer[pos] = 0;
    return pos;
}
