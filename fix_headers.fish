#!/usr/bin/env fish
# Script to clean up headers and empty lines in source files

# Process each file
for file in (find . -type f -name "*.c" -o -name "*.h" -o -name "*.s")
    echo "Processing $file"
    
    # Create a temporary file
    set tmp_file (mktemp)
    
    # Remove duplicate headers and consecutive blank lines
    
    # Step 1: Extract content of the file
    cat "$file" > "$tmp_file"
    
    # Check if file has multiple copyright headers
    if grep -q "Copyright (c) 2025 Napol Thanarangkaun" "$tmp_file" 
        # Handle first pattern - Permission is hereby granted
        sed -i.bak -e '/Permission is hereby granted/,/\*\//d' "$tmp_file"
        rm -f "$tmp_file.bak"

        # Handle second pattern - harm other humans
        sed -i.bak -e '/harm other humans/,/\*\//d' "$tmp_file"
        rm -f "$tmp_file.bak"

        # Fix broken comments and double /* markers
        sed -i.bak -e 's/\/\*\s*\/\*/\/\*/g' "$tmp_file"
        rm -f "$tmp_file.bak"
        
        # Fix broken headers - ensure only one /* at the beginning
        sed -i.bak -e 's/\/\*\s*\/\*/\/\*/g' "$tmp_file" 
        rm -f "$tmp_file.bak"
        
        # Fix any trailing */ that shouldn't be there
        sed -i.bak -e 's/\*\/\s*\*\//\*\//g' "$tmp_file"
        rm -f "$tmp_file.bak"
    end
    
    # Step 2: Remove consecutive empty lines
    set tmp_file2 (mktemp)
    awk '
    BEGIN { blank_count = 0; }
    /^[ \t]*$/ { blank_count++; next; }
    { if (blank_count > 0) { print ""; blank_count = 0; } print $0; }
    END { if (blank_count > 0) print ""; }
    ' "$tmp_file" > "$tmp_file2"
    
    # Step 3: Apply changes back to the original file
    cat "$tmp_file2" > "$file"
    
    # Cleanup temporary files
    rm -f "$tmp_file" "$tmp_file2"
end

echo "Header cleanup completed!"
