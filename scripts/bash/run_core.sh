#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#



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
