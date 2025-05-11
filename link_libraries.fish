# This script creates a shared library from the core components
# and links it for use by the extensions

# Build the core as a shared library
cd noesis-core

# Clean any previous builds
make clean

# Modify compilation flags for position-independent code
CFLAGS="-Wall -Wextra -std=c99 -fPIC" make

# Create the shared library
gcc -shared -o libnoesis_core.so object/core/*.o object/utils/*.o object/asm/*.o

# Copy the shared library to the extensions directory
cp libnoesis_core.so ../noesis-extensions/

# Return to root directory
cd ..

echo "Core library built and linked to extensions"
