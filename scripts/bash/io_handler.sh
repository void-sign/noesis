#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# io_handler.sh - Bash script for handling I/O operations for Noesis
# This script provides input/output operations for the Noesis C code

# Command argument determines the operation
operation="$1"

# Handle different operations
case "$operation" in
    "print")
        # Print a message to stdout
        # Usage: ./scripts/bash/io_handler.sh print "Message to print"
        if [ $# -ge 2 ]; then
            echo "${@:2}"
        fi
        ;;
    
    "read")
        # Read input from stdin and output it
        # Usage: ./scripts/bash/io_handler.sh read
        read input_line
        echo "$input_line"
        ;;
    
    "readp")
        # Read input with a prompt
        # Usage: ./scripts/bash/io_handler.sh readp "Prompt: "
        if [ $# -ge 2 ]; then
            read -p "$2 " input_line
            echo "$input_line"
        else
            read input_line
            echo "$input_line"
        fi
        ;;
    
    *)
        # Default case - show usage
        echo "Usage: ./scripts/bash/io_handler.sh <operation> [args...]"
        echo
        echo "Operations:"
        echo "  print <message>  - Print a message to stdout"
        echo "  read             - Read input from stdin"
        echo "  readp <prompt>   - Read input with a prompt"
        exit 1
        ;;
esac
