#!/bin/bash

# Make scripts executable
chmod +x check_lib.sh

# First check if the library exists
./check_lib.sh

# If the library check was successful, proceed with the build
if [ $? -eq 0 ]; then
    echo "Building noesis..."
    make clean
    make all
else
    echo "ERROR: Cannot proceed with build due to library issues."
    echo "Please fix the noesis_libc library issues first."
    exit 1
fi
