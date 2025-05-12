#!/bin/bash

# Noesis Core run script
# This simple script runs the Noesis Core component

echo "Running Noesis Core..."

# Ensure we have a build
if [ ! -f "./bin/noesis_core" ]; then
    echo "Noesis Core not found. Building first..."
    make
fi

# Run the core component
./bin/noesis_core "$@"
