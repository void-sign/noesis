#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# noesis_lib.fish - Utility functions for the Noesis system

# Get current time in seconds since epoch
function noesis_get_time
    date +%s
end

# Print a message to the console
function noesis_print
    set message $argv[1]
    echo -n $message
end

# Read a line of input from the user
function noesis_read
    set buffer $argv[1]
    read -l input
    set $buffer $input
    echo $input | wc -c
end

# String comparison function
function noesis_scmp
    set a $argv[1]
    set b $argv[2]
    
    if test "$a" = "$b"
        return 0
    else
        return 1
    end
end

# Format a string with arguments (simple version)
function noesis_sbuffer
    set format $argv[2]
    set args $argv[3..-1]
    
    # Use printf to format the string
    printf $format $args
end

# Execute a shell command and capture its output
function execute_shell_command
    set cmd $argv[1]
    
    if test -z "$cmd"
        echo "Error: Empty command"
        return 1
    end
    
    # Execute the command and capture output
    set output (eval $cmd)
    
    # Print the output
    echo $output
    
    return 0
end

# Check if a file exists
function noesis_file_exists
    set filename $argv[1]
    
    if test -f "$filename"
        return 0
    else
        return 1
    end
end

# Get file size
function noesis_file_size
    set filename $argv[1]
    
    if test -f "$filename"
        stat -f %z "$filename"
        return 0
    else
        echo "0"
        return 1
    end
end

# Read a file into a string
function noesis_read_file
    set filename $argv[1]
    
    if test -f "$filename"
        cat "$filename"
        return 0
    else
        echo "Error: File not found: $filename"
        return 1
    end
end

# Write a string to a file
function noesis_write_file
    set filename $argv[1]
    set content $argv[2..-1]
    
    echo $content > "$filename"
    return $status
end

# Append a string to a file
function noesis_append_file
    set filename $argv[1]
    set content $argv[2..-1]
    
    echo $content >> "$filename"
    return $status
end
