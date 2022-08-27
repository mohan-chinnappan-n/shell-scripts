#!/bin/bash

un="mohan.chinnappan.n_ea2@gmail.com"

help() {
	if [[ "$1" -ne 1 ]] 
	then
	     echo "=== Org open script ==="
	     echo "usage: org_open.sh <page_to_open: setup|sites|ds>" 
	     echo "Example: usage: ./org_open setup"
	     exit 0 
	fi
}

help $#


page=$1
case $page in
	setup)
        echo "=== opening setup page ==="
	sfdx force:org:open -u $un -p  /lightning/setup/SetupOneHome/home
	;;

	sites)
	echo "=== opening sites page ==="
	sfdx force:org:open -u $un  -p  /lightning/setup/SetupNetworks/home
	;;

        ds)
        echo "=== opening deployment status ==="
	sfdx force:org:open -u $un  -p   lightning/setup/DeployStatus/home
esac


