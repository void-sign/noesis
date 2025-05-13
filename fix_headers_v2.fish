#!/usr/bin/env fish

# Script to properly fix headers and empty lines in source files
# This version targets specific patterns observed in the codebase

# Process each file
for file in (find . -type f \( -name "*.c" -o -name "*.h" -o -name "*.s" \))
    echo "Processing $file"
    
    # Create a temporary file
    set tmp_file (mktemp)
    
    # Step 1: Extract content of the file
    cat "$file" > "$tmp_file"
    
    # Step 2: Fix corrupted headers
    
    # First, completely clear and rewrite corrupted comment headers
    if grep -q "Copyright (c) 2025 Napol Thanarangkaun" "$tmp_file"
        # Get clean content without any header
        set tmp_file2 (mktemp)
        
        # Remove all malformed headers but preserve the code
        sed -n '/Copyright (c) 2025 Napol Thanarangkaun/,+3d;p' "$tmp_file" > "$tmp_file2"
        
        # Create a new clean header
        echo "/*" > "$tmp_file"
        echo " * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)" >> "$tmp_file"
        echo " * Licensed under Noesis License - See LICENSE file for details" >> "$tmp_file"
        echo " */" >> "$tmp_file"
        echo "" >> "$tmp_file"  # Add single empty line after header
        
        # Append the content without any header
        cat "$tmp_file2" >> "$tmp_file"
        
        # Clean up
        rm -f "$tmp_file2"
    end
    
    # Step 3: Fix multiple empty lines
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
    
    # Step 4: Apply changes to the original file
    cat "$tmp_file2" > "$file"
    
    # Clean up
    rm -f "$tmp_file" "$tmp_file2"
    
    echo "Completed processing $file"
end

echo "Header cleanup completed successfully!"
