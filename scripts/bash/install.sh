#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#



echo "Noesis Core Installation Script"
echo "=============================="
echo 

# Create required directories
echo "Creating directories..."
mkdir -p bin lib include

# Step 1: Build the core components
echo "Building Noesis Core..."
make clean
CFLAGS="-Wall -Wextra -std=c99 -fPIC" make
echo "✓ Noesis Core built successfully"

# Step 2: Create the libraries
echo "Creating libraries..."
# Static library
ar rcs lib/libnoesis.a object/core/*.o object/utils/*.o object/asm/*.o object/api/*.o
echo "✓ Static library created"

# Shared library
gcc -shared -o lib/libnoesis.so object/core/*.o object/utils/*.o object/asm/*.o object/api/*.o
echo "✓ Shared library created"

# Step 3: Install API headers
echo "Installing API headers..."
mkdir -p lib/include/noesis
cp include/api/noesis_api.h lib/include/noesis/
echo "✓ API headers installed"

# Step 3: Run tests if available
if [ -d "tests" ]; then
    echo "Running tests..."
    make test
fi

# Step 4: Set up environment variables and create links
echo "Setting up environment and creating links..."
mkdir -p bin
ln -sf $(pwd)/source/core/noesis_core bin/noesis_core
echo "export NOESIS_PATH=$(pwd)" > .env
echo "export NOESIS_CORE_PATH=$(pwd)" >> .env
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$(pwd)/lib" >> .env
echo "✓ Environment and links set up"

echo
echo "Installation Complete!"
echo "====================="
echo "To run Noesis Core:"
echo "  ./run_core.sh"
echo
echo "Happy consciousness simulating!"
