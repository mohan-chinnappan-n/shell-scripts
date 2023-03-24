#!/usr/bin/env bash
# mchinnappan
username1=$1
username2=$2

title="Org SObjects Compare tool - compares SObjects in the given two orgs"
usage="Usage: org-sobjects-compare.sh <username1> <username2>"
echo -e "\033[32m${title}\033[0m"

if [ $# -lt 2 ]; then
 echo -e "\033[34m${usage}\033[0m"
 exit 1
fi


echo "=== Getting sobjects for the org with username: ${username1}... ==="
sfdx mohanc:md:describeGlobal -u ${username1}   | tr ',' '\n' | pbcopy  ;open "https://mohan-chinnappan-n5.github.io/delta/diff.html"
read -p "Paste the clipboard content into the left side of the diff app. Then press enter to continue to the next org..."

echo "=== Getting sobjects for the org with username: ${username2}... ==="
sfdx mohanc:md:describeGlobal -u ${username2}   | tr ',' '\n' | pbcopy  
echo "=== Now you can paste the content in the clipboard into the right side of the diff app and press Compare button... ==="


