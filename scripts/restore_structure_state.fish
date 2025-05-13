#!/usr/bin/env fish

# Script to restore the structure state of the Noesis project
# Created: May 13, 2025
# This script recreates the structure based on a saved state

if test (count $argv) -eq 0
    echo "Usage: ./restore_structure_state.fish <timestamp>"
    echo "Example: ./restore_structure_state.fish 20250513210700"
    exit 1
end

set TIMESTAMP $argv[1]
set ROOT_DIR (dirname (dirname (status -f)))
cd $ROOT_DIR

# Check if the structure file exists
if not test -f "docs/directory_structure_$TIMESTAMP.txt"
    echo "Error: Structure file docs/directory_structure_$TIMESTAMP.txt not found"
    echo "Available structure files:"
    ls -1 docs/directory_structure_*.txt 2>/dev/null || echo "None found"
    exit 1
end

echo "Restoring project structure from state $TIMESTAMP..."

# Create all directories from the saved structure
for dir in (cat "docs/directory_structure_$TIMESTAMP.txt")
    if test -d "$dir"
        echo "Directory already exists: $dir"
    else
        mkdir -p "$dir"
        echo "Created directory: $dir"
    end
end

# Restore Makefile if it exists
if test -f "docs/Makefile_$TIMESTAMP"
    cp "docs/Makefile_$TIMESTAMP" Makefile
    echo "Restored Makefile"
end

# Restore tasks.json if it exists
if test -f "docs/tasks.json_$TIMESTAMP"
    mkdir -p .vscode
    cp "docs/tasks.json_$TIMESTAMP" .vscode/tasks.json
    echo "Restored .vscode/tasks.json"
end

# Restore .gitignore if it exists
if test -f "docs/gitignore_$TIMESTAMP"
    cp "docs/gitignore_$TIMESTAMP" .gitignore
    echo "Restored .gitignore"
end

echo "Structure restoration complete!"
echo "Note: This script only restores the directory structure and key configuration files."
echo "The content of source files was not modified."
