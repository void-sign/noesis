#!/usr/bin/env fish
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
if test -d "quantum"
    echo "Removing quantum directory (should be in noesis-extend)..."
    rm -rf quantum
    echo "✓ Quantum directory removed"
end

# Remove any potential duplicate files between root and noesis-core
echo "Checking for duplicate files between root and noesis-core..."

# List of potential duplicates (README, LICENSE, etc.)
set potential_duplicates \
    "README.md" \
    "LICENSE" \
    "Makefile"

for file in $potential_duplicates
    if test -f $file -a -f "noesis-core/$file"
        echo "Found duplicate file: $file"
        echo "→ Keeping the file in the root directory"
        echo "→ Removing duplicate from noesis-core/$file"
        rm -f "noesis-core/$file"
    end
end

# Cleanup any temporary or intermediate files
echo "Removing any other unnecessary files..."
find . -name "*.tmp" -o -name "*.bak" -delete 2>/dev/null || true

# Handle duplicate changelogs
echo "Checking for duplicate changelog files..."
for changelog in noesis-core/changelogs/CHANGELOG_*.md
    set basename (basename $changelog)
    if test -f "changelogs/$basename"
        echo "Found duplicate changelog: $basename"
        # Compare content to see if they're identical
        if cmp -s "changelogs/$basename" $changelog
            echo "→ Files are identical, removing duplicate from noesis-core"
            rm -f $changelog
        else
            echo "→ Files differ, keeping both versions"
            echo "  (You may want to manually review these files)"
        end
    end
end

echo
echo "Repository cleanup complete!"
echo "=========================="
