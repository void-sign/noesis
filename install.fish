#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# install.fish - Installation script for Noesis

# Current version of Noesis
set -g NOESIS_VERSION "2.0.0"

# Define colors for better readability
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set PINK (set_color ff5fd7) # Bright pink
set NC (set_color normal)

echo "$BLUE┌────────────────────────────────────────────────┐$NC"
echo "$BLUE│$NC                                                $BLUE│$NC"
echo "$BLUE│$PINK       NOESIS v2.0.0 - SYSTEM INSTALLER       $BLUE│$NC"
echo "$BLUE│$NC                                                $BLUE│$NC"
echo "$BLUE└────────────────────────────────────────────────┘$NC"
echo

# Check if running with sudo/as root
if test (id -u) -ne 0
    echo "$RED""Error: This script needs to be run with sudo privileges."
    echo "Please run: sudo ./install.fish""$NC"
    exit 1
end

# Define installation paths
set INSTALL_DIR "/usr/local/lib/noesis"
set BIN_DIR "/usr/local/bin"
set EXECUTABLE "$BIN_DIR/noesis"

# Make sure the target directories exist
echo "$YELLOW""Creating installation directories...""$NC"
mkdir -p $INSTALL_DIR
mkdir -p $BIN_DIR

# Copy necessary files
echo "$YELLOW""Copying Noesis files...""$NC"
cp -r src $INSTALL_DIR/
cp run.fish $INSTALL_DIR/
cp LICENSE $INSTALL_DIR/
cp README.md $INSTALL_DIR/
cp -r docs $INSTALL_DIR/

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
