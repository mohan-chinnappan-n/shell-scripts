#!/bin/bash

: '
Script: commit-diff-to-csv.sh
Author: [Your Name]

Description:
This script takes two commit IDs as input arguments. It generates a CSV file containing the operations (A/U/D/R), files involved, and datetime of the changes between the commits.

Usage:
    ./commit-diff-to-csv.sh <commit_id_from> <commit_id_to>

Arguments:
    - commit_id_from: The commit ID representing the starting point.
    - commit_id_to: The commit ID representing the ending point.
'

# Function to generate CSV file with diff information
generate_csv() {
    local from_commit=$1
    local to_commit=$2
    
    # Generate git diff between the two commit IDs
    git_diff=$(git diff --name-status $from_commit..$to_commit)

    # Parse git diff and generate CSV
    echo "Operation,File,DateTime"
    while IFS=$'\t' read -r operation file; do
        datetime=$(git log --pretty=format:%ai -n 1 $file)
        echo "$operation,$file,$datetime"
    done <<< "$git_diff" > diff.csv
}

# Main function
main() {
    # Check if required arguments are provided
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <commit_id_from> <commit_id_to>"
        exit 1
    fi

    # Extract arguments
    commit_id_from=$1
    commit_id_to=$2

    # Generate CSV with diff information
    generate_csv "$commit_id_from" "$commit_id_to"

    echo "CSV file 'diff.csv' generated successfully."
}

# Run main function with command-line arguments
main "$@"
