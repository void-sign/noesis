# Test and Debug Code for Noesis

This directory contains test and debug code that was used during the development and debugging of the Noesis project. These files are kept separate from the main project code to maintain a clean codebase.

## Contents

### Test Files
- `main_debug.c`: Debug version of the main program
- `main_test.c`: Test version of the main program
- `helper_test.c`: Test program for the helper function
- `minimal_test.c`: Minimal test program
- `mixed_test.c`: Test program that mixes C and assembly code (deprecated)

### Assembly Test Files (Deprecated)
Note: Assembly files have been removed from the repository. The functionality is now implemented in C.
The files below are kept in the documentation for historical reference only:

- `io_basic.s`: Basic version of the io.s file (replaced by C implementation)
- `io_debug.s`: Debug version of the io.s file (replaced by C implementation)
- `io_fixed.s`: Fixed version of the io.s file (replaced by C implementation)
- `io_incremental.s`: Incremental improvements to the io.s file (replaced by C implementation)
- `io_minimal.s`: Minimal version of the io.s file (replaced by C implementation)
- `io_with_c.s`: Version of io.s that calls a C helper function (replaced by C implementation)
- `minimal_test.s`: Minimal test assembly file (replaced by C implementation)

### Makefiles
- `Makefile.test`: Makefile for running tests
- `Makefile.mixed`: Makefile for running mixed C/assembly tests (needs update for C-only)

## Debugging the `noesis_read` Function
All the functionality previously implemented in assembly is now available through C implementations in the `string_functions.c` file. This provides better maintainability and compatibility across different platforms.

## Running Tests

To run the tests:
```
cd noesis
make -f test_and_debug/Makefile.test
./test_io
```

or for the mixed C/assembly test:
```
cd noesis
make -f test_and_debug/Makefile.mixed
./mixed_test
```
