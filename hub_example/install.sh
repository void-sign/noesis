#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#


# Installation script for noesis-extend without direct dependency

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create directories
mkdir -p lib include bin

# Check if pkg-config is available
if command_exists pkg-config; then
    # Check if noesis is installed via pkg-config
    if pkg-config --exists noesis; then
        echo "Found Noesis via pkg-config"
        CFLAGS="$(pkg-config --cflags noesis)"
        LDFLAGS="$(pkg-config --libs noesis)"
    else
        echo "Noesis not found via pkg-config."
        echo "Looking for local installation..."
    fi
fi

# Check for local installation if pkg-config didn't work
if [ -z "$CFLAGS" ] || [ -z "$LDFLAGS" ]; then
    # Try to find noesis in common locations
    for dir in /usr/local /usr $HOME/.local $HOME/noesis ../noesis; do
        if [ -f "$dir/lib/libnoesis.so" ] || [ -f "$dir/lib/libnoesis.a" ]; then
            echo "Found Noesis in $dir"
            CFLAGS="-I$dir/lib/include"
            LDFLAGS="-L$dir/lib -lnoesis"
            break
        fi
    done
fi

# If Noesis is still not found, ask for path
if [ -z "$CFLAGS" ] || [ -z "$LDFLAGS" ]; then
    echo "Noesis library not found."
    echo "Please provide the path to your Noesis installation:"
    read -r NOESIS_PATH
    
    if [ -f "$NOESIS_PATH/lib/libnoesis.so" ] || [ -f "$NOESIS_PATH/lib/libnoesis.a" ]; then
        CFLAGS="-I$NOESIS_PATH/lib/include"
        LDFLAGS="-L$NOESIS_PATH/lib -lnoesis"
    else
        echo "Error: Noesis library not found in $NOESIS_PATH"
        echo "Please build and install Noesis first."
        exit 1
    fi
fi

# Save the configuration
echo "CFLAGS=$CFLAGS" > config.mk
echo "LDFLAGS=$LDFLAGS" >> config.mk

echo "Building noesis-extend..."
make clean
make

echo "Installation complete."
echo "You can run the examples with: make run"
echo
echo "Note: This version of noesis-extend uses the standard Noesis API"
echo "and does not directly depend on the internal structure of Noesis."
