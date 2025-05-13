#!/bin/bash
# Script to update header comments in various file types

# The standard header for C and H files
c_header='/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

'

# The standard header for shell and fish scripts (after shebang)
script_header='#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

'

# Function to insert/update C/H file headers
update_c_header() {
    local file="$1"
    if grep -q "Licensed under Noesis License" "$file"; then
        echo "Header already updated for $file"
        return
    fi
    
    # Check if file has a comment header to replace
    if grep -q "/\*" "$file" && grep -q "\*/" "$file"; then
        # Try to replace existing comment header
        if [[ -z $(sed -n '/\/\*/,/\*\//p' "$file") ]]; then
            echo "Cannot find proper comment block in $file, prepending header"
            tmp_file=$(mktemp)
            echo "$c_header" > "$tmp_file"
            cat "$file" >> "$tmp_file"
            mv "$tmp_file" "$file"
        else
            echo "Replacing header in $file"
            sed -i.bak '/\/\*/,/\*\//c\'"$c_header" "$file"
            rm -f "${file}.bak"
        fi
    else
        # No existing header, prepend new one
        echo "Prepending header to $file"
        tmp_file=$(mktemp)
        echo "$c_header" > "$tmp_file"
        cat "$file" >> "$tmp_file"
        mv "$tmp_file" "$file"
    fi
}

# Function to insert/update script file headers
update_script_header() {
    local file="$1"
    if grep -q "Licensed under Noesis License" "$file"; then
        echo "Header already updated for $file"
        return
    fi
    
    # Check if file has a shebang line
    if head -1 "$file" | grep -q "^#!"; then
        # Insert after shebang
        echo "Updating header in $file"
        first_line=$(head -1 "$file")
        tmp_file=$(mktemp)
        echo "$first_line" > "$tmp_file"
        echo "$script_header" >> "$tmp_file"
        tail -n +2 "$file" >> "$tmp_file"
        mv "$tmp_file" "$file"
    else
        # No shebang, prepend new header
        echo "Prepending header to $file"
        tmp_file=$(mktemp)
        echo "$script_header" > "$tmp_file"
        cat "$file" >> "$tmp_file"
        mv "$tmp_file" "$file"
    fi
}

# Update all C and H files
find . -type f -name "*.c" -o -name "*.h" | while read -r file; do
    update_c_header "$file"
done

# Update all assembly files
find . -type f -name "*.s" | while read -r file; do
    update_c_header "$file"
done

# Update all shell scripts
find . -type f -name "*.sh" | while read -r file; do
    update_script_header "$file"
done

# Update all fish scripts
find . -type f -name "*.fish" | while read -r file; do
    update_script_header "$file"
done

echo "Header update process completed!"
