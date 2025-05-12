#!/bin/fish

echo "Noesis Migration Tool"
echo "===================="
echo "This script helps migrate from the original Noesis structure to the new split repositories."
echo

# Check if there are any uncommitted changes
echo "Checking for uncommitted changes..."
git diff --quiet HEAD
if test $status -ne 0
    echo "Error: You have uncommitted changes. Please commit or stash them before migrating."
    exit 1
end

echo "Creating backup..."
timestamp=(date +%Y%m%d_%H%M%S)
mkdir -p backup_$timestamp
cp -r * backup_$timestamp/ 2>/dev/null
echo "✓ Backup created in backup_$timestamp/"

echo "Installing the new structure..."
./install.fish

echo "Updating configuration files..."
cp .gitignore.new .gitignore
cp README.md.new README.md
rm -f README.md.new .gitignore.new
echo "✓ Configuration files updated"

echo
echo "Migration Complete!"
echo "=================="
echo "Your project has been migrated to the new structure with separate core and extensions repositories."
echo "The original files are still available but the new structure is recommended going forward."
echo
echo "To run the applications:"
echo "  ./run_core.fish       - Run the core application"
echo "  ./run_extensions.fish - Run the extensions"
echo
echo "For development:"
echo "  - Core:       cd noesis-core"
echo "  - Extensions: cd noesis-extensions"
echo
echo "Thank you for using Noesis!"
