#!/bin/fish

echo "Building Noesis Core..."
cd noesis-core
make clean
make
cd ..

echo "Creating shared library from Core..."
./link_libraries.fish

echo "Building Noesis Extensions..."
cd noesis-extensions
make clean
make
cd ..

echo "Build complete."
