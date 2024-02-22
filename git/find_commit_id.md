
# Find Commit ID Script

This script is designed to find the commit ID for a given pull request number in a local Git repository without using the GitHub API.

- Download the script

```
curl -O https://raw.githubusercontent.com/mohan-chinnappan-n/shell-scripts/master/git/find_commit_id.sh
```
## Usage


 check out the code into a local folder
    cd to that folder
    run:

```bash
    bash find_commit_id.sh <pull_request_number> <target_branch>

```

## Arguments

- `pull_request_number`: The number of the pull request for which you want to find the commit ID.
- `target_branch`: The name of the target branch where the pull request was merged.

## Example

```bash
bash /find_commit_id.sh 123 main
```

This script fetches the latest changes from the remote repository, then searches the Git history for a merge commit associated with the specified pull request number on the specified target branch. If found, it prints the commit ID; otherwise, it indicates that the pull request was not found in the specified branch.