#!/bin/bash

# validate_split.sh - Validate theset EXTEND_CRITICAL_FILES=(
    "$NOESIS_EXTEND_PATH/LICENSE"
    "$NOESIS_EXTEND_PATH/Makefile"
    "$NOESIS_EXTEND_PATH/include/quantum/quantum.h"
    "$NOESIS_EXTEND_PATH/source/quantum/quantum.c"
    "$NOESIS_EXTEND_PATH/scripts/install_dependency.sh"
)tory split
# This script checks that both repositories are properly set up

echo "Noesis Repository Split Validation"
echo "================================="
echo

NOESIS_PATH="/Users/plugio/Documents/GitHub/noesis"
NOESIS_EXTEND_PATH="/Users/plugio/Documents/GitHub/noesis-extend"

# Check if directories exist
if [ ! -d "$NOESIS_PATH" ]; then
    echo "Error: Noesis Core directory not found at $NOESIS_PATH"
    exit 1
fi

if [ ! -d "$NOESIS_EXTEND_PATH" ]; then
    echo "Error: Noesis-Extend directory not found at $NOESIS_EXTEND_PATH"
    exit 1
fi

echo "✓ Both repositories found"

# Check for critical files in Noesis Core
CORE_CRITICAL_FILES=(
    "$NOESIS_PATH/LICENSE"
    "$NOESIS_PATH/Makefile"
    "$NOESIS_PATH/include/core/emotion.h"
    "$NOESIS_PATH/source/core/emotion.c"
)

echo "Checking for critical files in Noesis Core..."
ERROR=false
for file in "${CORE_CRITICAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "✗ Missing file: $file"
        ERROR=true
    fi
done

if [ "$ERROR" = false ]; then
    echo "✓ All critical Core files found"
fi

# Check for critical files in Noesis-Extend
EXTEND_CRITICAL_FILES=(
    "$NOESIS_EXTEND_PATH/LICENSE"
    "$NOESIS_EXTEND_PATH/Makefile"
    "$NOESIS_EXTEND_PATH/include/quantum/quantum.h"
    "$NOESIS_EXTEND_PATH/source/quantum/quantum.c"
    "$NOESIS_EXTEND_PATH/scripts/install_dependency.fish"
)

echo "Checking for critical files in Noesis-Extend..."
for file in "${EXTEND_CRITICAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "✗ Missing file: $file"
        ERROR=true
    fi
done

if [ "$ERROR" = false ]; then
    echo "✓ All critical Extend files found"
fi

# Check for lingering quantum files in Core
echo "Checking for quantum files in Core..."
QUANTUM_FILES=$(find "$NOESIS_PATH/source" -name "quantum*.c" -o -name "quantum*.h" 2>/dev/null)
if [ -n "$QUANTUM_FILES" ]; then
    echo "✗ Found quantum files in Core repository:"
    echo "$QUANTUM_FILES" | while read file; do
        echo "  - $file"
    done
    ERROR=true
else
    echo "✓ No quantum files found in Core"
fi

# Check for core-only files in Extend
echo "Checking for core files in Extend..."
CORE_FILES=$(find "$NOESIS_EXTEND_PATH/source" -name "emotion*.c" -o -name "logic*.c" -o -name "perception*.c" 2>/dev/null)
if [ -n "$CORE_FILES" ]; then
    echo "✗ Found core files in Extend repository:"
    echo "$CORE_FILES" | while read file; do
        echo "  - $file"
    done
    ERROR=true
else
    echo "✓ No core files found in Extend"
fi

# Check for "yourusername" in files
echo "Checking for 'yourusername' in Core..."
USERNAME_REFS=$(grep -r "yourusername" --include="*.md" --include="*.sh" --include="*.yml" "$NOESIS_PATH" 2>/dev/null)
if [ -n "$USERNAME_REFS" ]; then
    echo "✗ Found 'yourusername' references in Core:"
    echo "$USERNAME_REFS"
    ERROR=true
else
    echo "✓ No 'yourusername' references found in Core"
fi

echo "Checking for 'yourusername' in Extend..."
USERNAME_REFS=$(grep -r "yourusername" --include="*.md" --include="*.sh" --include="*.yml" "$NOESIS_EXTEND_PATH" 2>/dev/null)
if [ -n "$USERNAME_REFS" ]; then
    echo "✗ Found 'yourusername' references in Extend:"
    echo "$USERNAME_REFS"
    ERROR=true
else
    echo "✓ No 'yourusername' references found in Extend"
fi

echo
if [ "$ERROR" = true ]; then
    echo "⚠️ Validation completed with errors"
    echo "Please fix the issues listed above before proceeding."
    exit 1
else
    echo "🎉 Validation successful! All checks passed."
    echo "You can now proceed with the repository setup."
    echo "See CHECKLIST.md for next steps."
fi
