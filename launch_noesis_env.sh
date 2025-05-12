#!/bin/bash

# launch_noesis_env.sh - Setup environment for working with both repositories
# This script helps developers work with both Noesis Core and Noesis-Extend

if [ $# -eq 0 ]; then
    echo "Usage: ./launch_noesis_env.sh [extend_path] [core_path]"
    echo
    echo "Arguments:"
    echo "  extend_path - Path to Noesis-Extend repository (default: ../noesis-extend)"
    echo "  core_path   - Path to Noesis Core repository (default: .)"
    echo
    echo "This script will:"
    echo "  1. Set up environment variables for cross-repository development"
    echo "  2. Open VS Code with both repositories"
    echo
    exit 0
fi

# Default paths
EXTEND_PATH="../noesis-extend"
CORE_PATH="."

# Use arguments if provided
if [ $# -ge 1 ]; then
    EXTEND_PATH="$1"
fi

if [ $# -ge 2 ]; then
    CORE_PATH="$2"
fi

# Resolve to absolute paths
CORE_PATH=$(realpath "$CORE_PATH")
EXTEND_PATH=$(realpath "$EXTEND_PATH")

# Check if directories exist
if [ ! -d "$CORE_PATH" ]; then
    echo "Error: Noesis Core directory not found at $CORE_PATH"
    exit 1
fi

if [ ! -d "$EXTEND_PATH" ]; then
    echo "Error: Noesis-Extend directory not found at $EXTEND_PATH"
    exit 1
fi

# Set environment variables
export NOESIS_CORE_PATH="$CORE_PATH"
export NOESIS_EXTEND_PATH="$EXTEND_PATH"
export LD_LIBRARY_PATH="$CORE_PATH/lib:$LD_LIBRARY_PATH"

echo "Environment set up for Noesis development:"
echo "- NOESIS_CORE_PATH: $NOESIS_CORE_PATH"
echo "- NOESIS_EXTEND_PATH: $NOESIS_EXTEND_PATH"
echo "- LD_LIBRARY_PATH updated to include Noesis Core libraries"

# Launch VS Code with both repositories
code "$CORE_PATH" "$EXTEND_PATH"

echo "VS Code launched with both repositories."
echo "Happy coding!"
