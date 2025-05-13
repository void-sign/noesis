# Change Default Branch on GitHub

Follow these steps to change the default branch to 'main' on your GitHub repository:

1. Go to your GitHub repository page (https://github.com/void-sign/noesis)
2. Click on "Settings" (near the top right)
3. In the left sidebar, click on "Branches"
4. Under "Default branch", click on the switch branch button (it likely says "origin" currently)
5. Select "main" from the dropdown
6. Click "Update"
7. Confirm the change when prompted

After you've changed the default branch on GitHub, run these commands locally:

```fish
# Fetch the latest references
git fetch --all --prune

# Check if the HEAD is now pointing to main
git remote show origin

# If your local setup still shows the old HEAD reference, you can update it with:
git remote set-head origin main
```

This will ensure that your local repository is properly configured to use 'main' as the default branch.
