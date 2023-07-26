#!/bin/bash

DAYS=$1
# Check the operating system
if [[ "$OSTYPE" == "darwin"* ]]; then  # macOS
    cutoff_date=$(date -v-${DAYS}d +"%Y-%m-%d")
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then  # Linux
    cutoff_date=$(date -d "-${DAYS} days" +"%Y-%m-%d")
else
    echo "Unsupported operating system."
    exit 1
fi

# Iterate over each branch and check the last commit date
git for-each-ref --format='%(committerdate:iso8601) %(refname:short)' refs/heads/ | while read commit_date branch_name; do
    # Check if the last commit date is earlier than the cutoff date
    #echo "$branch_name -> $commit_date: $cutoff_date"
    if [[ $commit_date < $cutoff_date ]]; then
        echo "Branch $branch_name is not active for the past ${DAYS} days (last commit: $commit_date)"
    fi
done

