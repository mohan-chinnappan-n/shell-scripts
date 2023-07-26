#!/bin/bash

months=$1
echo "Months: $months"

# Check the operating system
if [[ "$OSTYPE" == "darwin"* ]]; then  # macOS
    cutoff_date=$(date -v-${months}m +"%Y-%m-%d")
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then  # Linux
    cutoff_date=$(date -d "${months} months ago" +"%Y-%m-%d")
else
    echo "Unsupported operating system."
    exit 1
fi

echo "OSTYPE: $OSTYPE"
# Iterate over each branch and check the last commit date
git for-each-ref --format='%(committerdate:iso8601) %(refname:short)' refs/heads/ | while read commit_date branch_name; do
    # Check if the last commit date is earlier than the cutoff date
    echo "$branch_name -> $commit_date: $cutoff_date"
    if [[ $commit_date < $cutoff_date ]]; then
        echo "Branch $branch_name is not active for the past $months months (last commit: $commit_date)"
    fi
done

