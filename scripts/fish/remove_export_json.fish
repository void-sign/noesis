#!/bin/fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

echo "Removing export_json functionality from the repository..."

# Remove the source file if it exists
if test -f "src/quantum/export_json.c"
    rm src/quantum/export_json.c
    echo "✓ Removed src/quantum/export_json.c"
else
    echo "! File src/quantum/export_json.c not found (already removed)"
end

# Remove any compiled object files
rm -f build/obj/quantum/export_json.o 2>/dev/null
echo "✓ Cleaned up any object files"

# Clean the build to ensure clean rebuilds
make clean
echo "✓ Cleaned the build"

echo "Done! The export_json functionality has been removed."
echo "Please rebuild the project with 'make' to ensure everything compiles correctly."
