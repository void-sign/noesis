#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# Noesis Core run script
# This simple script runs the Noesis Core component

echo "Running Noesis Core..."

# Ensure we have a build
if not test -f "./noesis"
    echo "Noesis Core not found. Building first..."
    make
end

# Run the core component
./noesis $argv
