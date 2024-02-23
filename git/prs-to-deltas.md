# prs-to-delta.sh

## Tool Description

- This script takes two pull request numbers and their respective target branches as input arguments. 
- It retrieves the commit IDs associated with the merge commits of the pull requests and 
then executes the "sfdx sgd:source:delta" command to generate a delta of changes between the commits.
 - The delta is saved to a file named "_delta_.json".

## Get the tool

```
curl -O https://raw.githubusercontent.com/mohan-chinnappan-n/shell-scripts/master/git/prs-to-delta.sh

```
## Usage
```
    bash prs-to-delta.sh <pr_number1> <target_branch1> <pr_number2> <target_branch2>
```

### Arguments:
- pr_number1: The number of the first pull request.
- target_branch1: The name of the target branch for the first pull request.

- pr_number2: The number of the second pull request.
- target_branch2: The name of the target branch for the second pull request.

## Examples
```
bash  prs-to-delta.sh 15003  develop 16267  develop

```