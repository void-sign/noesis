#!/usr/bin/env bash

# Script to restore the structure state of the Noesis project
# Created: May 13, 2025
# This script recreates the structure based on a saved state

if [ $# -eq 0 ]; then
    echo "Usage: ./restore_structure_state.sh <timestamp>"
    echo "Example: ./restore_structure_state.sh 20250513210700"
    exit 1
fi

TIMESTAMP=$1
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Check if the structure file exists
if [ ! -f "docs/directory_structure_$TIMESTAMP.txt" ]; then
    echo "Error: Structure file docs/directory_structure_$TIMESTAMP.txt not found"
    echo "Available structure files:"
    ls -1 docs/directory_structure_*.txt 2>/dev/null || echo "None found"
    exit 1
fi

echo "Restoring project structure from state $TIMESTAMP..."

# Create all directories from the saved structure
while read -r dir; do
    if [ -d "$dir" ]; then
        echo "Directory already exists: $dir"
    else
        mkdir -p "$dir"
        echo "Created directory: $dir"
    fi
done < "docs/directory_structure_$TIMESTAMP.txt"

# Restore Makefile if it exists
if [ -f "docs/Makefile_$TIMESTAMP" ]; then
    cp "docs/Makefile_$TIMESTAMP" Makefile
    echo "Restored Makefile"
fi

# Restore tasks.json if it exists
if [ -f "docs/tasks.json_$TIMESTAMP" ]; then
    mkdir -p .vscode
    cp "docs/tasks.json_$TIMESTAMP" .vscode/tasks.json
    echo "Restored .vscode/tasks.json"
fi

# Restore .gitignore if it exists
if [ -f "docs/gitignore_$TIMESTAMP" ]; then
    cp "docs/gitignore_$TIMESTAMP" .gitignore
    echo "Restored .gitignore"
fi

echo "Structure restoration complete!"
echo "Note: This script only restores the directory structure and key configuration files."
echo "The content of source files was not modified."
