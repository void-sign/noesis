#!/bin/bash

# This script creates a shared library from the core components
# Note: Extensions have been moved to a separate repository

# Clean any previous builds
make clean

# Modify compilation flags for position-independent code
CFLAGS="-Wall -Wextra -std=c99 -fPIC" make

# Create lib directory if it doesn't exist
mkdir -p lib

# Create the shared library
gcc -shared -o lib/libnoesis_core.so object/core/*.o object/utils/*.o object/asm/*.o

echo "Shared library created as lib/libnoesis_core.so"
echo "Note: For extensions, please use the separate Noesis-Extend repository:"
echo "https://github.com/void-sign/noesis-extend"

echo "Core library built and linked to extensions"
