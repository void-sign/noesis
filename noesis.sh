#!/bin/bash

# This is the main shell controller script for Noesis
# It detects the script to run and executes it from the bash_scripts directory

# Script name will be the first argument, or if none provided, show usage
SCRIPT_NAME=$1
shift 1 2>/dev/null || true

# Check if script name is provided
if [ -z "$SCRIPT_NAME" ]; then
    echo "Usage: ./noesis.sh <script_name> [args...]"
    echo "Available scripts:"
    ls -1 bash_scripts/ | grep '\.sh$' | sed 's/\.sh$//'
    exit 1
fi

# Check if the script exists
if [ -f "bash_scripts/${SCRIPT_NAME}.sh" ]; then
    # Execute the script with all remaining arguments
    bash "bash_scripts/${SCRIPT_NAME}.sh" "$@"
else
    echo "Error: Script '${SCRIPT_NAME}' not found in bash_scripts directory"
    echo "Available scripts:"
    ls -1 bash_scripts/ | grep '\.sh$' | sed 's/\.sh$//'
    exit 1
fi
