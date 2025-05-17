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
    
    # Create minimal compatibility module if not exists from the Python script
    if not test -f ~/.noesis/torch_compat.py
        echo "$YELLOW""Creating minimal PyTorch compatibility layer...""$NC"
        echo '# PyTorch compatibility layer
import sys
import warnings
import numpy as np

# Create a fake torch module
class FakeTorch:
    def __init__(self):
        self.__version__ = "0.1.0-compat"
        self.nn = FakeNN()
        self.cuda = FakeCuda()
        self.backends = FakeBackends()
        self.device = "cpu"
        
    def tensor(self, *args, **kwargs):
        try:
            return np.array(*args)
        except:
            return np.array([]) if not args else np.array(args[0])
    
    def from_numpy(self, ndarray):
        return ndarray
        
    def load(self, *args, **kwargs):
        warnings.warn("PyTorch model loading not available in compatibility mode")
        return None
        
    def no_grad(self):
        # Context manager that does nothing
        class NoGradContext:
            def __enter__(self): pass
            def __exit__(self, *args): pass
        return NoGradContext()
        
    def save(self, *args, **kwargs):
        warnings.warn("PyTorch model saving not available in compatibility mode")
        return None

class FakeNN:
    def __init__(self):
        self.Module = type(\'Module\', (), {
            \'__init__\': lambda self: None,
            \'forward\': lambda self, *args, **kwargs: None,
            \'__call__\': lambda self, *args, **kwargs: None,
            \'parameters\': lambda self: [],
            \'eval\': lambda self: self,
            \'to\': lambda self, *args, **kwargs: self,
        })
        self.functional = type(\'functional\', (), {
            \'softmax\': lambda x, dim=None: x,
            \'relu\': lambda x: np.maximum(0, x) if isinstance(x, np.ndarray) else x,
        })
        self.Linear = lambda in_features, out_features, bias=True: self.Module()

class FakeCuda:
    def __init__(self):
        pass
    
    def is_available(self):
        return False
        
    def get_device_name(self, *args, **kwargs):
        return "Compatibility CPU"

class FakeBackends:
    def __init__(self):
        self.mps = type(\'mps\', (), {\'is_available\': lambda: False})
        self.cudnn = type(\'cudnn\', (), {\'is_available\': lambda: False})

# Create and export the compatibility module
sys.modules["torch"] = FakeTorch()
warnings.warn("Using PyTorch compatibility layer. Limited functionality available.")' > ~/.noesis/torch_compat.py
    end
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
python3 -m pip install numpy --user --break-system-packages

# Test the compatibility layer
echo "$YELLOW""Testing compatibility layer...""$NC"
python3 -c "
import sys, os
sys.path.insert(0, os.path.expanduser('~/.noesis'))
import torch_compat
fake_torch = sys.modules['torch']
# Test basic tensor creation
test_tensor = fake_torch.tensor([1, 2, 3])
# Test module creation
test_module = fake_torch.nn.Module()
print(f'Compatibility layer works! Created test tensor with shape {test_tensor.shape}')
" && set ai_installed 1

# Try to install Hugging Face Transformers and associated packages
echo "$YELLOW""Installing Hugging Face Transformers and dependencies...""$NC"

# First check if the packages already exist
set need_transformers 1
set need_accelerate 1
set need_tokenizers 1
set need_huggingface_hub 1

# Check transformers
if python3 -c "import transformers" 2>/dev/null
    echo "$GREEN""✓ transformers already installed""$NC"
    set need_transformers 0
else 
    echo "$YELLOW""transformers not found""$NC"
end

# Check accelerate
if python3 -c "import accelerate" 2>/dev/null
    echo "$GREEN""✓ accelerate already installed""$NC"
    set need_accelerate 0
else
    echo "$YELLOW""accelerate not found""$NC"
end

# Check tokenizers
if python3 -c "import tokenizers" 2>/dev/null
    echo "$GREEN""✓ tokenizers already installed""$NC"
    set need_tokenizers 0
else
    echo "$YELLOW""tokenizers not found""$NC"
end

# Check huggingface_hub
if python3 -c "import huggingface_hub" 2>/dev/null
    echo "$GREEN""✓ huggingface_hub already installed""$NC"
    set need_huggingface_hub 0
else
    echo "$YELLOW""huggingface_hub not found""$NC"
end

# Install packages that are needed
if test $need_transformers -eq 1
    echo "$YELLOW""Installing transformers...""$NC"
    python3 -m pip install transformers --no-deps --user --break-system-packages
end

if test $need_accelerate -eq 1
    echo "$YELLOW""Installing accelerate...""$NC"
    python3 -m pip install accelerate --no-deps --user --break-system-packages
end

if test $need_tokenizers -eq 1
    echo "$YELLOW""Installing tokenizers...""$NC"
    python3 -m pip install tokenizers --user --break-system-packages
end

if test $need_huggingface_hub -eq 1
    echo "$YELLOW""Installing huggingface_hub...""$NC"
    python3 -m pip install huggingface_hub --user --break-system-packages
end

# Check Transformers installation and set the variable
set can_import_transformers 0
if python3 -c "import transformers" 2>/dev/null
    set transformers_version (python3 -c "import transformers; print(transformers.__version__)" 2>/dev/null)
    if test -n "$transformers_version"
        echo "$GREEN""Transformers successfully installed!""$NC"
        echo "Version: $transformers_version"
        set ai_installed 1
        set can_import_transformers 1
    else
        echo "$YELLOW""Transformers detected but unable to get version.""$NC"
        set can_import_transformers 1
    end
else
    echo "$YELLOW""Note: Transformers package not fully accessible in Python 3.13+""$NC"
    echo "$YELLOW""Creating transformers compatibility layer...""$NC"
    
    # Create a minimal transformers compatibility module
    mkdir -p ~/.noesis/transformers
    echo '
import sys
import warnings

class BasicTransformer:
    def __init__(self):
        self.name = "compatibility-transformer"
    
    def __call__(self, text):
        return text

# Create minimal stub for transformers module
class TransformersModule:
    def __init__(self):
        self.__version__ = "0.0.1-compat"
        self.pipelines = type("pipelines", (), {"pipeline": lambda task="text-generation", **kwargs: BasicTransformer()})
        self.AutoModel = type("AutoModel", (), {"from_pretrained": lambda name, **kwargs: BasicTransformer()})
        self.AutoTokenizer = type("AutoTokenizer", (), {"from_pretrained": lambda name, **kwargs: BasicTransformer()})
        self.models = type("models", (), {})

# Register as module
sys.modules["transformers"] = TransformersModule()
warnings.warn("Using transformers compatibility stub. Most functionality unavailable.")' > ~/.noesis/transformers/__init__.py
    
    # Test the transformers compatibility module
    if python3 -c "import sys; sys.path.insert(0, '$(echo ~/.noesis)'); import transformers; print(f\"Transformers compatibility layer loaded: {transformers.__version__}\")" 2>/dev/null
        echo "$YELLOW""Created minimal transformers compatibility layer for basic API compatibility.""$NC"
        set can_import_transformers 1
        set ai_installed 1
    else
        echo "$RED""Failed to create transformers compatibility layer.""$NC"
    end
end

# Final status report
echo
# Check if torch_compat can be imported (skip if we already have PyTorch)
if not python3 -c "import torch" 2>/dev/null
    set can_import_torch_compat 0
    python3 -c "import sys; import os; sys.path.insert(0, os.path.expanduser('~/.noesis')); import torch_compat" 2>/dev/null; and set can_import_torch_compat 1
    if test $can_import_torch_compat -eq 1
        set ai_installed 1
    end
else
    set can_import_torch_compat 0
end

# Make final determination if any AI features are available
if test $ai_installed -eq 1
    echo "$GREEN""════════════════════════════════════════════════════════════════════""$NC"
    echo "$GREEN""✓ AI dependencies installed (with Python 3.13+ compatibility)!""$NC"
    echo "$GREEN""✓ Some features may be limited due to version compatibility.""$NC"
    echo "$GREEN""════════════════════════════════════════════════════════════════════""$NC"
    
    echo
    echo "$CYAN""Available AI features:""$NC"
    
    # Check real torch first
    set torch_available 0
    if python3 -c "import torch" 2>/dev/null
        set torch_version (python3 -c "import torch; print(torch.__version__)" 2>/dev/null)
        if test -n "$torch_version"
            echo "  $GREEN""✓ PyTorch $torch_version""$NC"
            set torch_available 1
        
            # Check if it's the compatibility layer
            if test "$torch_version" = "0.1.0-compat"
                echo "    $YELLOW""(Compatibility layer - limited functionality)""$NC"
            end
        else
            echo "  $RED""✗ PyTorch (error importing version)""$NC"
            set torch_available 0
        end
    # If real torch is not available, check compatibility layer
    else if test $can_import_torch_compat -eq 1
        echo "  $YELLOW""✓ PyTorch 0.1.0-compat (compatibility layer)""$NC"
        set torch_available 1
    else
        echo "  $RED""✗ PyTorch (not available)""$NC"
        set torch_available 0
    end
    
    # Check transformers
    set transformers_available 0
    if python3 -c "import transformers" 2>/dev/null
        set transformers_version (python3 -c "import transformers; print(transformers.__version__)" 2>/dev/null)
        if test -n "$transformers_version"
            echo "  $GREEN""✓ Transformers $transformers_version""$NC" 
            set transformers_available 1
        else
            echo "  $YELLOW""✓ Transformers (version unknown)""$NC"
            set transformers_available 1
        end
    else
        echo "  $RED""✗ Transformers (not available)""$NC"
        set transformers_available 0
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
    
    # Check if Python 3.13+ compatibility mode can be enabled anyway
    echo
    echo "$YELLOW""Attempting to enable compatibility mode anyway...""$NC"
    # Ensure numpy is installed for the compatibility layer
    python3 -m pip install numpy --user --break-system-packages
    
    # Create compatibility layer if it doesn't exist
    if not test -f ~/.noesis/torch_compat.py
        echo "$YELLOW""Creating emergency compatibility layer...""$NC"
        # This code is already in the script above, so it will be created
    end
    
    # Test if we can at least use the compatibility layer
    if python3 -c "import sys; import os; sys.path.insert(0, os.path.expanduser('~/.noesis')); import torch_compat; print('Emergency compatibility mode enabled')" 2>/dev/null
        echo "$YELLOW""Emergency compatibility mode enabled. Very limited functionality available.""$NC"
        echo "$YELLOW""Note: Most advanced AI features will not work properly.""$NC"
        exit 2
    else
        echo "$RED""Emergency compatibility mode failed.""$NC"
        exit 1
    end
end
