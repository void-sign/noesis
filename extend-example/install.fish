#!/usr/bin/env fish
# Installation script for noesis-extend without direct dependency

# Function to check if a command exists
function command_exists
    command -v $argv[1] >/dev/null 2>&1
end

# Create directories
mkdir -p lib include bin

# Check if pkg-config is available
if command_exists pkg-config
    # Check if noesis is installed via pkg-config
    if pkg-config --exists noesis
        echo "Found Noesis via pkg-config"
        set CFLAGS (pkg-config --cflags noesis)
        set LDFLAGS (pkg-config --libs noesis)
    else
        echo "Noesis not found via pkg-config."
        echo "Looking for local installation..."
    end
end

# Check for local installation if pkg-config didn't work
if test -z "$CFLAGS" -o -z "$LDFLAGS"
    # Try to find noesis in common locations
    for dir in /usr/local /usr $HOME/.local $HOME/noesis ../noesis
        if test -f "$dir/lib/libnoesis.so" -o -f "$dir/lib/libnoesis.a"
            echo "Found Noesis in $dir"
            set CFLAGS "-I$dir/lib/include"
            set LDFLAGS "-L$dir/lib -lnoesis"
            break
        end
    end
end

# If Noesis is still not found, ask for path
if test -z "$CFLAGS" -o -z "$LDFLAGS"
    echo "Noesis library not found."
    echo "Please provide the path to your Noesis installation:"
    read -l NOESIS_PATH
    
    if test -f "$NOESIS_PATH/lib/libnoesis.so" -o -f "$NOESIS_PATH/lib/libnoesis.a"
        set CFLAGS "-I$NOESIS_PATH/lib/include"
        set LDFLAGS "-L$NOESIS_PATH/lib -lnoesis"
    else
        echo "Error: Noesis library not found in $NOESIS_PATH"
        echo "Please build and install Noesis first."
        exit 1
    end
end

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
