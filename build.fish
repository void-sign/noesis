#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# build-fish-only.fish - Build script for the Noesis fish-only implementation

# Define colors for better readability
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set PINK (set_color ff5fd7) # Bright pink
set NC (set_color normal)

echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo "$PINK  NOESIS v2.1.0 - BUILDER                  $NC"
echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo

echo "$YELLOW"Checking fish files..."$NC"
# Check if all required fish files exist based on the new directory structure
set required_files \
    "soul/intent.fish" \
    "system/memory/unit.fish" \
    "system/perception/unit.fish" \
    "system/emotion/unit.fish" \
    "system/memory/quantum/unit.fish" \
    "system/memory/quantum/compiler.fish" \
    "system/memory/quantum/backend_stub.fish" \
    "system/memory/quantum/backend_ibm.fish" \
    "system/memory/quantum/export_qasm.fish" \
    "system/memory/quantum/field/quantum_field.fish" \
    "system/memory/short.fish" \
    "system/memory/long.fish" \
    "system/perception/api.fish"

set all_files_exist true

for file in $required_files
    if not test -f "$file"
        echo "$RED"Missing file: $file"$NC"
        set all_files_exist false
    end
end

if test "$all_files_exist" = "false"
    echo "$RED"Error: Some required fish files are missing"$NC"
    exit 1
end

echo "$GREEN"All required fish files exist"$NC"

# Create necessary directories
echo "$YELLOW"Creating directory structure..."$NC"
mkdir -p build/fish-only

# Copy fish files to build directory
echo "$YELLOW"Copying fish files to build directory..."$NC"
for file in $required_files
    # Get the directory part of the file path
    set dir (dirname "build/fish-only/$file")
    
    # Create the directory if it doesn't exist
    mkdir -p "$dir"
    
    # Copy the file
    cp "$file" "build/fish-only/$file"
end

# Create a special runner file that points to the new main entry point
echo "$YELLOW"Creating main runner file..."$NC"
echo '#!/usr/bin/env fish
#
# Noesis central runner for the fish-only version
#
cd (dirname (status -f))
source soul/intent.fish
' > build/fish-only/fish-only-run.fish

# Make it executable
chmod +x build/fish-only/fish-only-run.fish

# Create a simple runner script
echo "$YELLOW"Creating runner script..."$NC"
echo '#!/usr/bin/env fish
#
# Noesis Fish-Only Runner
#

cd (dirname (status filename))
./fish-only-run.fish
' > build/fish-only/run.fish

# Make the runner script executable
chmod +x build/fish-only/run.fish
chmod +x build/fish-only/fish-only-run.fish

echo "$GREEN"Build complete"$NC"
echo "You can run the fish-only version with: $YELLOW"./build/fish-only/run.fish"$NC"
exit 0
