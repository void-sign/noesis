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

// export_qasm.c – minimal QASM-like output

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

    pos += write_str(buffer + pos, "# qubits: ");
    pos += write_int(buffer + pos, circuit->num_qubits);
    buffer[pos++] = '\n';

    for (int i = 0; i < circuit->num_gates; ++i) {
        Gate *g = &circuit->gates[i];
        char instr[8];
        int n = gate_to_text(g->type, instr);
        for (int j = 0; j < n; ++j) buffer[pos++] = instr[j];
        buffer[pos++] = ' ';

        for (int j = 0; j < g->ntargets; ++j) {
            buffer[pos++] = 'q';
            buffer[pos++] = '[';
            pos += write_int(buffer + pos, g->targets[j]);
            buffer[pos++] = ']';
            if (j != g->ntargets - 1)
                buffer[pos++] = ',';
        }
        buffer[pos++] = '\n';
    }

    buffer[pos] = 0;
    return pos;
}
