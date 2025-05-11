#!/bin/fish

echo "Running Noesis Core Tests..."
cd noesis-core
make test
cd ..

echo -e "\nRunning Noesis Extensions Tests..."
cd noesis-extensions
make test
cd ..

echo -e "\nAll tests completed."
