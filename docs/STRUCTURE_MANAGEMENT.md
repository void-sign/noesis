# Noesis Project Structure Management

This document explains how to use the structure management commands to save and restore the project structure during the restructuring process.

## Quick Commands

### Save the Current Project Structure

To save the current state of the project structure:

```bash
# If using fish shell
./noesis.fish save

# If using bash
./noesis.sh save
```

This will:
1. Create a timestamp-based snapshot of the directory structure
2. Save copies of important configuration files (Makefile, tasks.json, .gitignore)
3. Create a Git tag (if in a Git repository) for easy restoration later

### Restore the Latest Saved Structure

To restore the most recently saved project structure:

```bash
# If using fish shell
./noesis.fish continue

# If using bash
./noesis.sh continue
```

This will:
1. Find the most recent saved structure snapshot
2. Recreate the directory structure from that snapshot
3. Restore the saved configuration files

## Manual Structure Management

If you need finer control, you can also use the underlying scripts directly:

### To Save a Structure State Manually

```bash
# If using fish shell
fish ./scripts/save_structure_state.fish

# If using bash
bash ./scripts/save_structure_state.sh
```

### To Restore a Specific Structure State Manually

```bash
# If using fish shell (replace TIMESTAMP with the actual timestamp)
fish ./scripts/restore_structure_state.fish TIMESTAMP

# If using bash (replace TIMESTAMP with the actual timestamp)
bash ./scripts/restore_structure_state.sh TIMESTAMP
```

## Available Structure Snapshots

To see available structure snapshots:

```bash
ls -l docs/directory_structure_*.txt
```

## Git Tags

If you're using Git, each save operation creates a Git tag. List all structure-related tags:

```bash
git tag | grep restructure-state
```

To restore using a Git tag:

```bash
git checkout restructure-state-TIMESTAMP
```
