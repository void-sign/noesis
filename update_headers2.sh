#!/bin/bash
# Script to update header comments in various file types

# The standard header for C and H files
c_header='/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */'

# The standard header for shell and fish scripts (after shebang)
script_header='#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#'

# Function to update file with given header and type
update_file() {
    local file="$1"
    local file_type="$2"
    local header="$3"
    local tmp_file

    echo "Processing $file"

    # Skip if already updated
    if grep -q "Licensed under Noesis License" "$file"; then
        echo "Header already updated for $file"
        return
    fi

    tmp_file=$(mktemp)
    
    case "$file_type" in
        "c")
            # For C/H/S files
            # Check if file starts with a C-style comment block
            if head -20 "$file" | grep -q "/\*" && head -20 "$file" | grep -q "\*/"; then
                # Replace the first comment block
                awk '
                BEGIN { in_comment=0; comment_done=0; }
                /\/\*/ && !in_comment && !comment_done { in_comment=1; print "'"$header"'"; next; }
                /\*\// && in_comment && !comment_done { in_comment=0; comment_done=1; next; }
                !in_comment { print $0; }
                ' "$file" > "$tmp_file"
            else
                # No existing comment block, prepend header
                echo "$header" > "$tmp_file"
                echo "" >> "$tmp_file"  # Add a blank line
                cat "$file" >> "$tmp_file"
            fi
            ;;
        "script")
            # For script files (.sh, .fish)
            if head -1 "$file" | grep -q "^#!"; then
                # Preserve shebang line
                head -1 "$file" > "$tmp_file"
                echo "" >> "$tmp_file"  # Add a blank line
                echo "$header" >> "$tmp_file"
                echo "" >> "$tmp_file"  # Add a blank line
                tail -n +2 "$file" >> "$tmp_file"
            else
                # No shebang, prepend header
                echo "$header" > "$tmp_file"
                echo "" >> "$tmp_file"  # Add a blank line
                cat "$file" >> "$tmp_file"
            fi
            ;;
        *)
            echo "Unknown file type: $file_type"
            rm "$tmp_file"
            return
            ;;
    esac

    # Replace original file with updated version
    mv "$tmp_file" "$file"
    echo "Updated header in $file"
}

# Update C, H, and S files
find . -type f \( -name "*.c" -o -name "*.h" -o -name "*.s" \) | while read -r file; do
    update_file "$file" "c" "$c_header"
done

# Update shell and fish scripts
find . -type f \( -name "*.sh" -o -name "*.fish" \) | while read -r file; do
    update_file "$file" "script" "$script_header"
done

echo "Header update process completed successfully!"
