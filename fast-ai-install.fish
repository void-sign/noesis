#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# fast-ai-install.fish - Quick AI dependency installation for Noesis
# This script uses pre-compiled wheels for faster installation

set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set CYAN (set_color cyan)
set NC (set_color normal)

echo "$CYAN"
echo "╔════════════════════════════════════════════════════╗"
echo "║       NOESIS FAST AI DEPENDENCIES INSTALLER        ║"
echo "╚════════════════════════════════════════════════════╝"
echo "$NC"

# Get system info
set os_type (uname)
set arch (uname -m)
set py_version (python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null)

echo "$BLUE""System: $os_type ($arch), Python: $py_version""$NC"
echo

# Check Python version compatibility
set py_major (python3 -c "import sys; print(sys.version_info.major)" 2>/dev/null)
set py_minor (python3 -c "import sys; print(sys.version_info.minor)" 2>/dev/null)

if test "$py_major" = "3" -a "$py_minor" -gt "10"
    echo "$YELLOW""Warning: Python $py_version detected. PyTorch may not have pre-built binaries for this version.""$NC"
    echo "For best compatibility, consider using Python 3.9 or 3.10."
    
    if test "$py_minor" -gt "12"
        echo "$RED""Your Python version $py_version is very new and likely incompatible with current PyTorch releases.""$NC"
        echo "Would you like to continue anyway? This might not work. (y/N)"
        read -l continue_anyway
        
        if test "$continue_anyway" != "y" -a "$continue_anyway" != "Y"
            echo "$RED""Installation aborted.""$NC"
            echo "Please install Python 3.9 or 3.10 for best compatibility."
            exit 1
        end
    end
end

# Check if we're in a conda environment
if set -q CONDA_PREFIX
    echo "$GREEN"Active conda environment: $CONDA_PREFIX"$NC"
    set using_conda true
else
    set using_conda false
    echo "$YELLOW"Using system Python"$NC"
end

# Function to check if a package is already installed
function is_package_installed
    set package_name $argv[1]
    
    if python3 -c "import $package_name" 2>/dev/null
        echo "$GREEN"✓ $package_name already installed"$NC"
        return 0
    else
        return 1
    end
end

# Show progress spinner
function show_spinner
    set message $argv[1]
    set -l spin_chars "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"
    set -l i 0
    
    while true
        printf "\r$message %s" $spin_chars[$i]
        
        set i (math "$i + 1")
        if test $i -gt (count $spin_chars)
            set i 1
        end
        
        sleep 0.1
    end
end

# Fast installation using pre-compiled wheels when possible
function fast_install
    echo "$BLUE"Starting fast installation..."$NC"
    echo

    # Install pip if needed
    if $using_conda
        echo "Installing pip via conda..."
        conda install -y pip
    else
        # Upgrade pip
        echo "Upgrading pip..."
        python3 -m pip install --upgrade pip
    end

    # Install non-PyTorch dependencies first (these are usually fast)
    if not is_package_installed transformers
        echo "Installing Hugging Face transformers..."
        python3 -m pip install --upgrade transformers
    end

    if not is_package_installed huggingface_hub
        echo "Installing Hugging Face Hub..."
        python3 -m pip install --upgrade huggingface_hub
    end

    if not is_package_installed accelerate
        echo "Installing accelerate..."
        python3 -m pip install --upgrade accelerate
    end

    # Check if PyTorch is already installed
    if is_package_installed torch
        echo "PyTorch is already installed."
        return 0
    end

    # Install PyTorch based on environment
    if $using_conda
        echo "$YELLOW"Installing PyTorch via conda (fastest method)..."$NC"
        
        # First, make sure conda solver is properly configured
        # Set a shorter timeout for the solver to prevent hanging
        echo "Configuring conda solver..."
        conda config --set solver_timeout 180 --file ~/.condarc
        
        # Try with --no-deps first (much faster)
        echo "Trying fast install with --no-deps..."
        if conda install -y --no-deps pytorch -c pytorch
            echo "$GREEN"Basic PyTorch install successful, adding components..."$NC"
            conda install -y torchvision torchaudio -c pytorch
            return 0
        else
            echo "$YELLOW"Fast install failed, trying specific versions..."$NC"
            
            # Try with specific versions that are known to work together
            if test "$arch" = "arm64"
                echo "Installing for Apple Silicon..."
                # For Apple Silicon, use newer versions that support MPS
                conda install -y pytorch=2.0.0 torchvision=0.15.0 torchaudio=2.0.0 -c pytorch
            else
                echo "Installing for Intel Mac..."
                # For Intel, use versions known to have good CPU support
                conda install -y pytorch=1.13.1 torchvision=0.14.1 torchaudio=0.13.1 -c pytorch
            end
            
            # If that fails, try the regular install
            if test $status -ne 0
                echo "$YELLOW"Specific versions failed, trying regular install (may take longer)..."$NC"
                conda install -y pytorch torchvision torchaudio -c pytorch
            end
            
            return $status
        end
    else
        # For regular pip installation
        if test "$os_type" = "Darwin"
            echo "$YELLOW"Installing PyTorch for macOS ($arch)..."$NC"
            
            # For Apple Silicon
            if test "$arch" = "arm64" 
                echo "Using MPS acceleration for Apple Silicon..."
                # Try first with --no-deps (faster)
                if not python3 -m pip install --no-deps --no-cache-dir torch==2.1.0
                    # If that fails, try with dependencies
                    echo "Retrying with dependencies..."
                    python3 -m pip install --no-cache-dir torch==2.1.0
                end
                
                if not python3 -m pip install --no-deps --no-cache-dir torchvision==0.16.0
                    python3 -m pip install --no-cache-dir torchvision==0.16.0
                end
                
                if not python3 -m pip install --no-deps --no-cache-dir torchaudio==2.1.0
                    python3 -m pip install --no-cache-dir torchaudio==2.1.0
                end
            else
                # For Intel Macs
                echo "Using CPU-specific build for Intel Mac..."
                # First try specific version known to work with CPU builds
                if not python3 -m pip install --no-deps --no-cache-dir torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 --index-url https://download.pytorch.org/whl/cpu
                    # If that fails, try a more compatible version with dependencies
                    echo "Specific version failed, trying with dependencies..."
                    python3 -m pip install --no-cache-dir torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 --index-url https://download.pytorch.org/whl/cpu
                end
            end
        else
            # For Linux/Windows
            echo "Using standard PyTorch installation..."
            # Try first without dependencies for speed
            if not python3 -m pip install --no-deps torch torchvision torchaudio
                # If that fails, try with dependencies
                echo "Retrying with dependencies..."
                python3 -m pip install torch torchvision torchaudio
            end
        end
    end
    
    # Verify PyTorch installation
    if python3 -c "import torch; print(f'PyTorch {torch.__version__} installed successfully!')" 2>/dev/null
        return 0
    else
        return 1
    end
end

# Function to run a command with a timeout
function run_with_timeout
    set cmd $argv[1]
    set timeout $argv[2]
    
    # Create a background process for the command
    fish -c "$cmd" &
    
    # Get the PID - use $last_pid if available (newer fish versions)
    # or get it manually for older versions
    if set -q last_pid
        set cmd_pid $last_pid
    else
        # For older fish versions, get child process PID
        sleep 0.1  # Give process time to start
        set cmd_pid (jobs -p | tail -n 1)
    end
    
    # Monitor the command with a timeout
    set start_time (date +%s)
    while true
        # Check if the process is still running
        if not ps -p $cmd_pid > /dev/null
            # Process completed
            wait $cmd_pid
            return $status
        end
        
        # Check if we've exceeded the timeout
        set current_time (date +%s)
        set elapsed_time (math "$current_time - $start_time")
        
        if test $elapsed_time -ge $timeout
            echo "$RED""Command timed out after $timeout seconds.""$NC"
            kill $cmd_pid 2>/dev/null
            return 1
        end
        
        # Wait a bit before checking again
        sleep 1
    end
end

# Run the fast installation with a timeout for conda
if $using_conda
    echo "Running installation with 600 second timeout to prevent hanging..."
    run_with_timeout "fish -c 'cd (pwd) && ./fast-ai-install.fish --no-timeout'" 600
    
    if test $status -ne 0
        echo "$RED""Installation timed out or failed. Trying alternative method...""$NC"
        # Force exit conda environment and try with pip directly
        echo "Installing with pip instead..."
        
        # Install transformers and related packages
        python3 -m pip install transformers accelerate huggingface_hub
        
        # Install PyTorch (platform specific)
        if test "$os_type" = "Darwin"
            if test "$arch" = "arm64"
                python3 -m pip install torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.1
            else
                python3 -m pip install torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 --index-url https://download.pytorch.org/whl/cpu
            end
        else
            python3 -m pip install torch torchvision torchaudio
        end
        
        # Verify installation
        python3 -c "import torch, transformers; print(f'PyTorch {torch.__version__}, Transformers {transformers.__version__}')"
        exit $status
    end
    exit $status
else if test (count $argv) -gt 0 && contains -- "--no-timeout" $argv
    # Running without timeout (this is the subprocess call)
    fast_install
else
    # Normal non-conda path, run directly
    fast_install
end

# Get installation status based on imports
function check_installation_status
    # Check if the key packages can be imported
    if python3 -c "import torch, transformers" 2>/dev/null
        return 0
    else
        return 1
    end
end

# Only run this part if we're not in the subprocess
if test (count $argv) -eq 0 || not contains -- "--no-timeout" $argv
    if check_installation_status
        echo
        echo "$GREEN""════════════════════════════════════════════════════════════════════""$NC"
        echo "$GREEN""✓ Fast AI dependency installation completed successfully!""$NC" 
        echo "$GREEN""✓ You can now use the AI features in Noesis.""$NC"
        echo "$GREEN""════════════════════════════════════════════════════════════════════""$NC"
        
        # Report which AI capabilities are available
        echo
        echo "$CYAN""Available AI features:""$NC"
        
        if python3 -c "import torch; print(f'PyTorch {torch.__version__}')" 2>/dev/null
            echo "  $GREEN""✓ PyTorch $(python3 -c "import torch; print(torch.__version__)" 2>/dev/null)""$NC"
        else
            echo "  $RED""✗ PyTorch (not available)""$NC"
        end
        
        if python3 -c "import transformers; print(f'Transformers {transformers.__version__}')" 2>/dev/null
            echo "  $GREEN""✓ Transformers $(python3 -c "import transformers; print(transformers.__version__)" 2>/dev/null)""$NC"
        else
            echo "  $RED""✗ Transformers (not available)""$NC"
        end
        
        if python3 -c "import accelerate; print(f'Accelerate {accelerate.__version__}')" 2>/dev/null
            echo "  $GREEN""✓ Accelerate $(python3 -c "import accelerate; print(accelerate.__version__)" 2>/dev/null)""$NC"
        else
            echo "  $RED""✗ Accelerate (not available)""$NC"
        end
        
        if test "$os_type" = "Darwin" -a "$arch" = "arm64"
            if python3 -c "import torch; print(f'MPS available: {torch.backends.mps.is_available()}')" 2>/dev/null
                echo "  $GREEN""✓ Apple Silicon MPS acceleration""$NC"
            else
                echo "  $YELLOW""○ CPU only mode""$NC"
            end
        else
            echo "  $YELLOW""○ CPU only mode""$NC"
        end
        
        exit 0
    else
        echo
        echo "$RED""════════════════════════════════════════════════════════════════════""$NC"
        echo "$RED""✗ Fast installation failed.""$NC"
        echo "$RED""════════════════════════════════════════════════════════════════════""$NC"
        echo
        echo "Try the following alternatives:"
        
        if $using_conda
            echo "1. Manual conda installation:"
            echo "   conda install -c pytorch pytorch torchvision torchaudio"
            echo "   pip install transformers accelerate huggingface_hub"
        else
            echo "1. Install miniconda/miniforge and try again with conda:"
            echo "   brew install miniforge"
            echo "   conda create -n noesis python=3.9"
            echo "   conda activate noesis"
            echo "   ./fast-ai-install.fish"
        end
        
        echo
        echo "2. Try with specific PyTorch version:"
        if test "$os_type" = "Darwin"
            if test "$arch" = "arm64"
                echo "   pip install torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.1"
            else
                echo "   pip install torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 --index-url https://download.pytorch.org/whl/cpu"
            end
        else
            echo "   pip install torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1"
        end
        echo "   pip install transformers accelerate huggingface_hub"
        
        exit 1
    end
end
