#!/bin/bash

: '
This script is designed to find the commit ID for a given pull request number in a local Git repository without using the GitHub API.

Author: Mohan Chinnappan
------------------------------------------------------------------------------
Usage:

    check out the code into a local folder
    cd to that folder
    run:
    
    bash find_commit_id.sh <pull_request_number> <target_branch>

Arguments:
    - pull_request_number: The number of the pull request for which you want to find the commit ID.
    - target_branch:       The name of the target branch where the pull request was merged.

Example:
    ./find_commit_id.sh 123 main

This script fetches the latest changes from the remote repository, then searches the Git history for a merge commit associated with the specified pull request number on the specified target branch.
If found, it prints the commit ID; otherwise, it indicates that the pull request was not found in the specified branch.
------------------------------------------------------------------------------

'


# Function to find commit ID for pull request
find_commit_id() {
    local pr_number=$1
    local target_branch=$2
    
    # Fetch latest changes from the remote repository
    git fetch origin
    
    # Get the commit ID for the pull request merge
    commit_id=$(git log --grep="Merge pull request #$pr_number from" --merges --grep="(#$pr_number)" origin/$target_branch | grep -m 1 -oE "[a-f0-9]{40}")
    
    if [ -n "$commit_id" ]; then
        echo "Commit ID for pull request #$pr_number: $commit_id"
    else
        echo "Pull request #$pr_number not found in branch $target_branch"
    fi
}

# Main function
main() {
    # Check if required arguments are provided
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <pull_request_number> <target_branch>"
        exit 1
    fi

    # Extract arguments
    pr_number=$1
    target_branch=$2

    # Find commit ID for pull request
    find_commit_id "$pr_number" "$target_branch"
}

# Run main function with command-line arguments
main "$@"
