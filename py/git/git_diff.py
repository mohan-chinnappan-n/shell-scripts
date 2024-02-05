"""
Git Log to CSV Script
name: git_diff.py
Author: Mohan Chinnappan
------------------------------------


This script takes named command-line arguments for a Git repository path, 
from commit ID, to commit ID, and outputs a CSV file containing information 
about each commit, including details about inserted, modified, deleted, 
and renamed files.

Command-line arguments:
  --git_repo_path: Path to the Git repository
  --from_commitId: From commit ID (default: HEAD~2)
  --to_commitId:   To commit ID (default: HEAD)
  --output_csv:    Output CSV file name

Usage:
  python3 git_diff.py --git_repo_path /path/to/your/git/repo --output_csv output_stats.csv

Example:
 python3 git_diff.py --git_repo_path .  --from_commitId 'HEAD~100' --to_commitId 'HEAD'  --output_csv /tmp/git.csv

"""

import argparse
import subprocess
import csv

def git_log(repo_path, from_commit, to_commit):
    command = [
        'git',
        '-C', repo_path,
        'log',
        '--name-status',
        '--pretty=format:%H%n%an%n%ae%n%ad%n%s',
        f'{from_commit}..{to_commit}'
    ]

    try:
        result = subprocess.check_output(command, universal_newlines=True)
        return result.strip().split('\n\n')
    except subprocess.CalledProcessError as e:
        print(f"Error executing git log: {e}")
        return []

def parse_git_log(log_entries):
    file_changes = []

    for entry in log_entries:
        lines = entry.strip().split('\n')
        commit_hash, author_name, author_email, commit_date, commit_message = lines[:5]

        for line in lines[5:]:
            if line.startswith('M\t') or line.startswith('A\t') or line.startswith('D\t') or '=>' in line:
                change_type = 'Modified' if line.startswith('M\t') else 'Added' if line.startswith('A\t') else 'Deleted' if line.startswith('D\t') else 'Renamed'
                file_path = line.split('\t')[-1]
                file_changes.append({
                    'CommitHash': commit_hash,
                    'AuthorName': author_name,
                    'AuthorEmail': author_email,
                    'CommitDate': commit_date,
                    'CommitMessage': commit_message,
                    'ChangeType': change_type,
                    'FilePath': file_path
                })

    return file_changes

def output_to_csv(file_changes, output_csv):
    with open(output_csv, 'w', newline='') as csvfile:
        fieldnames = ['CommitHash', 'AuthorName', 'AuthorEmail', 'CommitDate', 'CommitMessage', 'ChangeType', 'FilePath']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        writer.writerows(file_changes)

    print(f"CSV file '{output_csv}' created successfully.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate Git diff stats and output to CSV")
    parser.add_argument('--git_repo_path', type=str, required=True, help='Path to the Git repository')
    parser.add_argument('--from_commitId', type=str, default='HEAD~2', help='From commit ID (default: HEAD~2)')
    parser.add_argument('--to_commitId', type=str, default='HEAD', help='To commit ID (default: HEAD)')
    parser.add_argument('--output_csv', type=str, required=True, help='Output CSV file name')
    args = parser.parse_args()

    log_entries = git_log(args.git_repo_path, args.from_commitId, args.to_commitId)
    file_changes = parse_git_log(log_entries)

    output_to_csv(file_changes, args.output_csv)
