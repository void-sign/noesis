#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#
# Script to update repository references from noesis-extend to noesis-hub

echo "Updating repository references from 'noesis-extend' to 'noesis-hub'..."

# Find all files that contain 'noesis-extend' and update them
find . -type f \( -name "*.md" -o -name "*.sh" -o -name "*.fish" -o -name "*.json" \) -exec grep -l "noesis-extend" {} \; | while read file; do
    echo "Updating $file..."
    sed -i '' 's/noesis-extend/noesis-hub/g' "$file"
    sed -i '' 's/Noesis-Extend/Noesis Hub/g' "$file"
    sed -i '' 's/Noesis-extend/Noesis Hub/g' "$file"
done

echo "Updates completed!"
