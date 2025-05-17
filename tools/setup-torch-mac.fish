#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# Script to install AI dependencies for Noesis system on macOS

set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set NC (set_color normal)

echo "$BLUE"Installing PyTorch dependencies for macOS..."$NC"

# Check if we're in a conda environment
if set -q CONDA_PREFIX
    echo "$GREEN"Active conda environment detected: $CONDA_PREFIX"$NC"
else
    echo "$YELLOW"No conda environment detected. Using system Python."$NC"
    echo "For best results, we recommend using conda:"
    echo "  1. Install with: brew install miniconda"
    echo "  2. Create env: conda create -n noesis python=3.9"
    echo "  3. Activate: conda activate noesis"
    echo
    echo "Continue with system Python? (y/N)"
    read -l continue
    
    if test "$continue" != "y" -a "$continue" != "Y"
        echo "$RED"Aborted. Please install conda and try again."$NC"
        exit 1
    end
end

# Run the Python installation script
python3 tools/setup-torch-mac.py

if test $status -eq 0
    echo "$GREEN"PyTorch installation successful!"$NC"
    echo "You can now use AI features in Noesis."
else
    echo "$RED"PyTorch installation failed."$NC"
    echo "Please try the manual installation process:"
    echo
    echo "With conda (recommended):"
    echo "  conda install -y pytorch torchvision torchaudio -c pytorch"
    echo "  conda install -y pip"
    echo "  pip install transformers accelerate huggingface_hub"
    echo
    echo "With pip (may not work with all Python versions):"
    echo "  pip install torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1"
    echo "  pip install transformers accelerate huggingface_hub"
    exit 1
end
