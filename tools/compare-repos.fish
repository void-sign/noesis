#!/usr/bin/env fish

# Script to compare local git repository with remote server on noesis.run
# Usage: ./tools/compare-repos.fish [ssh-key-path]

if test (count $argv) -gt 0
    set ssh_key_path $argv[1]
    echo "Using SSH key: $ssh_key_path"
    ./tools/compare_git_repos.fish
else
    echo "Usage: ./tools/compare-repos.fish [path-to-ssh-private-key]"
    echo "Example: ./tools/compare-repos.fish ~/.ssh/id_rsa"
    echo "OR"
    echo "If your SSH key is already configured in ~/.ssh/config, just run:"
    echo "./tools/compare_git_repos.fish"
end
