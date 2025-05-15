#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# test.fish - Test script for Noesis

# Current version of Noesis
set -g NOESIS_VERSION "2.1.0"

# Define colors for better readability
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set PINK (set_color ff5fd7) # Bright pink
set NC (set_color normal)

echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo "$PINK  NOESIS v$NOESIS_VERSION - TEST SUITE           $NC"
echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo

# Verify all required files exist before testing
echo "$YELLOW"Checking required files..."$NC"
set required_files \
    "soul/intent.fish" \
    "system/memory/unit.fish" \
    "system/perception/unit.fish" \
    "system/emotion/unit.fish" \
    "system/memory/quantum/unit.fish" \
    "system/memory/quantum/compiler.fish" \
    "system/memory/quantum/backend_stub.fish" \
    "system/memory/quantum/backend_ibm.fish" \
    "system/memory/quantum/export_qasm.fish" \
    "system/memory/quantum/field/quantum_field.fish" \
    "system/memory/short.fish" \
    "system/memory/long.fish" \
    "system/perception/api.fish"

set all_files_exist true

for file in $required_files
    if not test -f "$file"
        echo "$RED"Missing file: $file"$NC"
        set all_files_exist false
    end
end

if test "$all_files_exist" = "false"
    echo "$RED"Error: Some required files are missing"$NC"
    exit 1
end

echo "$GREEN"All required files exist"$NC"

# Load the core system
source soul/intent.fish

# Run test suite
echo "$YELLOW"Running test suite..."$NC"

# Test memory system
echo "$BLUE"Testing memory systems..."$NC"
test_memory_system

# Test perception system
echo "$BLUE"Testing perception systems..."$NC"
test_perception_system

# Test quantum operations
echo "$BLUE"Testing quantum operations..."$NC"
test_quantum_operations

echo "$GREEN"All tests completed successfully"$NC"
exit 0
