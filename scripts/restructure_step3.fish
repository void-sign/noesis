#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 3
# This script moves debug files
#

echo "Step 3: Moving debug files..."

# Move debug files with specific commands rather than wildcards
if test -d "debug"
    # Move specific files - test for existence first
    if test -f "debug/helper_test.c"
        cp debug/helper_test.c tests/debug/ 2>/dev/null
        echo "Moved debug/helper_test.c"
    end

    if test -f "debug/io_basic.s"
        cp debug/io_basic.s tests/debug/ 2>/dev/null
        echo "Moved debug/io_basic.s"
    end
    
    if test -f "debug/io_debug.s"
        cp debug/io_debug.s tests/debug/ 2>/dev/null
        echo "Moved debug/io_debug.s"
    end
    
    if test -f "debug/io_fixed.s"
        cp debug/io_fixed.s tests/debug/ 2>/dev/null
        echo "Moved debug/io_fixed.s"
    end
    
    if test -f "debug/io_incremental.s"
        cp debug/io_incremental.s tests/debug/ 2>/dev/null
        echo "Moved debug/io_incremental.s"
    end
    
    if test -f "debug/io_minimal.s"
        cp debug/io_minimal.s tests/debug/ 2>/dev/null
        echo "Moved debug/io_minimal.s"
    end
    
    if test -f "debug/io_with_c.s"
        cp debug/io_with_c.s tests/debug/ 2>/dev/null
        echo "Moved debug/io_with_c.s"
    end
    
    if test -f "debug/main_debug.c"
        cp debug/main_debug.c tests/debug/ 2>/dev/null
        echo "Moved debug/main_debug.c"
    end
    
    if test -f "debug/main_test.c"
        cp debug/main_test.c tests/debug/ 2>/dev/null
        echo "Moved debug/main_test.c"
    end
    
    if test -f "debug/Makefile.mixed"
        cp debug/Makefile.mixed tests/debug/ 2>/dev/null
        echo "Moved debug/Makefile.mixed"
    end
    
    if test -f "debug/Makefile.test"
        cp debug/Makefile.test tests/debug/ 2>/dev/null
        echo "Moved debug/Makefile.test"
    end
    
    if test -f "debug/minimal_test.c"
        cp debug/minimal_test.c tests/debug/ 2>/dev/null
        echo "Moved debug/minimal_test.c"
    end
    
    if test -f "debug/minimal_test.s"
        cp debug/minimal_test.s tests/debug/ 2>/dev/null
        echo "Moved debug/minimal_test.s"
    end
    
    if test -f "debug/mixed_test.c"
        cp debug/mixed_test.c tests/debug/ 2>/dev/null
        echo "Moved debug/mixed_test.c"
    end
    
    if test -f "debug/README.md"
        cp debug/README.md tests/debug/ 2>/dev/null
        echo "Moved debug/README.md"
    end
end

echo "Debug files moved successfully!"
echo "Now run restructure_step4.fish"
