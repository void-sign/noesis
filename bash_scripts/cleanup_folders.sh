#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#



echo "Cleaning up folder structure..."
echo "============================="

# Check if noesis-core exists and we have the same structure at the top level
if [ -d "noesis-core" ] && [ -d "source" ] && [ -d "include" ]; then
    echo "Found redundant folder structure."
    echo "This repository should contain the core functionality directly in the root."
    
    echo "Performing safety checks..."
    # Verify that the content is similar between the two structures
    file_matches=0
    total_files=0
    
    # Check a few critical files to make sure they match
    critical_files=(
        "source/core/emotion.c"
        "include/core/emotion.h"
        "source/core/perception.c"
        "include/core/perception.h"
    )
    
    for file in "${critical_files[@]}"; do
        total_files=$((total_files + 1))
        if [ -f "$file" ] && [ -f "noesis-core/$file" ]; then
            # Check if files are identical
            if cmp -s "$file" "noesis-core/$file"; then
                file_matches=$((file_matches + 1))
                echo "✓ Verified: $file matches noesis-core/$file"
            else
                echo "⚠️ Warning: $file differs from noesis-core/$file"
            fi
        fi
    done
    
    # If most critical files match, we can proceed
    if [ $file_matches -ge $((total_files - 1)) ]; then
        echo "Safety check passed. Root and noesis-core appear to contain the same code."
        echo "Since the migration suggests noesis-core/* should now be noesis/*, "
        echo "and we already have the correct structure in the root directory, "
        echo "we can safely remove the redundant noesis-core directory."
        
        echo "Removing noesis-core directory..."
        rm -rf noesis-core
        echo "✓ Removed noesis-core directory"
    else
        echo "⚠️ Warning: Root and noesis-core directories appear to contain different code."
        echo "Please manually review the contents of both directories before cleaning up."
        echo "You may want to check for unique files in noesis-core that should be preserved."
    fi
else
    echo "No redundant folder structure found. No action needed."
fi

echo
echo "Folder structure cleanup complete!"
echo "==============================="
