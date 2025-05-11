#!/bin/fish

echo "Noesis Installation Script"
echo "=========================="
echo 

# Step 1: Build the core components
echo "[Step 1/4] Building Noesis Core..."
cd noesis-core
make clean
make
echo "✓ Noesis Core built successfully"
cd ..

# Step 2: Create the shared library
echo "[Step 2/4] Creating shared library..."
cd noesis-core
gcc -shared -o libnoesis_core.so object/core/*.o object/utils/*.o object/asm/*.o
cp libnoesis_core.so ../noesis-extensions/
echo "✓ Shared library created"
cd ..

# Step 3: Build the extensions
echo "[Step 3/4] Building Noesis Extensions..."
cd noesis-extensions
make clean
make
echo "✓ Noesis Extensions built successfully"
cd ..

# Step 4: Create symbolic links in a bin directory
echo "[Step 4/4] Creating executable links..."
mkdir -p bin
ln -sf (pwd)/noesis-core/noesis_core bin/noesis_core
ln -sf (pwd)/noesis-extensions/noesis_extensions bin/noesis_extensions
echo "✓ Links created in bin directory"

echo
echo "Installation complete!"
echo "======================"
echo "You can now run the following commands:"
echo "  ./bin/noesis_core       - Run the core functionality"
echo "  ./bin/noesis_extensions - Run the extensions"
echo
echo "Happy consciousness simulating!"
