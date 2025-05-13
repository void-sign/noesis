#!/usr/bin/env fish

# Clean build and run script for Noesis project
# Adds the NOESIS_USE_SHORT_NAMES flag to use short function names

# Clean first
make clean

# Build with short names enabled and standard names
make CFLAGS="-Wall -Wextra -std=c99 -DNOESIS_USE_SHORT_NAMES -DNOESIS_LIBC_USE_STD_NAMES -Iinclude -I. -I/Users/plugio/Documents/GitHub/noesis -I/Users/plugio/Documents/GitHub/noesis/noesis_libc/include"

# Run the executable if build was successful
if test $status -eq 0
    echo "Build successful, running Noesis..."
    ./noesis
else
    echo "Build failed. Please check the errors above."
end
