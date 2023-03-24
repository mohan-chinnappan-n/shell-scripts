#!/usr/bin/env bash
# Script to process sharing debugging for list of users got out of soql query
#  Creates svg file showing the permissions assigned to the the users, one file per user
# mchinnappan

title="Sharing debug info for the user"
usage="Usage: process_sharing_debug.sh <orgUsername>"

echo -e "\033[32m${title}\033[0m"

if [ $# -lt 1 ]; then
 echo -e "\033[34m${usage}\033[0m"
 exit 1
fi

uname=$1
users=`sfdx mohanc:data:query -u ${uname} -q ~/.soql/user.soql  | cut -f '3' -d ',' | sed 's/"//g' `
 
for user in ${users}; do
	echo "=== Processing user: ${user}... ==="
        sfdx mohanc:sharing:debug -u ${uname} -n ${user}
done
