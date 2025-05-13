#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#



echo "Cleaning up Noesis repository..."
echo "==============================="

# Remove backup files
echo "Removing backup files..."
rm -f README.md.backup README.md.new
echo "✓ Backup README files removed"

# Remove backup directories
echo "Removing backup directories..."
rm -rf backup_extensions
echo "✓ Backup extensions directory removed"

# Check and remove quantum directory if it exists
if [ -d "quantum" ]; then
    echo "Removing quantum directory (should be in noesis-extend)..."
    rm -rf quantum
    echo "✓ Quantum directory removed"
fi

# Remove any potential duplicate files between root and noesis-core
echo "Checking for duplicate files between root and noesis-core..."

# List of potential duplicates (README, LICENSE, etc.)
potential_duplicates=(
    "README.md"
    "LICENSE"
    "Makefile"
)

for file in "${potential_duplicates[@]}"; do
    if [ -f "$file" ] && [ -f "noesis-core/$file" ]; then
        echo "Found duplicate file: $file"
        echo "→ Keeping the file in the root directory"
        echo "→ Removing duplicate from noesis-core/$file"
        rm -f "noesis-core/$file"
    fi
done

# Cleanup any temporary or intermediate files
echo "Removing any other unnecessary files..."
find . -name "*.tmp" -o -name "*.bak" -delete 2>/dev/null || true

# Handle duplicate changelogs
echo "Checking for duplicate changelog files..."
for changelog in noesis-core/changelogs/CHANGELOG_*.md; do
    basename=$(basename "$changelog")
    if [ -f "changelogs/$basename" ]; then
        echo "Found duplicate changelog: $basename"
        # Compare content to see if they're identical
        if cmp -s "changelogs/$basename" "$changelog"; then
            echo "→ Files are identical, removing duplicate from noesis-core"
            rm -f "$changelog"
        else
            echo "→ Files differ, keeping both versions"
            echo "  (You may want to manually review these files)"
        fi
    fi
done

echo
echo "Repository cleanup complete!"
echo "=========================="
