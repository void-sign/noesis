#!/usr/bin/env fish

# This is the main fish controller script for Noesis
# It detects the script to run and executes it from the fish_scripts directory

# Script name will be the first argument
set SCRIPT_NAME $argv[1]

# Shift arguments
set -e argv[1]

# Check if script name is provided
if test -z "$SCRIPT_NAME"
    echo "Usage: ./noesis.fish <script_name> [args...]"
    echo "Available scripts:"
    ls -1 fish_scripts/ | grep '\.fish$' | sed 's/\.fish$//'
    exit 1
end

# Check if the script exists
if test -f "fish_scripts/$SCRIPT_NAME.fish"
    # Execute the script with all remaining arguments
    fish "fish_scripts/$SCRIPT_NAME.fish" $argv
else
    echo "Error: Script '$SCRIPT_NAME' not found in fish_scripts directory"
    echo "Available scripts:"
    ls -1 fish_scripts/ | grep '\.fish$' | sed 's/\.fish$//'
    exit 1
end
