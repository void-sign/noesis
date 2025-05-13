#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#



echo "Building Noesis Core..."
make clean
make

echo "Build complete."
echo
echo "Note: Noesis Extensions have been moved to a separate repository."
echo "To build extensions, please use the noesis-extend repository:"
echo "https://github.com/void-sign/noesis-extend"
