#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 1
# This script creates the new directory structure
#

echo "Step 1: Creating new directory structure..."

# Create new directory structure
mkdir -p build/bin
mkdir -p build/lib
mkdir -p build/obj
mkdir -p scripts/bash
mkdir -p scripts/fish
mkdir -p src/api
mkdir -p src/core
mkdir -p src/quantum/field
mkdir -p src/tools
mkdir -p src/utils/asm
mkdir -p tests/debug
mkdir -p tests/unit
mkdir -p libs

echo "Directory structure created successfully!"
echo "Now run restructure_step2.fish"
