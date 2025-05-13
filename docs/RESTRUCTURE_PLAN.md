# Noesis Restructuring Plan

This document outlines the target directory structure and the steps needed to reorganize the Noesis project into a more standard and clean layout.

## Target Directory Structure

```
noesis/
├── build/                     # Build artifacts (generated)
│   ├── bin/                   # Binary executables
│   ├── lib/                   # Generated libraries
│   └── obj/                   # Object files
├── data/                      # Data files
├── docs/                      # Documentation
│   ├── changelogs/            # Release notes
│   ├── CHECKLIST.md
│   ├── CONTRIBUTING.md
│   └── SECURITY.md
├── examples/                  # Example code
│   └── hub_example/           # Noesis Hub example
├── include/                   # Public header files
│   ├── api/                   # API headers
│   ├── core/                  # Core headers
│   ├── quantum/               # Quantum headers
│   │   └── field/             # Quantum field headers
│   └── utils/                 # Utility headers
├── libs/                      # External libraries
│   └── noesis_libc/           # Custom libc implementation
├── logs/                      # Log files (generated)
├── scripts/                   # Build and utility scripts
│   ├── bash/                  # Bash scripts
│   └── fish/                  # Fish scripts
├── src/                       # Source code
│   ├── api/                   # API implementation
│   ├── core/                  # Core implementation
│   ├── quantum/               # Quantum implementation
│   │   └── field/             # Quantum field implementation
│   ├── tools/                 # Tools implementation
│   └── utils/                 # Utility implementation
│       └── asm/               # Assembly implementations
├── tests/                     # Test suite
│   ├── debug/                 # Debug tests
│   └── unit/                  # Unit tests
├── .gitignore                 # Git ignore file
├── .vscode/                   # VS Code configuration
│   └── tasks.json             # Build tasks
├── Dockerfile                 # Docker build file
├── LICENSE                    # License file
├── Makefile                   # Main makefile
├── noesis.fish                # Fish shell runner
├── noesis.sh                  # Bash shell runner
└── README.md                  # Project readme
```

## Restructuring Steps

### 1. Create New Directory Structure

```fish
# Create new directory structure
mkdir -p build/bin build/lib build/obj
mkdir -p docs/changelogs
mkdir -p scripts/bash scripts/fish
mkdir -p src/api src/core src/quantum/field src/utils/asm src/tools
mkdir -p tests/debug tests/unit
mkdir -p libs
```

### 2. Move Documentation Files

```fish
# Move documentation files
mv CHECKLIST.md docs/
mv CONTRIBUTING.md docs/
mv SECURITY.md docs/
mv changelogs/* docs/changelogs/
```

### 3. Move Debug Files

```fish
# Move debug files
mv debug/* tests/debug/
```

### 4. Move Test Files

```fish
# Move test files
mv tests/* tests/unit/
```

### 5. Move Shell Scripts

```fish
# Move shell scripts
mv fish_scripts/* scripts/fish/
mv bash_scripts/* scripts/bash/
mv shell_scripts/* scripts/bash/
```

### 6. Move Source Files

```fish
# Move source files
# API files
for file in source/api/*.c source/api/*.h
  if test -f "$file"
    cp $file src/api/(basename $file)
  end
end

# Core files
for file in source/core/*.c source/core/*.h
  if test -f "$file"
    cp $file src/core/(basename $file)
  end
end

# Quantum files
for file in source/quantum/*.c source/quantum/*.h
  if test -f "$file"
    cp $file src/quantum/(basename $file)
  end
end

# Quantum field files
for file in source/quantum/field/*.c source/quantum/field/*.h
  if test -f "$file"
    cp $file src/quantum/field/(basename $file)
  end
end

# Utils files
for file in source/utils/*.c source/utils/*.h
  if test -f "$file"
    cp $file src/utils/(basename $file)
  end
end

# Asm files
for file in source/utils/asm/*.s
  if test -f "$file"
    cp $file src/utils/asm/(basename $file)
  end
end

# Tools files
for file in source/tools/*.c source/tools/*.h
  if test -f "$file"
    cp $file src/tools/(basename $file)
  end
end
```

### 7. Move Libraries

```fish
# Move noesis_libc to libs directory
mv noesis_libc libs/
```

### 8. Update Makefile

```fish
# Update Makefile
cp Makefile Makefile.original
sed -i '' 's|SRC_DIR = source|SRC_DIR = src|g' Makefile
sed -i '' 's|OBJ_DIR = object|OBJ_DIR = build/obj|g' Makefile
sed -i '' 's|BIN_DIR = bin|BIN_DIR = build/bin|g' Makefile
sed -i '' 's|ASM_DIR = source/utils/asm|ASM_DIR = src/utils/asm|g' Makefile
sed -i '' 's|-Inoesis_libc/include|-Ilibs/noesis_libc/include|g' Makefile
```

### 9. Update VS Code Tasks.json

Update the paths in tasks.json to use the new directory structure.

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Build All",
      "type": "shell",
      "command": "./scripts/fish/build_all.fish",
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "presentation": {
        "reveal": "always",
        "panel": "new"
      },
      "problemMatcher": [
        "$gcc"
      ]
    },
    {
      "label": "Build Core",
      "type": "shell",
      "command": "make",
      "group": "build",
      "presentation": {
        "reveal": "always",
        "panel": "new"
      },
      "problemMatcher": [
        "$gcc"
      ]
    },
    {
      "label": "Run Core",
      "type": "shell",
      "command": "./scripts/fish/run_core.fish",
      "group": {
        "kind": "test",
        "isDefault": true
      },
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Run All Tests",
      "type": "shell",
      "command": "./scripts/fish/run_all_tests.fish",
      "group": "test",
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Create Shared Library",
      "type": "shell",
      "command": "gcc -shared -o build/lib/libnoesis_core.so build/obj/core/*.o build/obj/utils/*.o build/obj/asm/*.o",
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    }
  ]
}
```

### 10. Create Run Scripts in New Location

**Fish Script Example - scripts/fish/run_core.fish**

```fish
#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

set BASE_DIR (dirname (dirname (dirname (status -f))))
cd $BASE_DIR

echo "Running Noesis Core..."
./noesis

echo "Completed."
```

**Bash Script Example - scripts/bash/run_core.sh**

```bash
#!/usr/bin/env bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

BASE_DIR=$(cd $(dirname $(dirname $(dirname "${BASH_SOURCE[0]}"))); pwd)
cd $BASE_DIR

echo "Running Noesis Core..."
./noesis

echo "Completed."
```

### 11. Update .gitignore

```
# Build artifacts
build/
libs/noesis_libc/obj/
libs/noesis_libc/lib/

# Generated files
*.o
*.a
*.so
*.dll
*.dylib
noesis
noesis_tests

# Log files
logs/*.log

# Editor files
.vscode/*
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/settings.json

# System files
.DS_Store
Thumbs.db
```

### 12. Create README for Legacy Directory Structure

```markdown
# Legacy Directory Structure Notice

This directory is part of the legacy structure of the Noesis project. 
It is being maintained for backward compatibility but will be deprecated in future releases.

Please use the new directory structure as documented in docs/STRUCTURE.md.
```

## Validation Steps

After restructuring, ensure:

1. The build system works with the new structure:
   ```fish
   make clean
   make
   ./noesis
   ```

2. All tests pass in the new structure:
   ```fish
   ./scripts/fish/run_all_tests.fish
   ```

3. VS Code tasks work correctly with the new paths

## Rollback Plan

If issues are encountered:

1. The original directory structure is preserved until verified everything works
2. The original Makefile is backed up as Makefile.original
3. To rollback, restore the original Makefile:
   ```fish
   cp Makefile.original Makefile
   ```