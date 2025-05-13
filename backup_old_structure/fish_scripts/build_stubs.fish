#!/usr/bin/env fish

# Build the nlibc stubs library
cd /Users/plugio/Documents/GitHub/noesis/source/utils/asm
make -f Makefile.stubs
make -f Makefile.stubs install

echo "Stubs library built and installed successfully."
