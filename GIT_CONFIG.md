# Git Configuration

This document explains the Git configuration for the Noesis project, particularly the `.gitignore` setup.

## .gitignore Structure

The `.gitignore` file has been configured to:

1. **Ignore common build artifacts and temporary files**:
   - Object files (*.o)
   - Executables and binaries
   - Log files
   - Temporary files
   - Editor-specific files

2. **Track important source files and documentation**:
   - All source code (*.c, *.h, *.s)
   - Makefiles
   - Documentation
   - License files

3. **Special directory handling**:
   - `debug/`: Only source files (*.c, *.s) and makefiles are tracked, not the compiled binaries
   - `fish_scripts/`: All Fish shell scripts (*.fish) and README are tracked for reference 
   - `changelogs/`: All changelog files are tracked

## Directory Status

| Directory | Status | Notes |
|-----------|--------|-------|
| `source/` | Tracked | All source code is tracked |
| `include/` | Tracked | All header files are tracked |
| `tests/` | Tracked | All test files are tracked |
| `debug/` | Partial | Source files and documentation are tracked, binaries are ignored |
| `fish_scripts/` | Tracked | All Fish shell scripts are tracked for reference |
| `changelogs/` | Tracked | All changelog files are tracked |
| `object/` | Ignored | Generated object files are not tracked |
| `logs/` | Ignored | Log files are not tracked |
| `.github/` | Partial | GitHub workflow files may need to be tracked |

## Additional Files

There are some additional files in the repository that may need attention:

1. **GitHub Workflow Files**: The `.github/workflows/ci.yml` file and `.github/ISSUE_TEMPLATE/` directory could be tracked for CI/CD configuration.
2. **Source Files**: `source/utils/io_helper.c` appears to be untracked and may need to be added.

## Binary Files

The following binary files are explicitly ignored:
- `/noesis` - Main executable
- All compiled files in `debug/` directory
- All object files (`*.o`)

## Testing Git Configuration

You can test which files will be tracked by using:

```bash
git add -n path/to/directory/
```

This performs a "dry run" of `git add` without actually staging the files, allowing you to see which files would be added.
