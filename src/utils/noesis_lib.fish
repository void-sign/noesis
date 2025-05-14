#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# noesis_lib.fish - Common utility functions for Noesis

# Define constants
set -g TRUE 1
set -g FALSE 0

# Print with timestamp
function print_timestamp
    set message $argv[1]
    set timestamp (date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $message"
end

# Check if a value is numeric
function is_numeric
    set val $argv[1]
    string match -qr '^[0-9]+(\.[0-9]+)?$' "$val"
    return $status
end

# Check if a file exists
function file_exists
    set file_path $argv[1]
    test -f "$file_path"
    return $status
end

# Check if a directory exists
function dir_exists
    set dir_path $argv[1]
    test -d "$dir_path"
    return $status
end

# Create directory if it doesn't exist
function ensure_dir
    set dir_path $argv[1]
    if not test -d "$dir_path"
        mkdir -p "$dir_path"
    end
    return $status
end

# Read a file into a string
function read_file
    set file_path $argv[1]
    if test -f "$file_path"
        cat "$file_path"
        return 0
    end
    return 1
end

# Write a string to a file
function write_file
    set file_path $argv[1]
    set content $argv[2]
    echo "$content" > "$file_path"
    return $status
end

# Append a string to a file
function append_file
    set file_path $argv[1]
    set content $argv[2]
    echo "$content" >> "$file_path"
    return $status
end

# Get current timestamp
function get_timestamp
    date +%s
end

# Format a number with specified precision
function format_number
    set number $argv[1]
    set precision $argv[2]
    
    if test -z "$precision"
        set precision 2
    end
    
    printf "%.%sf" $precision $number
end

# Generate a random ID
function generate_id
    set prefix $argv[1]
    set length $argv[2]
    
    if test -z "$prefix"
        set prefix "noesis"
    end
    
    if test -z "$length"
        set length 8
    end
    
    set random_part (random 100000000 999999999)
    set timestamp (date +%s)
    set id "$prefix"_"$random_part"_"$timestamp"
    
    echo $id
end
