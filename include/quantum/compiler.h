// compiler.h – logic → quantum compiler interface

#ifndef COMPILER_H
#define COMPILER_H

#include "quantum.h"

// Compile logic file into quantum circuit
// Returns 0 on success, non-zero on error
void compile_logic_file(const char* filepath);

#endif
