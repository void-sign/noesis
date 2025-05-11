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

// compiler.c – translate simple digital logic into quantum circuit

#include "../../include/quantum/compiler.h"
#include "../../include/quantum/quantum.h"
#include "../../data/gate_defs.h"

#define MAX_LINE 128

extern int str_eq(const char*, const char*);

static void parse_logic_line(const char* line) {
    char gate[8];
    int args[MAX_TARGETS];
    int nargs = 0;

    // manual string parse (no strtok, no libc)
    int i = 0, j = 0, state = 0, val = 0;
    while (line[i] != 0 && i < MAX_LINE) {
        char c = line[i];
        if (state == 0) {
            if (c == ' ' || c == '\t') {
                i++; continue;
            }
            gate[j++] = c;
            state = 1;
        } else if (state == 1) {
            if (c == ' ' || c == '\t') {
                gate[j] = 0;
                state = 2;
                val = 0;
                nargs = 0;
            } else {
                gate[j++] = c;
            }
        } else if (state == 2) {
            if (c >= '0' && c <= '9') {
                val = val * 10 + (c - '0');
            } else if (c == ',' || c == ' ' || c == '\n') {
                args[nargs++] = val;
                val = 0;
            }
        }
        i++;
    }
    if (state == 2 && val > 0) {
        args[nargs++] = val;
    }

    q_add_gate(gate, args, nargs);
}

void compile_logic_file(const char* path) {
    // minimal file parser (simulated, no fopen)
    extern const char* read_line(int); // stub in test
    int lineno = 0;
    const char* line;
    while ((line = read_line(lineno++)) != 0) {
        parse_line(line);
    }
}
