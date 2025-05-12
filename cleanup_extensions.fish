#!/bin/fish

# This script removes extension-related content from the main repository
# after it has been successfully moved to noesis-extend

echo "Cleaning up extension-related content from the main repository..."
echo "================================================================"

# Ensure noesis-extend repository exists and has the content
if not test -d "/Users/plugio/Documents/GitHub/noesis-extend"
    echo "Error: noesis-extend repository not found!"
    echo "Please make sure the noesis-extend repository exists before running this script."
    exit 1
end

# Check if critical files exist in noesis-extend
set required_files \
    "/Users/plugio/Documents/GitHub/noesis-extend/source/quantum/quantum.c" \
    "/Users/plugio/Documents/GitHub/noesis-extend/source/tools/qrun.c" \
    "/Users/plugio/Documents/GitHub/noesis-extend/include/quantum/quantum.h"

for file in $required_files
    if not test -f $file
        echo "Error: Required file $file not found in noesis-extend repository!"
        echo "Please ensure all files have been properly moved before cleaning up."
        exit 1
    end
end

echo "Backup of critical files before removal..."
mkdir -p backup_extensions
cp -r source/quantum backup_extensions/
cp -r source/tools backup_extensions/
cp -r include/quantum backup_extensions/
cp -r noesis-extensions backup_extensions/

echo "Removing extension-related directories and files..."

# Remove quantum and tools directories from source
rm -rf source/quantum
rm -rf source/tools

# Remove quantum directory from include
rm -rf include/quantum

# Remove old noesis-extensions directory
rm -rf noesis-extensions

# Remove extension-related scripts
mv run_extensions.fish backup_extensions/

echo
echo "Cleanup complete!"
echo "Extensions content has been moved to the noesis-extend repository."
echo "A backup of the removed files has been created in the 'backup_extensions' directory."
echo
echo "You should now update your build scripts to remove references to extensions."
