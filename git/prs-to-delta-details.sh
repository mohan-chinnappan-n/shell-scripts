#!/bin/bash

: '
Script: prs-to-delta.sh
Author: Mohan Chinnappan 

Description:
This script takes two commit IDs as input arguments. It retrieves the changes between the two commits and generates a CSV file containing the operations (A/U/D/R), files involved, and datetime of the changes.

Usage:
    ./prs-to-delta.sh <commit_id_from> <commit_id_to>

Arguments:
    - commit_id_from: The commit ID representing the starting point.
    - commit_id_to: The commit ID representing the ending point.
'

# Function to generate CSV file with delta information
generate_csv() {
    local from_commit=$1
    local to_commit=$2
    
    # Generate git log between the two commit IDs
    git_log=$(git log --pretty=format:'%h|%s|%ai' $from_commit..$to_commit)

    # Parse git log and generate CSV
    echo "Operation,File,DateTime"
    while IFS='|' read -r commit_id message datetime; do
        if [[ $message == *"Merge pull request"* ]]; then
            operation="M"
        else
            operation="U"
        fi
        echo "$operation,$message,$datetime"
    done <<< "$git_log" > delta.csv
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

    # Generate CSV with delta information
    generate_csv "$commit_id_from" "$commit_id_to"

    echo "CSV file 'delta.csv' generated successfully."
}

# Run main function with command-line arguments
main "$@"
