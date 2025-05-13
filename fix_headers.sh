#!/bin/bash
# Script to clean up headers and empty lines in source files

# Find all source files
find . -type f \( -name "*.c" -o -name "*.h" -o -name "*.s" \) -print0 | while IFS= read -r -d '' file; do
  echo "Processing $file"
  
  # Create a temporary file
  tmp_file=$(mktemp)
  
  # Check if file has the duplicate header pattern
  if grep -q "Copyright (c) 2025 Napol Thanarangkaun.*Licensed under Noesis License" "$file" && \
     grep -q "Permission is hereby granted" "$file"; then
    
    # Extract short header (first occurrence) and skip long header
    awk '
      BEGIN { header_found = 0; skip_mode = 0; }
      /\/\* Copyright \(c\) 2025 Napol Thanarangkaun/ {
        if (header_found == 0) {
          print;
          header_found = 1;
        } else {
          skip_mode = 1;
          next;
        }
        next;
      }
      /\*\// {
        if (skip_mode == 1) {
          skip_mode = 0;
          next;
        }
        print;
        next;
      }
      { if (skip_mode == 0) print; }
    ' "$file" > "$tmp_file"
  else
    # Just copy the file content
    cat "$file" > "$tmp_file"
  fi
  
  # Remove consecutive empty lines, keeping just one
  awk '
    BEGIN { empty_lines = 0; }
    /^$/ { 
      empty_lines++; 
      if (empty_lines <= 1) print;
    }
    /[^\s]/ { 
      empty_lines = 0; 
      print;
    }
  ' "$tmp_file" > "${tmp_file}.2"
  
  # Replace original file with cleaned up version
  mv "${tmp_file}.2" "$file"
  rm -f "$tmp_file"
done

echo "Header cleanup completed!"
