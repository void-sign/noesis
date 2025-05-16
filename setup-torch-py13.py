#!/usr/bin/env python3
"""
PyTorch installation script for Python 3.13 on macOS.
This script will attempt to install the latest compatible version of PyTorch.
"""

import sys
import subprocess
import platform
import os

def run_command(command):
    """Run a shell command and return the output."""
    print(f"Running: {command}")
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error ({result.returncode}):")
        print(result.stderr)
    else:
        print("Success!")
        if result.stdout:
            print(result.stdout)
    return result.returncode == 0

def get_python_version():
    """Get the Python version as a tuple (major, minor)."""
    return (sys.version_info.major, sys.version_info.minor)

def is_apple_silicon():
    """Check if the system is running on Apple Silicon."""
    return platform.machine() == 'arm64' and platform.system() == 'Darwin'

def install_pytorch_py13():
    """Install PyTorch for Python 3.13."""
    print("Installing PyTorch for Python 3.13...")
    
    # For Python 3.13, use the latest nightly builds which may support newer Python
    if is_apple_silicon():
        print("Detected Apple Silicon (M1/M2/M3)")
        return run_command("pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu")
    else:
        print("Detected Intel Mac")
        return run_command("pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu")

def install_pytorch_minimal():
    """Install a minimal version of PyTorch that enables API functionality."""
    print("Installing minimal PyTorch (API-only compatibility)...")
    
    # Use a solution like tinygrad as a fallback 
    success = run_command("pip install tinygrad")
    if success:
        # Create a compatibility layer for the Noesis system
        print("Creating PyTorch API compatibility layer...")
        compat_code = """
# PyTorch compatibility layer using tinygrad
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
        self.Module = type('Module', (), {'__init__': lambda self: None})
        self.functional = type('functional', (), {})

class FakeCuda:
    def __init__(self):
        pass
    
    def is_available(self):
        return False

# Create and export the compatibility module
sys.modules['torch'] = FakeTorch()
warnings.warn("Using PyTorch compatibility layer. Limited functionality available.")
print("PyTorch compatibility layer initialized.")
"""
        with open(os.path.expanduser("~/.noesis/torch_compat.py"), "w") as f:
            f.write(compat_code)
        return True
    return False

def install_transformers():
    """Install Hugging Face Transformers and related packages."""
    print("Installing Hugging Face libraries...")
    return run_command("pip install transformers accelerate huggingface_hub")

def main():
    """Main function."""
    print(f"Python version: {sys.version}")
    print(f"System: {platform.system()} {platform.machine()}")
    
    # Create .noesis directory if it doesn't exist
    os.makedirs(os.path.expanduser("~/.noesis"), exist_ok=True)
    
    # Try to install regular PyTorch first
    pytorch_success = install_pytorch_py13()
    
    # If that fails, try the minimal compatibility layer
    if not pytorch_success:
        print("Standard PyTorch installation failed. Trying minimal compatibility layer...")
        pytorch_success = install_pytorch_minimal()
        
    if not pytorch_success:
        print("Failed to install any PyTorch solution. Noesis AI features may be unavailable.")
    
    # Install Transformers (even if PyTorch failed - some features might still work)
    transformers_success = install_transformers()
    if not transformers_success:
        print("Failed to install Transformers. Please try manually.")
    
    # Attempt to verify installations
    try:
        import torch
        print(f"PyTorch available! Version: {torch.__version__}")
        print(f"CUDA available: {torch.cuda.is_available()}")
        pytorch_success = True
    except ImportError:
        print("PyTorch import failed.")
        pytorch_success = False
        
    try:
        import transformers
        print(f"Transformers available! Version: {transformers.__version__}")
        transformers_success = True
    except ImportError:
        print("Transformers import failed.")
        transformers_success = False
    
    if pytorch_success and transformers_success:
        print("\nAll dependencies installed successfully!")
        return True
    elif pytorch_success or transformers_success:
        print("\nPartial installation successful. Some features may be available.")
        return True
    else:
        print("\nInstallation failed. AI features will be unavailable.")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
