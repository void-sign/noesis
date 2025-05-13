#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Main Script
# This script runs all the restructuring steps
#

echo "Starting Noesis project restructuring..."
echo

# Check for prerequisites
if test ! -d "/Users/plugio/Documents/GitHub/noesis"
    echo "Error: Noesis project directory not found at /Users/plugio/Documents/GitHub/noesis"
    exit 1
end

# Make all step scripts executable
chmod +x scripts/restructure_step*.fish

# Run each step in sequence
echo "Running Step 1: Creating directory structure"
scripts/restructure_step1.fish
echo

echo "Running Step 2: Moving documentation files"
scripts/restructure_step2.fish
echo

echo "Running Step 3: Moving debug files"
scripts/restructure_step3.fish
echo

echo "Running Step 4: Moving test files"
scripts/restructure_step4.fish
echo

echo "Running Step 5: Moving fish scripts"
scripts/restructure_step5.fish
echo

echo "Running Step 6: Moving bash scripts"
scripts/restructure_step6.fish
echo

echo "Running Step 7: Moving API source files"
scripts/restructure_step7.fish
echo

echo "Running Step 8: Moving Core source files"
scripts/restructure_step8.fish
echo

echo "Running Step 9: Moving Quantum source files"
scripts/restructure_step9.fish
echo

echo "Running Step 10: Moving Utils source files"
scripts/restructure_step10.fish
echo

echo "Running Step 11: Moving Tools source files"
scripts/restructure_step11.fish
echo

echo "Running Step 12: Moving noesis_libc and updating Makefile"
scripts/restructure_step12.fish
echo

echo "Restructuring process completed!"
echo "You should now be able to build and run Noesis using the new directory structure."
echo
echo "To verify the new structure, run:"
echo "make clean"
echo "make"
echo "./noesis"
echo
echo "If everything works as expected, you can remove the original directories with:"
echo "rm -rf source object bin"
