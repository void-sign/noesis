#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# This script saves the completion of the restructuring process

set TIMESTAMP (date +%Y%m%d%H%M%S)
set ROOT_DIR (dirname (dirname (status -f)))
cd $ROOT_DIR

# Create a tag to mark the completion of restructuring
git tag -a "restructure-complete-$TIMESTAMP" -m "Completed restructuring on $(date)"

echo "Created git tag: restructure-complete-$TIMESTAMP"
echo "Restructuring process is now complete."
echo
echo "Current directory structure is fully reorganized according to the plan in docs/RESTRUCTURE_PLAN.md"
echo
echo "To continue working with the restructured project, use the standard make commands:"
echo "make clean      # Clean build artifacts"
echo "make           # Build the project"
echo "make test       # Run tests"
echo "./noesis        # Run the program"
