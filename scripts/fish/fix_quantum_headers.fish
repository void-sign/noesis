#!/usr/bin/env fish

# fix_quantum_headers.fish - Script to fix only the problematic quantum header files
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details

set PROJECT_ROOT (dirname (dirname (status --current-filename)))
set DATE_STAMP (date '+%Y%m%d_%H%M%S')
set BACKUP_DIR "$PROJECT_ROOT/backups/quantum_header_fixes_$DATE_STAMP"

# Create backup directory
mkdir -p $BACKUP_DIR

echo "Fixing nested comments in quantum header files..."
echo "Backup directory: $BACKUP_DIR"

# List of problematic quantum headers
set header_files "$PROJECT_ROOT/include/quantum/backend.h" "$PROJECT_ROOT/include/quantum/quantum.h"

for header in $header_files
    set relative_path (string replace "$PROJECT_ROOT/" "" "$header")
    
    # Create backup
    set backup_file "$BACKUP_DIR/$relative_path"
    mkdir -p (dirname $backup_file)
    cp $header $backup_file
    
    echo "Processing: $relative_path"
    
    # Read the file content
    set file_content (cat $header)
    
    # Check if the file has nested comments
    if string match -q "*/*\n/**" -- "$file_content"
        # Fix the nested comments by replacing with proper C comments
        echo "// filepath: $header
/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// Core header for the quantum module
" > $header
        
        # Append the rest of the file (after any problematic comment blocks)
        grep -A 1000 "#include" $backup_file >> $header || echo "#pragma once" >> $header
        
        echo "Fixed nested comments in $relative_path"
    else
        echo "No nested comments found in $relative_path"
    end
end

# Compile to check if all issues are resolved
cd $PROJECT_ROOT
echo "Running make to verify fixes..."
make

echo "Quantum header fix complete. Check compilation results above for any remaining issues."
