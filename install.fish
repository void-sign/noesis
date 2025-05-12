#!/bin/fish

echo "Noesis Core Installation Script"
echo "=============================="
echo 

# Create required directories
echo "Creating directories..."
mkdir -p bin lib include

# Step 1: Build the core components
echo "Building Noesis Core..."
make clean
make
echo "✓ Noesis Core built successfully"

# Step 2: Create the shared library
echo "Creating shared library..."
gcc -shared -o lib/libnoesis_core.so object/core/*.o object/utils/*.o object/asm/*.o
echo "✓ Shared library created"

# Step 3: Run tests if available
if test -d "tests"
    echo "Running tests..."
    make test
end

# Step 4: Set up environment variables and create links
echo "Setting up environment and creating links..."
mkdir -p bin
ln -sf (pwd)/source/core/noesis_core bin/noesis_core
echo "export NOESIS_PATH=$(pwd)" > .env
echo "export NOESIS_CORE_PATH=$(pwd)" >> .env
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$(pwd)/lib" >> .env
echo "✓ Environment and links set up"

echo
echo "Installation Complete!"
echo "====================="
echo "To run Noesis Core:"
echo "  ./run_core.fish"
echo 
echo "For the extensions functionality, please use the separate Noesis-Extend repository:"
echo "  https://github.com/yourusername/noesis-extend"
echo
echo "Happy consciousness simulating!"
