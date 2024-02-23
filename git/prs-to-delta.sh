#!/bin/bash

: '
Script: prs-to-delta.sh
Author: Mohan Chinnappan
----------------------------------------------------------------------------------------------------

Description:
This script takes two pull request numbers and their respective target branches as input arguments. 
It retrieves the commit IDs associated with the merge commits of the pull requests and 
then executes the "sfdx sgd:source:delta" command to generate a delta of changes between the commits.
 The delta is saved to a file named "_delta_.json".

Usage:
    bash prs-to-delta.sh <pr_number1> <target_branch1> <pr_number2> <target_branch2>

Arguments:
    - pr_number1: The number of the first pull request.
    - target_branch1: The name of the target branch for the first pull request.

    - pr_number2: The number of the second pull request.
    - target_branch2: The name of the target branch for the second pull request.

----------------------------------------------------------------------------------------------------
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
        echo "$commit_id"
    else
        echo "Error: Pull request #$pr_number not found in branch $target_branch"
        exit 1
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
    from_commit=$(find_commit_id "$pr_number1" "$target_branch1")

    # Find commit ID for second pull request
    to_commit=$(find_commit_id "$pr_number2" "$target_branch2")

    # Execute sfdx command
    sfdx sgd:source:delta -f "$from_commit" -t "$to_commit" -o . > _delta_.json
    cat _delta_.json 
}

# Run main function with command-line arguments
main "$@"
