#!/usr/bin/env fish

# fix_comments.fish - Script to fix nested comment issues in C files
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details

set PROJECT_ROOT (dirname (dirname (status --current-filename)))
set DATE_STAMP (date '+%Y%m%d_%H%M%S')
set BACKUP_DIR "$PROJECT_ROOT/backups/comment_fixes_$DATE_STAMP"

# Create backup directory
mkdir -p $BACKUP_DIR

echo "Fixing nested comments in C files and headers..."
echo "Backup directory: $BACKUP_DIR"

# Function to fix a single file
function fix_file
    set file $argv[1]
    set relative_path (string replace "$PROJECT_ROOT/" "" "$file")
    set backup_file "$BACKUP_DIR/$relative_path"
    
    # Create backup directory structure
    mkdir -p (dirname $backup_file)
    
    # Create backup
    cp $file $backup_file
    
    echo "Processing: $relative_path"
    
    # Use sed to fix the nested comments by converting:
    # /*
    # /*
    # to:
    # /*
    # End previous comment and replace with single line comment
    sed -i.bak -E '
        # Match the pattern of a comment start followed by another comment start
        /\/\*[ \t]*$/{
            # Read next line
            N
            # If it starts with another comment start, replace it with regular comment
            s/\/\*[ \t]*\n[ \t]*\/\*[ \t]*/\/\*\n\/\/ /g
        }
        
        # Also handle multiple nested comments in sequence
        /\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*/s/\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*/\/\*\n\/\/ /g
        /\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*/s/\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*/\/\*\n\/\/ /g
        /\/\*[ \t]*\n[ \t]*\/\*[ \t]*/s/\/\*[ \t]*\n[ \t]*\/\*[ \t]*/\/\*\n\/\/ /g
    ' $file
    
    # Remove backup created by sed
    rm -f "$file.bak"
end

# Find all C files and headers with potentially nested comments
set files (find $PROJECT_ROOT \( -name "*.c" -o -name "*.h" \) -type f -exec grep -l '/\*[ \t]*$' {} \; | xargs grep -l '/\*[ \t]*' || echo "")

if test -n "$files"
    for file in $files
        fix_file $file
    end
    echo "Fixed nested comments in "(count $files)" files"
    echo "Original files backed up to $BACKUP_DIR"
else
    echo "No files with nested comments found"
end

# Special handling for known problematic header files
echo "Checking known problematic header files..."
set header_files (find $PROJECT_ROOT -name "*.h")
for header in $header_files
    set relative_path (string replace "$PROJECT_ROOT/" "" "$header")
    # Create backup of header
    set backup_file "$BACKUP_DIR/$relative_path"
    mkdir -p (dirname $backup_file)
    cp $header $backup_file
    
    # Fix header files with same pattern
    echo "Processing header: $relative_path"
    sed -i.bak -E '
        # Match the pattern of a comment start followed by another comment start
        /\/\*[ \t]*$/{
            # Read next line
            N
            # If it starts with another comment start, replace it with regular comment
            s/\/\*[ \t]*\n[ \t]*\/\*[ \t]*/\/\*\n\/\/ /g
        }
        
        # Also handle multiple nested comments in sequence
        /\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*/s/\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*/\/\*\n\/\/ /g
        /\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*/s/\/\*[ \t]*\n[ \t]*\/\*[ \t]*\n[ \t]*\/\*[ \t]*/\/\*\n\/\/ /g
        /\/\*[ \t]*\n[ \t]*\/\*[ \t]*/s/\/\*[ \t]*\n[ \t]*\/\*[ \t]*/\/\*\n\/\/ /g
    ' $header
    
    # Remove backup created by sed
    rm -f "$header.bak"
end

# Compile to check if all issues are resolved
cd $PROJECT_ROOT
echo "Running make to verify fixes..."
make

echo "Comment fix complete. Check compilation results above for any remaining issues."
