#!/usr/bin/env fish

# Script to save the current structure state of the Noesis project
# Created: May 13, 2025
# This script creates a Git tag with the current restructured state

set TIMESTAMP (date +%Y%m%d%H%M%S)
set TAG_NAME "restructure-state-$TIMESTAMP"

# Define the root directory
set ROOT_DIR (dirname (dirname (status -f)))
cd $ROOT_DIR

# Save the current directory structure
find . -type d -not -path "*/\\.*" -not -path "*/backup_old_structure*" | sort > "docs/directory_structure_$TIMESTAMP.txt"
echo "Directory structure saved to docs/directory_structure_$TIMESTAMP.txt"

# Save the current Makefile state
cp Makefile "docs/Makefile_$TIMESTAMP"
echo "Makefile saved to docs/Makefile_$TIMESTAMP"

# Save the ncom command files
if test -f ncom
    cp ncom "docs/ncom_$TIMESTAMP"
    echo "ncom saved to docs/ncom_$TIMESTAMP"
end

if test -f ncom.sh
    cp ncom.sh "docs/ncom.sh_$TIMESTAMP"
    echo "ncom.sh saved to docs/ncom.sh_$TIMESTAMP"
end

# Save the current .vscode/tasks.json state
if test -f .vscode/tasks.json
    cp .vscode/tasks.json "docs/tasks.json_$TIMESTAMP"
    echo "tasks.json saved to docs/tasks.json_$TIMESTAMP"
end

# Save the current .gitignore state
if test -f .gitignore
    cp .gitignore "docs/gitignore_$TIMESTAMP"
    echo "gitignore saved to docs/gitignore_$TIMESTAMP"
end

# Create a Git tag if we're in a Git repository
if test -d .git
    git add .
    git commit -m "Restructuring checkpoint: Project structure reorganized"
    git tag -a $TAG_NAME -m "Project structure state at $TIMESTAMP"
    echo "Git tag '$TAG_NAME' created. Use 'git checkout $TAG_NAME' to return to this state."
else
    echo "Not a Git repository. Skipping Git operations."
end

echo "Structure state saved. You can restore this state by:"
echo "1. Using the Git tag (if created): git checkout $TAG_NAME"
echo "2. Using the saved files in the docs directory as reference"
