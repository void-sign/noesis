#!/usr/bin/env fish

# Script to properly fix headers and empty lines in source files
# This version combines functionality from all header fix scripts

# Standard header for C and H files
set c_header '/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */'

# Standard header for shell and fish scripts
set script_header '#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#'

# Process each file
for file in (find . -type f \( -name "*.c" -o -name "*.h" -o -name "*.s" \))
    echo "Processing $file"
    
    # Create a temporary file
    set tmp_file (mktemp)
    
    # Check if the file already has the correct license
    if grep -q "Licensed under Noesis License" "$file"
        echo "Header already updated for $file"
        cat "$file" > "$tmp_file"
    else
        # Extract content of the file
        cat "$file" > "$tmp_file"
        
        # Fix corrupted headers
        if grep -q "Copyright (c) 2025 Napol Thanarangkaun" "$tmp_file"
            # Remove all malformed headers but preserve the code
            set tmp_file2 (mktemp)
            sed -n '/Copyright (c) 2025 Napol Thanarangkaun/,+3d;p' "$tmp_file" > "$tmp_file2"
            
            # Create a new clean header
            echo "$c_header" > "$tmp_file"
            echo "" >> "$tmp_file"  # Add blank line after header
            
            # Append the content without any header
            cat "$tmp_file2" >> "$tmp_file"
            
            # Clean up
            rm -f "$tmp_file2"
        else
            # No header found, add one at the beginning
            set tmp_file2 (mktemp)
            echo "$c_header" > "$tmp_file2"
            echo "" >> "$tmp_file2"  # Add blank line after header
            cat "$tmp_file" >> "$tmp_file2"
            mv "$tmp_file2" "$tmp_file"
        end
    end
    
    # Fix multiple empty lines
    set tmp_file2 (mktemp)
    awk '
    BEGIN { empty_line_count = 0; }
    /^[ \t]*$/ {
        empty_line_count++;
        if (empty_line_count <= 1) print "";
        next;
    }
    {
        empty_line_count = 0;
        print;
    }
    END {
        if (empty_line_count > 0) print "";
    }
    ' "$tmp_file" > "$tmp_file2"
    
    # Apply changes to the original file
    cat "$tmp_file2" > "$file"
    
    # Clean up
    rm -f "$tmp_file" "$tmp_file2"
    
    echo "Completed processing $file"
end

# Process script files (.sh, .fish)
for file in (find . -type f \( -name "*.sh" -o -name "*.fish" \))
    echo "Processing script $file"
    
    # Create a temporary file
    set tmp_file (mktemp)
    
    # Check if the file already has the correct license
    if grep -q "Licensed under Noesis License" "$file"
        echo "Header already updated for $file"
        cat "$file" > "$tmp_file"
    else
        # For script files with shebang
        if head -1 "$file" | grep -q "^#!"
            # Preserve shebang line
            head -1 "$file" > "$tmp_file"
            echo "" >> "$tmp_file"  # Add blank line
            echo "$script_header" >> "$tmp_file"
            echo "" >> "$tmp_file"  # Add blank line
            tail -n +2 "$file" >> "$tmp_file"
        else
            # No shebang, prepend header
            echo "$script_header" > "$tmp_file"
            echo "" >> "$tmp_file"  # Add blank line
            cat "$file" >> "$tmp_file"
        end
    end
    
    # Fix multiple empty lines
    set tmp_file2 (mktemp)
    awk '
    BEGIN { empty_line_count = 0; }
    /^[ \t]*$/ {
        empty_line_count++;
        if (empty_line_count <= 1) print "";
        next;
    }
    {
        empty_line_count = 0;
        print;
    }
    END {
        if (empty_line_count > 0) print "";
    }
    ' "$tmp_file" > "$tmp_file2"
    
    # Apply changes to the original file
    cat "$tmp_file2" > "$file"
    
    # Clean up
    rm -f "$tmp_file" "$tmp_file2"
    
    echo "Completed processing script $file"
end

echo "Header cleanup completed successfully!"
