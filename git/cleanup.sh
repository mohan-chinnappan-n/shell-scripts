# git cleanup
#
# Verify Lock Files: Check if any lock files exist in the Git repository. 
# Lock files are typically located in the .git directory and have a .lock extension. Remove any existing lock files manually:
rm -f .git/*.lock
# Git Cleanup: Run the Git maintenance command git gc to perform a cleanup and optimize the Git repository
git gc --prune=now

