#!/bin/fish

# Noesis Core run script
# This simple script runs the Noesis Core component

echo "Running Noesis Core..."

# Ensure we have a build
if not test -f "./bin/noesis_core"
    echo "Noesis Core not found. Building first..."
    make
end

# Run the core component
./bin/noesis_core $argv
