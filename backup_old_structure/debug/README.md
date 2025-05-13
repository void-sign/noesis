# Test and Debug Code for Noesis

This directory contains test and debug code that was used during the development and debugging of the Noesis project. These files are kept separate from the main project code to maintain a clean codebase.

## Contents

### Test Files
- `main_debug.c`: Debug version of the main program
- `main_test.c`: Test version of the main program
- `helper_test.c`: Test program for the helper function
- `minimal_test.c`: Minimal test program
- `mixed_test.c`: Test program that mixes C and assembly code

### Assembly Test Files
- `io_basic.s`: Basic version of the io.s file
- `io_debug.s`: Debug version of the io.s file
- `io_fixed.s`: Fixed version of the io.s file
- `io_incremental.s`: Incremental improvements to the io.s file
- `io_minimal.s`: Minimal version of the io.s file
- `io_with_c.s`: Version of io.s that calls a C helper function
- `minimal_test.s`: Minimal test assembly file

### Makefiles
- `Makefile.test`: Makefile for running tests
- `Makefile.mixed`: Makefile for running mixed C/assembly tests

## Debugging the `noesis_read` Function

The `noesis_read` function had an issue that caused an infinite loop and error messages. The problem was in the assembly implementation in `io.s`. We fixed it by:

1. Replacing the complex assembly code with a simpler version that calls a C helper function
2. Implementing the C helper function to write "test" to the buffer
3. Updating the function signature to return an `int` value instead of `void`

These changes eliminated the infinite loop and allowed the program to run correctly.

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
