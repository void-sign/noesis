#!/usr/bin/env fish

echo "Running Noesis Core Tests..."
make test

echo -e "\nCore tests completed."
echo
echo "Note: Noesis Extensions have been moved to a separate repository."
echo "To run extension tests, please use the noesis-extend repository:"
echo "https://github.com/void-sign/noesis-extend"
