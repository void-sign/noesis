#!/bin/bash

# This script provides a clean way to run Noesis
# It filters out the unwanted characters at the beginning of output

# Make sure the program is built
if [ ! -f "./noesis" ]; then
  echo "Building Noesis..."
  make
fi

# Run the program with special handling for the first line
# This uses sed to filter out any garbage characters at the start of output
./noesis | sed '1s/^.*NOESIS/NOESIS/'
