#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 2
# This script moves documentation files
#

echo "Step 2: Moving documentation files..."

# If docs files don't exist in root, don't try to move them
if test -f "CHECKLIST.md"
    cp CHECKLIST.md docs/
    echo "Moved CHECKLIST.md"
end

if test -f "CONTRIBUTING.md"
    cp CONTRIBUTING.md docs/
    echo "Moved CONTRIBUTING.md"
end

if test -f "SECURITY.md"
    cp SECURITY.md docs/
    echo "Moved SECURITY.md"
end

# Move changelogs with specific commands rather than wildcards
if test -d "changelogs"
    cp changelogs/CHANGELOG_v0.1.1.md docs/changelogs/ 2>/dev/null
    cp changelogs/CHANGELOG_v0.1.2.md docs/changelogs/ 2>/dev/null
    cp changelogs/CHANGELOG_v0.2.0.md docs/changelogs/ 2>/dev/null
    cp changelogs/CHANGELOG_v1.0.0.md docs/changelogs/ 2>/dev/null
    cp changelogs/CHANGELOG_v1.1.0.md docs/changelogs/ 2>/dev/null
    echo "Moved changelogs"
end

echo "Documentation files moved successfully!"
echo "Now run restructure_step3.fish"
