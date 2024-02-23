#!/bin/bash

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
    if [ $# -ne 4 ]; then
        echo "Usage: $0 <pr_number1> <target_branch1> <pr_number2> <target_branch2>"
        exit 1
    fi

    # Extract arguments
    pr_number1=$1
    target_branch1=$2
    pr_number2=$3
    target_branch2=$4

    # Find commit ID for first pull request
    find_commit_id "$pr_number1" "$target_branch1"

    echo ""

    # Find commit ID for second pull request
    find_commit_id "$pr_number2" "$target_branch2"
}

# Run main function with command-line arguments
main "$@"
