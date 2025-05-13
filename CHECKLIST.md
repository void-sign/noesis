# Repository Split Checklist

This checklist will help you finalize the Noesis repository split to ensure everything is properly set up.

## Before First Push

- [ ] Create GitHub repositories:
  - [ ] Create https://github.com/void-sign/noesis for Noesis Core
  - [ ] Create https://github.com/void-sign/noesis-extend for Noesis-Extend

- [ ] Configure git for each repository:
  ```bash
  # For Noesis Core
  cd /path/to/noesis
  git init
  git add .
  git commit -m "Initial commit for Noesis Core v1.0.0 after repository split"
  git remote add origin https://github.com/void-sign/noesis.git
  
  # For Noesis-Extend
  cd /path/to/noesis-hub
  git init
  git add .
  git commit -m "Initial commit for Noesis-Hub v1.0.0"
  git remote add origin https://github.com/void-sign/noesis-hub.git
  ```

- [ ] Run one final check of all files:
  ```bash
  # Check for any remaining references to 'void-sign'
  cd /path/to/noesis
  grep -r "void-sign" --include="*.md" --include="*.fish" --include="*.yml" .
  
  cd /path/to/noesis-hub
  grep -r "void-sign" --include="*.md" --include="*.fish" --include="*.yml" .
  ```

## First Push

- [ ] Push to GitHub:
  ```bash
  # For Noesis Core
  cd /path/to/noesis
  git push -u origin main
  
  # For Noesis-Hub
  cd /path/to/noesis-hub
  git push -u origin main
  ```

## After Push

- [ ] Configure GitHub repository settings:
  - [ ] Set appropriate branch protection rules
  - [ ] Configure issue templates
  - [ ] Set up GitHub Actions workflows
  
- [ ] Create releases:
  - [ ] Create v1.0.0 release for Noesis Core with notes from CHANGELOG_v1.0.0.md
  - [ ] Create v1.0.0 release for Noesis-Hub with notes from CHANGELOG_v1.0.0.md
  - [ ] Add appropriate tags

- [ ] Update documentation:
  - [ ] Ensure README.md in both repositories have the correct links
  - [ ] Verify CONTRIBUTING.md has proper guidance
  - [ ] Check that MIGRATION.md is comprehensive

## Final Verification

- [ ] Test building both repositories:
  ```bash
  # Test Noesis Core
  cd /path/to/noesis
  ./install.sh
  ./run_core.sh
  
  # Test Noesis-Hub
  cd /path/to/noesis-hub
  ./scripts/install_dependency.sh
  ./install.sh
  ./run.sh
  ```

- [ ] Test cross-repository integration:
  ```bash
  # Using the launch script
  cd /path/to/noesis
  ./launch_noesis_env.sh
  ```
