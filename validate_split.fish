#!/bin/fish

# validate_split.fish - Validate the repository split
# This script checks that both repositories are properly set up

echo "Noesis Repository Split Validation"
echo "================================="
echo

set NOESIS_PATH "/Users/plugio/Documents/GitHub/noesis"
set NOESIS_EXTEND_PATH "/Users/plugio/Documents/GitHub/noesis-extend"

# Check if directories exist
if not test -d $NOESIS_PATH
    echo "Error: Noesis Core directory not found at $NOESIS_PATH"
    exit 1
end

if not test -d $NOESIS_EXTEND_PATH
    echo "Error: Noesis-Extend directory not found at $NOESIS_EXTEND_PATH"
    exit 1
end

echo "✓ Both repositories found"

# Check for critical files in Noesis Core
set CORE_CRITICAL_FILES \
    "$NOESIS_PATH/LICENSE" \
    "$NOESIS_PATH/Makefile" \
    "$NOESIS_PATH/include/core/emotion.h" \
    "$NOESIS_PATH/source/core/emotion.c"

echo "Checking for critical files in Noesis Core..."
for file in $CORE_CRITICAL_FILES
    if not test -f $file
        echo "✗ Missing file: $file"
        set ERROR true
    end
end

if not set -q ERROR
    echo "✓ All critical Core files found"
end

# Check for critical files in Noesis-Extend
set EXTEND_CRITICAL_FILES \
    "$NOESIS_EXTEND_PATH/LICENSE" \
    "$NOESIS_EXTEND_PATH/Makefile" \
    "$NOESIS_EXTEND_PATH/include/quantum/quantum.h" \
    "$NOESIS_EXTEND_PATH/source/quantum/quantum.c" \
    "$NOESIS_EXTEND_PATH/scripts/install_dependency.fish"

echo "Checking for critical files in Noesis-Extend..."
for file in $EXTEND_CRITICAL_FILES
    if not test -f $file
        echo "✗ Missing file: $file"
        set ERROR true
    end
end

if not set -q ERROR
    echo "✓ All critical Extend files found"
end

# Check for lingering quantum files in Core
echo "Checking for quantum files in Core..."
set QUANTUM_FILES (find $NOESIS_PATH/source -name "quantum*.c" -o -name "quantum*.h" 2>/dev/null)
if test (count $QUANTUM_FILES) -gt 0
    echo "✗ Found quantum files in Core repository:"
    for file in $QUANTUM_FILES
        echo "  - $file"
    end
    set ERROR true
else
    echo "✓ No quantum files found in Core"
end

# Check for core-only files in Extend
echo "Checking for core files in Extend..."
set CORE_FILES (find $NOESIS_EXTEND_PATH/source -name "emotion*.c" -o -name "logic*.c" -o -name "perception*.c" 2>/dev/null)
if test (count $CORE_FILES) -gt 0
    echo "✗ Found core files in Extend repository:"
    for file in $CORE_FILES
        echo "  - $file"
    end
    set ERROR true
else
    echo "✓ No core files found in Extend"
end

# Check for "yourusername" in files
echo "Checking for 'yourusername' in Core..."
set USERNAME_REFS (grep -r "yourusername" --include="*.md" --include="*.fish" --include="*.yml" $NOESIS_PATH 2>/dev/null)
if test (count $USERNAME_REFS) -gt 0
    echo "✗ Found 'yourusername' references in Core:"
    echo "$USERNAME_REFS"
    set ERROR true
else
    echo "✓ No 'yourusername' references found in Core"
end

echo "Checking for 'yourusername' in Extend..."
set USERNAME_REFS (grep -r "yourusername" --include="*.md" --include="*.fish" --include="*.yml" $NOESIS_EXTEND_PATH 2>/dev/null)
if test (count $USERNAME_REFS) -gt 0
    echo "✗ Found 'yourusername' references in Extend:"
    echo "$USERNAME_REFS"
    set ERROR true
else
    echo "✓ No 'yourusername' references found in Extend"
end

echo
if set -q ERROR
    echo "⚠️ Validation completed with errors"
    echo "Please fix the issues listed above before proceeding."
    exit 1
else
    echo "🎉 Validation successful! All checks passed."
    echo "You can now proceed with the repository setup."
    echo "See CHECKLIST.md for next steps."
end
