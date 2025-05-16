#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# fast-ai-install-py13.fish - Special AI dependency installation for Python 3.13+
# For use with modern Python versions where compatibility with PyTorch is limited

set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set CYAN (set_color cyan)
set NC (set_color normal)

echo "$CYAN"
echo "╔════════════════════════════════════════════════════╗"
echo "║     NOESIS PYTHON 3.13+ AI DEPENDENCIES SETUP      ║"
echo "╚════════════════════════════════════════════════════╝"
echo "$NC"

# Get system info
set os_type (uname)
set arch (uname -m)
set py_version (python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null)

echo "$BLUE""System: $os_type ($arch), Python: $py_version""$NC"
echo

# Create .noesis directory if it doesn't exist
mkdir -p ~/.noesis

# Run the specialized Python 3.13+ installation script
echo "$YELLOW""Running specialized Python 3.13+ AI installation...""$NC"
python3 tools/setup-torch-py13.py

# Check installation status
set ai_installed 0
if python3 -c "import torch" 2>/dev/null
    set ai_installed 1
    echo "$GREEN""PyTorch successfully installed!""$NC"
    set torch_version (python3 -c "import torch; print(torch.__version__)" 2>/dev/null)
    echo "Version: $torch_version"
else
    echo "$YELLOW""PyTorch installation not detected. Using compatibility layer...""$NC"
    
    # Create the torch compatibility module directory if needed
    mkdir -p ~/.noesis/torch_compat

    # Create minimal compatibility module if not exists from the Python script
    if not test -f ~/.noesis/torch_compat.py
        echo "$YELLOW""Creating minimal PyTorch compatibility layer...""$NC"
        echo '# PyTorch compatibility layer
import sys
import warnings

# Create a fake torch module
class FakeTorch:
    def __init__(self):
        self.__version__ = "0.1.0-compat"
        self.nn = FakeNN()
        self.cuda = FakeCuda()
        
    def tensor(self, *args, **kwargs):
        import numpy as np
        return np.array(*args)
    
    def load(self, *args, **kwargs):
        warnings.warn("PyTorch model loading not available in compatibility mode")
        return None

class FakeNN:
    def __init__(self):
        self.Module = type(\'Module\', (), {\'__init__\': lambda self: None})
        self.functional = type(\'functional\', (), {})

class FakeCuda:
    def __init__(self):
        pass
    
    def is_available(self):
        return False

# Create and export the compatibility module
sys.modules["torch"] = FakeTorch()
warnings.warn("Using PyTorch compatibility layer. Limited functionality available.")' > ~/.noesis/torch_compat.py
    end

    # Create a script to use the compatibility layer
    echo 'import sys
import os

# Add the compatibility layer to Python path
sys.path.insert(0, os.path.expanduser("~/.noesis"))

# Try importing proper torch first (in case it was installed)
try:
    import torch
    print(f"Using real PyTorch: {torch.__version__}")
except ImportError:
    # Fall back to compatibility layer
    import torch_compat
    print("Using PyTorch compatibility layer")' > ~/.noesis/use_torch_compat.py

    # Install numpy if missing (needed for the compatibility layer)
    echo "$YELLOW""Installing numpy (required for compatibility)...""$NC"
    python3 -m pip install numpy

    # Test the compatibility layer
    echo "$YELLOW""Testing compatibility layer...""$NC"
    python3 -c "import sys; sys.path.insert(0, '$HOME/.noesis'); import torch_compat; print('Compatibility layer works!')" && set ai_installed 1
fi

# Try to install Hugging Face Transformers
echo "$YELLOW""Installing Hugging Face Transformers...""$NC"
python3 -m pip install transformers accelerate --no-deps
python3 -m pip install huggingface_hub tokenizers

# Check Transformers installation
if python3 -c "import transformers" 2>/dev/null
    echo "$GREEN""Transformers successfully installed!""$NC"
    set transformers_version (python3 -c "import transformers; print(transformers.__version__)" 2>/dev/null)
    echo "Version: $transformers_version"
    set ai_installed 1
else
    echo "$RED""Failed to install Transformers.""$NC"
end

# Final status report
echo
if test $ai_installed -eq 1
    echo "$GREEN""════════════════════════════════════════════════════════════════════""$NC"
    echo "$GREEN""✓ AI dependencies installed (with Python 3.13+ compatibility)!""$NC"
    echo "$GREEN""✓ Some features may be limited due to version compatibility.""$NC"
    echo "$GREEN""════════════════════════════════════════════════════════════════════""$NC"
    
    echo
    echo "$CYAN""Available AI features:""$NC"
    
    if python3 -c "import torch; print(f'PyTorch {torch.__version__}')" 2>/dev/null
        echo "  $GREEN""✓ PyTorch $(python3 -c "import torch; print(torch.__version__)" 2>/dev/null)""$NC"
        
        # Check if it's the compatibility layer
        if python3 -c "import torch; exit(0 if torch.__version__ == '0.1.0-compat' else 1)" 2>/dev/null
            echo "    $YELLOW""(Compatibility layer - limited functionality)""$NC"
        end
    else
        echo "  $RED""✗ PyTorch (not available)""$NC"
    end
    
    if python3 -c "import transformers; print(f'Transformers {transformers.__version__}')" 2>/dev/null
        echo "  $GREEN""✓ Transformers $(python3 -c "import transformers; print(transformers.__version__)" 2>/dev/null)""$NC"
    else
        echo "  $RED""✗ Transformers (not available)""$NC"
    end
    
    echo
    echo "$GREEN""You can now use the AI features in Noesis (with some limitations).""$NC"
    echo "$YELLOW""Advanced features like neural network inference may be limited.""$NC"
    echo
    exit 0
else
    echo "$RED""════════════════════════════════════════════════════════════════════""$NC"
    echo "$RED""✗ Failed to install AI dependencies for Python 3.13+""$NC"
    echo "$RED""════════════════════════════════════════════════════════════════════""$NC"
    
    echo
    echo "$YELLOW""Recommendations:""$NC"
    echo "1. Install an older Python version compatible with PyTorch (3.9 or 3.10)"
    echo "2. Use conda environment: brew install miniforge"
    echo "3. Create compatible env: conda create -n noesis python=3.10"
    echo "4. Activate env: conda activate noesis"
    echo "5. Install PyTorch: conda install pytorch torchvision torchaudio -c pytorch"
    echo "6. Install HF: conda install pip && pip install transformers accelerate huggingface_hub"
    echo
    exit 1
end
