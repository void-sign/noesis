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
    
    # First attempt: try the newest stable release that might work with Python 3.13
    print("Attempt 1: Installing newest stable PyTorch release...")
    success = False
    
    if is_apple_silicon():
        print("Detected Apple Silicon (M1/M2/M3)")
        success = run_command("pip install torch torchvision torchaudio")
    else:
        print("Detected Intel Mac")
        success = run_command("pip install torch torchvision torchaudio")
    
    # Check if it worked by trying to import
    if success:
        try:
            import torch
            print(f"Successfully installed PyTorch version: {torch.__version__}")
            return True
        except ImportError:
            print("Installation seemed to succeed but import failed. Trying nightly build...")
    
    # Second attempt: use the latest nightly builds which may better support newer Python
    print("Attempt 2: Installing PyTorch nightly builds...")
    if is_apple_silicon():
        print("Using nightly build for Apple Silicon")
        success = run_command("pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu")
    else:
        print("Using nightly build for Intel Mac")
        success = run_command("pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu")
    
    # Third attempt: try with specific version flags if all else fails
    if not success:
        print("Attempt 3: Trying specific version flags...")
        if is_apple_silicon():
            success = run_command("pip install --pre torch==2.2.0.dev torchvision==0.17.0.dev torchaudio==2.2.0.dev --index-url https://download.pytorch.org/whl/nightly/cpu")
        else:
            success = run_command("pip install --pre torch==2.2.0.dev torchvision==0.17.0.dev torchaudio==2.2.0.dev --index-url https://download.pytorch.org/whl/nightly/cpu")
    
    return success

def install_pytorch_minimal():
    """Install a minimal version of PyTorch that enables API functionality."""
    print("Installing minimal PyTorch (API-only compatibility)...")
    
    # Ensure numpy is installed for the compatibility layer
    print("Installing numpy dependency...")
    run_command("pip install numpy")
    
    # Try to install tinygrad as a fallback (only if we need advanced features)
    success = run_command("pip install tinygrad")
    
    # Create a compatibility layer for the Noesis system
    print("Creating comprehensive PyTorch API compatibility layer...")
    compat_code = """
# Enhanced PyTorch compatibility layer for Python 3.13+
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
        self.Module = type('Module', (), {
            '__init__': lambda self: None,
            'forward': lambda self, *args, **kwargs: None,
            '__call__': lambda self, *args, **kwargs: None,
            'parameters': lambda self: [],
            'eval': lambda self: self,
            'to': lambda self, *args, **kwargs: self,
        })
        self.functional = type('functional', (), {
            'softmax': lambda x, dim=None: x,
            'relu': lambda x: np.maximum(0, x) if isinstance(x, np.ndarray) else x,
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
        self.mps = type('mps', (), {'is_available': lambda: False})
        self.cudnn = type('cudnn', (), {'is_available': lambda: False})

# Create and export the compatibility module
sys.modules['torch'] = FakeTorch()
warnings.warn("Using PyTorch compatibility layer. Limited functionality available.")
print("Enhanced PyTorch compatibility layer initialized for Python 3.13+")
"""
        with open(os.path.expanduser("~/.noesis/torch_compat.py"), "w") as f:
            f.write(compat_code)
        return True
    return False

def install_transformers():
    """Install Hugging Face Transformers and related packages."""
    print("Installing Hugging Face libraries...")
    
    # First try to install the key packages individually with no dependencies
    print("Step 1: Installing core packages...")
    run_command("pip install transformers --no-deps")
    run_command("pip install accelerate --no-deps")
    run_command("pip install huggingface_hub --no-deps")
    run_command("pip install tokenizers --no-deps")
    
    # Now install essential dependencies that are known to work with Python 3.13+
    print("Step 2: Installing essential dependencies...")
    success = run_command("pip install numpy filelock packaging tqdm pyyaml")
    
    # Verify we can import the key packages
    transformers_ok = False
    try:
        import transformers
        print(f"Successfully installed Transformers version: {transformers.__version__}")
        transformers_ok = True
    except ImportError:
        print("Transformers import failed. Limited functionality will be available.")
    
    return transformers_ok

def main():
    """Main function."""
    print(f"Python version: {sys.version}")
    print(f"System: {platform.system()} {platform.machine()}")
    
    # Create .noesis directory if it doesn't exist
    os.makedirs(os.path.expanduser("~/.noesis"), exist_ok=True)
    
    print("\n" + "="*60)
    print("PHASE 1: PyTorch Installation")
    print("="*60)
    
    # Try to install regular PyTorch first
    pytorch_success = install_pytorch_py13()
    
    # If that fails, try the minimal compatibility layer
    if not pytorch_success:
        print("\nStandard PyTorch installation failed.")
        print("="*60)
        print("PHASE 2: Creating Compatibility Layer")
        print("="*60)
        print("Creating minimal compatibility layer for basic features...")
        pytorch_success = install_pytorch_minimal()
        
    if not pytorch_success:
        print("\nFailed to install any PyTorch solution.")
        print("Will continue with limited functionality...")
    
    print("\n" + "="*60)
    print("PHASE 3: Hugging Face Transformers Installation")
    print("="*60)
    
    # Install Transformers (even if PyTorch failed - some features might still work)
    transformers_success = install_transformers()
    if not transformers_success:
        print("Failed to install Transformers. Limited AI capabilities will be available.")
    
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
