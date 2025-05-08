// compiler.h – logic → quantum compiler interface

#ifndef COMPILER_H
#define COMPILER_H

#include "quantum.h"

// Compile logic file into quantum circuit
// Returns 0 on success, non-zero on error
void compile_logic_file(const char* filepath);

// Parse a single logic line into gate(s)
// Returns number of gates added or -1 on error
void parse_logic_line(const char* line);

#endif
