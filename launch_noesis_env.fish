#!/bin/fish

# launch_noesis_env.fish - Setup environment for working with both repositories
# This script helps developers work with both Noesis Core and Noesis-Extend

if test (count $argv) -eq 0
    echo "Usage: ./launch_noesis_env.fish [extend_path] [core_path]"
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
end

# Default paths
set -l EXTEND_PATH "../noesis-extend"
set -l CORE_PATH "."

# Use arguments if provided
if test (count $argv) -ge 1
    set EXTEND_PATH $argv[1]
end

if test (count $argv) -ge 2
    set CORE_PATH $argv[2]
end

# Resolve to absolute paths
set CORE_PATH (realpath $CORE_PATH)
set EXTEND_PATH (realpath $EXTEND_PATH)

# Check if directories exist
if not test -d $CORE_PATH
    echo "Error: Noesis Core directory not found at $CORE_PATH"
    exit 1
end

if not test -d $EXTEND_PATH
    echo "Error: Noesis-Extend directory not found at $EXTEND_PATH"
    exit 1
end

# Set environment variables
set -gx NOESIS_CORE_PATH $CORE_PATH
set -gx NOESIS_EXTEND_PATH $EXTEND_PATH
set -gx LD_LIBRARY_PATH $CORE_PATH/lib:$LD_LIBRARY_PATH

echo "Environment set up for Noesis development:"
echo "- NOESIS_CORE_PATH: $NOESIS_CORE_PATH"
echo "- NOESIS_EXTEND_PATH: $NOESIS_EXTEND_PATH"
echo "- LD_LIBRARY_PATH updated to include Noesis Core libraries"

# Launch VS Code with both repositories
code $CORE_PATH $EXTEND_PATH

echo "VS Code launched with both repositories."
echo "Happy coding!"
