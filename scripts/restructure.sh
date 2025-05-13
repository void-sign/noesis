#!/bin/bash
#
# Noesis Project Structure Reorganization Script
# This script reorganizes the Noesis project structure to follow standard conventions
#

WORKSPACE_ROOT=$(pwd)
echo "Restructuring Noesis project at: $WORKSPACE_ROOT"

# Create new directory structure
echo "Creating new directory structure..."
mkdir -p build
mkdir -p docs/changelogs
mkdir -p scripts/bash
mkdir -p scripts/fish
mkdir -p src/api
mkdir -p src/core
mkdir -p src/quantum/field
mkdir -p src/utils/asm
mkdir -p src/tools
mkdir -p tests/debug
mkdir -p tests/unit
mkdir -p libs

# Move documentation files
echo "Moving documentation files..."
mv CHECKLIST.md docs/
mv CONTRIBUTING.md docs/
mv SECURITY.md docs/
mv changelogs/* docs/changelogs/
rmdir changelogs

# Move debug files
echo "Moving debug files..."
mv debug/* tests/debug/
rmdir debug

# Move test files
echo "Moving test files..."
mv tests/* tests/unit/

# Move shell scripts
echo "Moving shell scripts..."
mv fish_scripts/* scripts/fish/
rmdir fish_scripts
mv bash_scripts/* scripts/bash/
rmdir bash_scripts
mv shell_scripts/* scripts/bash/
rmdir shell_scripts

# Move source files
echo "Moving source files..."
# API files
for file in source/api/*.c source/api/*.h; do
    if [ -f "$file" ]; then
        cp "$file" "src/api/$(basename "$file")"
    fi
done

# Core files
for file in source/core/*.c source/core/*.h; do
    if [ -f "$file" ]; then
        cp "$file" "src/core/$(basename "$file")"
    fi
done

# Quantum files
for file in source/quantum/*.c source/quantum/*.h; do
    if [ -f "$file" ]; then
        cp "$file" "src/quantum/$(basename "$file")"
    fi
done

# Quantum field files
for file in source/quantum/field/*.c source/quantum/field/*.h; do
    if [ -f "$file" ]; then
        cp "$file" "src/quantum/field/$(basename "$file")"
    fi
done

# Utils files
for file in source/utils/*.c source/utils/*.h; do
    if [ -f "$file" ]; then
        cp "$file" "src/utils/$(basename "$file")"
    fi
done

# Asm files
for file in source/utils/asm/*.s; do
    if [ -f "$file" ]; then
        cp "$file" "src/utils/asm/$(basename "$file")"
    fi
done

# Tools files
for file in source/tools/*.c source/tools/*.h; do
    if [ -f "$file" ]; then
        cp "$file" "src/tools/$(basename "$file")"
    fi
done

# Move noesis_libc to libs directory
echo "Moving noesis_libc to libs directory..."
mv noesis_libc libs/

# Update Makefile
echo "Updating Makefile for new directory structure..."
cp Makefile Makefile.original
sed -i.bak 's|SRC_DIR = source|SRC_DIR = src|g' Makefile
sed -i.bak 's|OBJ_DIR = object|OBJ_DIR = build/obj|g' Makefile
sed -i.bak 's|BIN_DIR = bin|BIN_DIR = build/bin|g' Makefile
sed -i.bak 's|ASM_DIR = source/utils/asm|ASM_DIR = src/utils/asm|g' Makefile
sed -i.bak 's|-Inoesis_libc/include|-Ilibs/noesis_libc/include|g' Makefile
rm Makefile.bak

echo "Restructuring complete. Please verify the new structure and update any remaining references manually."
echo
echo "Note: The original directory structure has been preserved. Once you've verified everything works,"
echo "you can remove the old directories with: rm -rf source object bin"
