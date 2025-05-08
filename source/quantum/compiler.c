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
