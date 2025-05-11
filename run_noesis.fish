#!/usr/bin/env fish

# Fish shell version of the run_noesis.sh script
# This provides a clean way to run Noesis in fish shell
# It completely filters out the unwanted characters at the beginning of output

# Make sure the program is built
if not test -f "./noesis"
  echo "Building Noesis..."
  make
end

# Run the program with improved filter to completely remove the unwanted characters
# stdbuf ensures output isn't buffered
# sed removes non-printable characters
# second sed replaces any remaining garbage at the beginning
stdbuf -o0 ./noesis | 
  sed 's/[^[:print:]]//g' | 
  sed '1s/^[^A-Za-z0-9 ]*NOESIS/NOESIS/'
