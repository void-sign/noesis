#!/bin/bash

# This script builds and runs the Noesis test files
# Usage: ./run_tests.sh [test_name]

# Default to running all tests if no argument is provided
if [ -z "$1" ]; then
  echo "Running all tests..."
  
  # Run the main tests
  cd debug
  
  # Make sure the test files are in the current directory
  # Copy any necessary files if they're not present
  for file in io_*.s main_*.c mixed_test.c; do
    if [ ! -f "$file" ]; then
      echo "Copying test file $file to debug directory..."
      cp ../source/utils/asm/$file . 2>/dev/null || cp ../source/core/$file . 2>/dev/null || cp ../source/utils/$file . 2>/dev/null
    fi
  done
  
  echo "Building and running mixed test..."
  make -f Makefile.mixed
  ./mixed_test
  
  echo "Building and running basic test..."
  make -f Makefile.test
  ./test_io
  
  echo "All tests completed."
else
  # Run a specific test
  case "$1" in
    "mixed")
      cd debug
      # Make sure required files exist
      if [ ! -f "mixed_test.c" ] || [ ! -f "io_with_c.s" ]; then
        cp ../source/utils/mixed_test.c . 2>/dev/null || echo "Warning: mixed_test.c not found"
        cp ../source/utils/asm/io_with_c.s . 2>/dev/null || echo "Warning: io_with_c.s not found" 
      fi
      make -f Makefile.mixed
      ./mixed_test
      ;;
    "basic")
      cd debug
      # Make sure required files exist
      if [ ! -f "main_debug.c" ] || [ ! -f "io_debug.s" ]; then
        cp ../source/core/main_debug.c . 2>/dev/null || echo "Warning: main_debug.c not found"
        cp ../source/utils/asm/io_debug.s . 2>/dev/null || echo "Warning: io_debug.s not found"
      fi
      make -f Makefile.test
      ./test_io
      ;;
    *)
      echo "Unknown test: $1"
      echo "Available tests: mixed, basic"
      ;;
  esac
fi
