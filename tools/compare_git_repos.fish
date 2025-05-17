#!/usr/bin/env fish

# Script to compare local git repo with remote server
# Created: May 17, 2025

set LOCAL_REPO_PATH (pwd)
set REMOTE_SERVER "root@noesis.run"
set REMOTE_PATH "/opt/noesis"

# Print header
echo "============================================"
echo "Comparing local git repo with remote server"
echo "Local: $LOCAL_REPO_PATH"
echo "Remote: $REMOTE_SERVER:$REMOTE_PATH"
echo "============================================"

# Get local git info
echo "\nLocal git information:"
git log -1 --pretty=format:"Last commit: %h - %s (%ar) by %an"
git status --porcelain | wc -l | read -l local_changes
echo "Uncommitted changes: $local_changes"
git branch --show-current | read -l current_branch
echo "Current branch: $current_branch"

# Get remote git info
echo "\nRemote git information:"
ssh $REMOTE_SERVER "cd $REMOTE_PATH && git log -1 --pretty=format:\"Last commit: %h - %s (%ar) by %an\""
ssh $REMOTE_SERVER "cd $REMOTE_PATH && git status --porcelain | wc -l" | read -l remote_changes
echo "Uncommitted changes: $remote_changes"
ssh $REMOTE_SERVER "cd $REMOTE_PATH && git branch --show-current" | read -l remote_branch
echo "Current branch: $remote_branch"

# Compare head commits
echo "\nComparing HEAD commits:"
git rev-parse HEAD | read -l local_head
ssh $REMOTE_SERVER "cd $REMOTE_PATH && git rev-parse HEAD" | read -l remote_head

if test "$local_head" = "$remote_head"
    echo "HEAD commits match: $local_head"
else
    echo "HEAD commits differ:"
    echo "Local:  $local_head"
    echo "Remote: $remote_head"
    
    # Get commit difference count
    echo "\nCommit differences:"
    git rev-list --count "$remote_head..$local_head" 2>/dev/null | read -l ahead_count
    git rev-list --count "$local_head..$remote_head" 2>/dev/null | read -l behind_count
    
    if test "$behind_count" -gt 0
        echo "Remote is $behind_count commit(s) ahead of local"
    end
    if test "$ahead_count" -gt 0
        echo "Local is $ahead_count commit(s) ahead of remote"
    end
    
    # Show some of the different commits
    echo "\nUnique commits on remote:"
    ssh $REMOTE_SERVER "cd $REMOTE_PATH && git log --pretty=format:\"- %h: %s\" -n 3 $local_head..$remote_head" 2>/dev/null
    
    echo "\nUnique commits on local:"
    git log --pretty=format:"- %h: %s" -n 3 $remote_head..$local_head 2>/dev/null
end

# Check for specific files related to Python 3.13 compatibility
echo "\nChecking Python 3.13 compatibility files:"
echo "Local:"
test -f "tools/fast-ai-install-py13.fish" && echo "✓ tools/fast-ai-install-py13.fish exists" || echo "✗ tools/fast-ai-install-py13.fish missing"
test -f "system/ai-model/service-py13.fish" && echo "✓ system/ai-model/service-py13.fish exists" || echo "✗ system/ai-model/service-py13.fish missing"

echo "Remote:"
ssh $REMOTE_SERVER "test -f $REMOTE_PATH/tools/fast-ai-install-py13.fish && echo \"✓ tools/fast-ai-install-py13.fish exists\" || echo \"✗ tools/fast-ai-install-py13.fish missing\""
ssh $REMOTE_SERVER "test -f $REMOTE_PATH/system/ai-model/service-py13.fish && echo \"✓ system/ai-model/service-py13.fish exists\" || echo \"✗ system/ai-model/service-py13.fish missing\""

# Check if run.fish is the only file in root directory on remote server
echo "\nChecking file structure on remote server:"
ssh $REMOTE_SERVER "find $REMOTE_PATH -maxdepth 1 -type f | grep -v 'run.fish' | wc -l" | read -l non_run_files
if test "$non_run_files" -gt 0
    echo "$RED""Warning: Found $non_run_files files other than run.fish in root directory on remote server""$NC"
    echo "Files in root directory on remote server:"
    ssh $REMOTE_SERVER "find $REMOTE_PATH -maxdepth 1 -type f -not -name 'run.fish' | sort"
    
    echo "\nThese files should be moved to appropriate subdirectories."
    echo "You can move them with commands like:"
    echo "ssh $REMOTE_SERVER \"mkdir -p $REMOTE_PATH/tools && mv $REMOTE_PATH/FILENAME $REMOTE_PATH/tools/\""
else
    echo "✓ Only run.fish exists in root directory on remote server"
end

echo "\nDone!"
