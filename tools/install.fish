#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# install.fish - Installation script for Noesis

# Current version of Noesis
set -g NOESIS_VERSION "2.2.2"

# Define colors for better readability
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set PINK (set_color ff5fd7) # Bright pink
set NC (set_color normal)

echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo "$PINK  NOESIS v$NOESIS_VERSION - SYSTEM INSTALLER     $NC"
echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo

# Check if running with sudo/as root
if test (id -u) -ne 0
    echo "$RED""Error: This script needs to be run with sudo privileges."
    echo "Please run: sudo ./install.fish""$NC"
    exit 1
end

# Verify all required files exist before installation
echo "$YELLOW"Checking required files..."$NC"
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
    echo "$RED"Error: Some required files are missing"$NC"
    exit 1
end

echo "$GREEN"All required files exist"$NC"

# Define installation paths
set INSTALL_DIR "/usr/local/lib/noesis"
set BIN_DIR "/usr/local/bin"
set EXECUTABLE "$BIN_DIR/noesis"

# Make sure the target directories exist
echo "$YELLOW""Creating installation directories...""$NC"
mkdir -p $INSTALL_DIR
mkdir -p $BIN_DIR

# Copy necessary files to installation directory
echo "$YELLOW""Copying Noesis files...""$NC"

# Copy core files
cp LICENSE $INSTALL_DIR/
cp README.md $INSTALL_DIR/
cp run.fish $INSTALL_DIR/
cp -r docs $INSTALL_DIR/

# Copy all required module files with proper directory structure
for file in $required_files
    # Get the directory part of the file path
    set dir (dirname "$INSTALL_DIR/$file")
    
    # Create the directory if it doesn't exist
    mkdir -p "$dir"
    
    # Copy the file
    cp "$file" "$INSTALL_DIR/$file"
end

# Create the noesis executable script
echo "$YELLOW""Creating executable...""$NC"
echo '#!/usr/bin/env fish
#
# Noesis CLI Runner
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# Define the directory where Noesis is installed
set NOESIS_DIR "/usr/local/lib/noesis"

# Change to the Noesis directory
cd $NOESIS_DIR

# Execute Noesis with all passed arguments
exec ./run.fish $argv

' > $EXECUTABLE

# Make the executable script runnable
chmod +x $EXECUTABLE

echo "$GREEN""Installation complete!""$NC"
echo "You can now run Noesis from anywhere using the ""$YELLOW""noesis""$NC"" command."
echo "Try ""$YELLOW""noesis -v""$NC"" to verify the installation."
echo
