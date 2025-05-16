#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# Script to install AI dependencies for Noesis system
# Handles different platforms, particularly macOS issues with PyTorch

set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set NC (set_color normal)

function log_message
    set -l message $argv[1]
    set -l level $argv[2]
    
    switch $level
        case "INFO"
            echo "$BLUE$message$NC"
        case "SUCCESS"
            echo "$GREEN$message$NC"
        case "WARNING"
            echo "$YELLOW$message$NC"
        case "ERROR"
            echo "$RED$message$NC"
        case "*"
            echo $message
    end
end

function install_ai_dependencies
    log_message "Starting AI dependency installation..." "INFO"
    
    # Check if Python is installed
    if not command -sq python3
        log_message "Error: Python 3 is required but not installed" "ERROR"
        log_message "Please install Python 3 and try again" "INFO"
        return 1
    end
    
    # Get Python version
    set py_version (python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    log_message "Found Python version $py_version" "INFO"
    
    # Check if Python version is too new (PyTorch often lags behind newest Python versions)
    set py_major (python3 -c "import sys; print(sys.version_info.major)")
    set py_minor (python3 -c "import sys; print(sys.version_info.minor)")
    
    if test $py_major -eq 3 -a $py_minor -gt 10
        log_message "Warning: Python $py_version detected - PyTorch may not have pre-built binaries for this version" "WARNING"
        log_message "Recommended options:" "INFO"
        log_message "1. Install Python 3.9 or 3.10 (recommended for PyTorch compatibility)" "INFO"
        log_message "2. Use conda to create an environment with a compatible Python version:" "INFO"
        log_message "   brew install miniforge" "INFO"
        log_message "   conda create -n noesis python=3.9" "INFO" 
        log_message "   conda activate noesis" "INFO"
        log_message "   conda install pytorch torchvision torchaudio -c pytorch" "INFO"
        log_message "   conda install pip && pip install transformers accelerate huggingface_hub" "INFO"
        log_message "Would you like to continue anyway? (y/N)" "INFO"
        read -l continue_anyway
        
        if test "$continue_anyway" != "y" -a "$continue_anyway" != "Y"
            log_message "Installation aborted. Please use one of the recommended options." "ERROR"
            return 1
        end
    end
    
    # Check if pip is installed
    if not python3 -m pip --version &>/dev/null
        log_message "Error: pip is required but not installed" "ERROR"
        log_message "Please install pip and try again" "INFO"
        return 1
    end
    
    # Get OS type and architecture
    set os_type (uname)
    set arch (uname -m)
    log_message "Detected OS: $os_type, Architecture: $arch" "INFO"
    
    # Install non-PyTorch dependencies first
    log_message "Installing Hugging Face libraries..." "INFO"
    python3 -m pip install --upgrade pip
    python3 -m pip install transformers accelerate huggingface_hub
    
    if test $status -ne 0
        log_message "Warning: Issues installing Hugging Face dependencies" "WARNING"
    end
    
    # Different installation approach based on OS
    if test "$os_type" = "Darwin" # macOS
        log_message "Installing PyTorch for macOS ($arch)..." "INFO"
        
        if test "$arch" = "arm64"
            log_message "Using Apple Silicon (M1/M2/M3) specific installation" "INFO"
            
            # Try multiple approaches
            log_message "Attempt 1: Using PyTorch official URL for CPU" "INFO"
            python3 -m pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
            
            if not python3 -c "import torch; print(torch.__version__)" &>/dev/null
                log_message "Attempt 2: Using PyTorch 2.0.0 (compatible with most M1/M2/M3 setups)" "INFO"
                python3 -m pip install --no-cache-dir torch==2.0.0 torchvision==0.15.0 torchaudio==2.0.0
            end
            
            if not python3 -c "import torch; print(torch.__version__)" &>/dev/null
                log_message "Attempt 3: Using PyTorch 1.13.1 with CPU backend" "INFO"
                python3 -m pip install --no-cache-dir torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 --index-url https://download.pytorch.org/whl/cpu
            end
        else
            log_message "Using Intel Mac specific installation" "INFO"
            
            # Try multiple approaches
            log_message "Attempt 1: Using PyTorch official URL for CPU" "INFO"
            python3 -m pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
            
            if not python3 -c "import torch; print(torch.__version__)" &>/dev/null
                log_message "Attempt 2: Using PyTorch 1.13.1 with CPU backend" "INFO"
                python3 -m pip install --no-cache-dir torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 --index-url https://download.pytorch.org/whl/cpu
            end
        end
    else # Linux/Windows/Other
        log_message "Installing PyTorch for $os_type..." "INFO"
        python3 -m pip install torch torchvision torchaudio
    end
    
    # Check if PyTorch was successfully installed
    if python3 -c "import torch; print(f'PyTorch {torch.__version__} successfully installed')" &>/dev/null
        log_message "PyTorch installation successful!" "SUCCESS"
    else
        log_message "Failed to install PyTorch. Consider using conda instead:" "ERROR"
        log_message "  1. Install miniforge: brew install miniforge" "INFO"
        log_message "  2. Create environment: conda create -n noesis python=3.9" "INFO"
        log_message "  3. Activate: conda activate noesis" "INFO"
        log_message "  4. Install PyTorch: conda install pytorch torchvision torchaudio -c pytorch" "INFO"
        log_message "  5. Install HF: conda install pip && pip install transformers accelerate huggingface_hub" "INFO"
        
        # Create a conda setup script to help the user
        set conda_script_path ./setup-conda-ai.fish
        log_message "Creating conda setup script at $conda_script_path" "INFO"
        
        echo '#!/usr/bin/env fish
# Setup script for Noesis AI dependencies using conda
# Run this script after installing miniforge/miniconda/anaconda

if not command -sq conda
    echo "Conda not found! Please install miniforge first:"
    echo "brew install miniforge"
    exit 1
end

# Create the environment
echo "Creating conda environment for Noesis..."
conda create -y -n noesis python=3.9

# Instructions for activating
echo
echo "======================= IMPORTANT ======================="
echo "To activate the environment, run:"
echo "conda activate noesis"
echo
echo "After activating, run this to install dependencies:"
echo "conda install -y pytorch torchvision torchaudio -c pytorch"
echo "conda install -y pip && pip install transformers accelerate huggingface_hub"
echo
echo "Then restart Noesis to use the AI features"
echo "========================================================"

# Ask if user wants to activate now
read -P "Activate the environment now? (y/N) " activate

if test "$activate" = "y" -o "$activate" = "Y"
    # Need to do this in a subshell since conda activate normally requires source
    echo "Running:"
    echo "conda activate noesis && conda install -y pytorch torchvision torchaudio -c pytorch && pip install transformers accelerate huggingface_hub"
    
    conda activate noesis
    if test $status -eq 0
        conda install -y pytorch torchvision torchaudio -c pytorch
        pip install transformers accelerate huggingface_hub
        echo
        echo "Installation complete! Restart Noesis to use AI features."
    else
        echo "Error activating conda environment."
        echo "Please run the commands manually as shown above."
    end
end' > $conda_script_path
        
        chmod +x $conda_script_path
        log_message "Run $conda_script_path to set up conda environment" "INFO"
        return 1
    end
    
    # Verify all dependencies
    log_message "Verifying all dependencies:" "INFO"
    
    set all_installed true
    
    if python3 -c "import transformers; print(f'Transformers {transformers.__version__} installed')" &>/dev/null
        log_message "✓ Transformers installed" "SUCCESS"
    else
        log_message "✗ Transformers NOT installed" "ERROR"
        set all_installed false
    end
    
    if python3 -c "import torch; print(f'PyTorch {torch.__version__} installed')" &>/dev/null
        log_message "✓ PyTorch installed" "SUCCESS"
    else
        log_message "✗ PyTorch NOT installed" "ERROR" 
        set all_installed false
    end
    
    if python3 -c "import accelerate; print(f'Accelerate {accelerate.__version__} installed')" &>/dev/null
        log_message "✓ Accelerate installed" "SUCCESS"
    else
        log_message "✓ Accelerate is optional, not installed" "WARNING"
    end
    
    if python3 -c "import huggingface_hub; print(f'Hugging Face Hub {huggingface_hub.__version__} installed')" &>/dev/null
        log_message "✓ Hugging Face Hub installed" "SUCCESS"
    else
        log_message "✗ Hugging Face Hub NOT installed" "ERROR"
        set all_installed false
    end
    
    if $all_installed
        log_message "All required dependencies successfully installed!" "SUCCESS"
        return 0
    else
        log_message "Some dependencies failed to install. See above for details." "ERROR"
        return 1
    end
end

# Run the installation function
install_ai_dependencies
