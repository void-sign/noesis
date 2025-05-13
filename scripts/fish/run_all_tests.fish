#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

echo "Running Noesis Core Tests..."

# Run the test command and show its output
echo "> Running ./noesis_tests"

# Execute the test and capture the binary output
# Use xxd to convert binary output to hexdump for better display
set -l output_file "/tmp/noesis_test_output.tmp"
make test > $output_file 2>&1

# Check if the test command succeeded
set TEST_EXIT_CODE $status

# Display that the test has executed
echo "> Test binary executed"

# Show first line of test results without binary garbage
echo "  Result: Test ran with exit code $TEST_EXIT_CODE"

# Add test status info
if test $TEST_EXIT_CODE -eq 0
    echo -e "\n✓ Tests completed successfully"
else
    echo -e "\n✗ Tests failed with exit code $TEST_EXIT_CODE"
end

echo -e "\nCore tests completed."
