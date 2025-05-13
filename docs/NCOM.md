# Noesis Command (ncom)

The `ncom` command provides a shorter, more concise way to work with the Noesis project structure and operations.

## Usage

```
ncom [command] [options]
```

## Structure Management Commands

| Command | Alias | Description |
|---------|-------|-------------|
| `ncom save` | `ncom -s` | Save current project structure state |
| `ncom continue` | `ncom -c` | Restore latest saved structure state |

## Build Commands

| Command | Alias | Description |
|---------|-------|-------------|
| `ncom build` | `ncom -b` | Build the Noesis core |
| `ncom run` | `ncom -r` | Run the Noesis core |
| `ncom test` | `ncom -t` | Run all tests |

## Maintenance Commands

| Command | Description |
|---------|-------------|
| `ncom clean` | Clean up build artifacts |
| `ncom help` | Display help message |

## Examples

### Save Current Structure State

```bash
# Using fish shell
./ncom save

# Using bash shell
./ncom.sh save

# Using short aliases
./ncom -s
./ncom.sh -s
```

### Restore Latest Structure State

```bash
# Using fish shell
./ncom continue

# Using bash shell
./ncom.sh continue

# Using short aliases
./ncom -c
./ncom.sh -c
```

### Build and Run

```bash
./ncom build
./ncom run
```

## Implementation Details

The `ncom` command is a thin wrapper around the various scripts in the `scripts` directory, providing a more consistent and easier-to-remember interface for common operations.

For structure management, it uses the same functionality as the `noesis.fish save` and `noesis.fish continue` commands, just with a shorter syntax.
