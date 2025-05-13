#!/bin/bash

LIBPATH="/Users/plugio/Documents/GitHub/noesis/noesis_libc"
LIBNAME="libnoesis_libc.a" # or .so/.dylib depending on your system

echo "Checking for noesis_libc library..."

if [ -f "$LIBPATH/$LIBNAME" ]; then
    echo "Found library at $LIBPATH/$LIBNAME"
    ls -l "$LIBPATH/$LIBNAME"
    
    # Check symbols in the library
    echo "Library symbols:"
    nm "$LIBPATH/$LIBNAME" | grep -E 'nlibc_(malloc|free|printf|fprintf|fopen|fclose|stderr|strcmp|strlen)'
else
    echo "ERROR: Library not found at $LIBPATH/$LIBNAME"
    echo "Please build the noesis_libc library first or verify its location."
    
    # Check if directory exists
    if [ -d "$LIBPATH" ]; then
        echo "Directory $LIBPATH exists. Contents:"
        ls -la "$LIBPATH"
    else
        echo "Directory $LIBPATH does not exist!"
    fi
fi
