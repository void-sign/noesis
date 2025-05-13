#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 4
# This script moves test files
#

echo "Step 4: Moving test files..."

# Move test files one by one
if test -d "tests"
    # Copy specific files
    if test -f "tests/core_tests.c"
        cp tests/core_tests.c tests/unit/ 2>/dev/null
        echo "Moved tests/core_tests.c"
    end
    
    if test -f "tests/main_tests.c"
        cp tests/main_tests.c tests/unit/ 2>/dev/null
        echo "Moved tests/main_tests.c"
    end
    
    if test -f "tests/noesis_lib_tests.c"
        cp tests/noesis_lib_tests.c tests/unit/ 2>/dev/null
        echo "Moved tests/noesis_lib_tests.c"
    end
    
    if test -f "tests/qlogic_tests.c"
        cp tests/qlogic_tests.c tests/unit/ 2>/dev/null
        echo "Moved tests/qlogic_tests.c"
    end
    
    if test -f "tests/utils_tests.c"
        cp tests/utils_tests.c tests/unit/ 2>/dev/null
        echo "Moved tests/utils_tests.c"
    end
end

echo "Test files moved successfully!"
echo "Now run restructure_step5.fish"
