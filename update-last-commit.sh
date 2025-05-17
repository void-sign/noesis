#!/bin/bash
echo "Changing author of the latest commit to: Napol Thanrangkaun <lopanapol@gmail.com>"
echo "Original commit:"
git log -1

# Set environment variables for the commit amendment
export GIT_COMMITTER_NAME="Napol Thanrangkaun"
export GIT_COMMITTER_EMAIL="lopanapol@gmail.com"

# Amend the commit with the new author info but keep the same message
git commit --amend --author="Napol Thanrangkaun <lopanapol@gmail.com>" --no-edit

echo "Updated commit:"
git log -1

echo ""
echo "WARNING: The commit hash has changed. Since this commit was already pushed to"
echo "the remote repository, you will need to force push to update it:"
echo ""
echo "   git push --force origin main"
echo ""
echo "⚠️  Force pushing rewrites history and can cause problems for others using this repository."
echo "Only do this if you're sure it won't negatively impact your team."
