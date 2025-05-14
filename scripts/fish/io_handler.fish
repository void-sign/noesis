#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# io_handler.fish - Fish script for handling I/O operations for Noesis
# This script provides input/output operations for the Noesis C code

# Command argument determines the operation
set -l operation $argv[1]

# Handle different operations
switch "$operation"
    case "print"
        # Print a message to stdout
        # Usage: ./scripts/fish/io_handler.fish print "Message to print"
        if test (count $argv) -ge 2
            echo $argv[2..-1]
        end
    
    case "read"
        # Read input from stdin and output it
        # Usage: ./scripts/fish/io_handler.fish read
        read -l input_line
        echo $input_line
    
    case "readp"
        # Read input with a prompt
        # Usage: ./scripts/fish/io_handler.fish readp "Prompt: "
        if test (count $argv) -ge 2
            read -p "$argv[2] " -l input_line
            echo $input_line
        else
            read -l input_line
            echo $input_line
        end
    
    case "*"
        # Default case - show usage
        echo "Usage: ./scripts/fish/io_handler.fish <operation> [args...]"
        echo
        echo "Operations:"
        echo "  print <message>  - Print a message to stdout"
        echo "  read             - Read input from stdin"
        echo "  readp <prompt>   - Read input with a prompt"
        exit 1
end
