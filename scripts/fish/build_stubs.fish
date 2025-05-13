#!/usr/bin/env fish

# Build the nlibc stubs library
cd /Users/plugio/Documents/GitHub/noesis/src/utils
gcc -c -o noesis_libc_stubs.o noesis_libc_stubs.c
# Remove the existing library first
rm -f ../../build/lib/libnlibc_stubs.a
# Create a new library with only our implementation
ar rcs ../../build/lib/libnlibc_stubs.a noesis_libc_stubs.o
rm noesis_libc_stubs.o

echo "Stubs library built and installed successfully."
