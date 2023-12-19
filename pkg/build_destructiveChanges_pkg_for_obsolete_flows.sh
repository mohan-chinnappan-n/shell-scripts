#!/bin/bash
##-------------------------------------------------
## --- script to prepare destructiveChanges.xml for
## --- deleting Obsolete flows in the Salesfore org
## --- mchinnappan feb-2023
##-------------------------------------------------

PREFIX='---'
function print_msg() {
	local msg=$1
	echo "$PREFIX $msg $PREFIX"
} 


usage() {
        print_msg "Usage: $0 [-u <username>] "

        1>&2
        exit 1
}


while getopts ":u:" opt; do
        case "${opt}" in
		u)
            username=${OPTARG}
            ;;
		*)
            usage
            ;;
        esac
 done
 shift $((OPTIND - 1))

if [ -z "${username}" ]; then
    usage
fi

print_msg "username: ${username}"

mkdir -p destructiveChanges

print_msg "Getting the SOQL query "

curl -O https://raw.githubusercontent.com/mohan-chinnappan-n/shell-scripts/master/soql/FlowObsoleteTooling.soql 

print_msg "Running the query to get the JSON file "
members=`sfdx mohanc:tooling:query -q FlowObsoleteTooling.soql -u ${username} -f json > /tmp/out.json; sfdx mohanc:data:jq -i /tmp/out.json -f  '.[] |  .Definition.DeveloperName + "-" + (.VersionNumber | tostring)' | sed 's/^"/<members>/' | sed 's/"/<\/members>/'`


print_msg "Forming destructiveChanges_flow.xml"


echo """<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">
<types>
	<name>Flow</name>
	${members}
</types>
<version>56.0</version>
</Package>
""" > destructiveChanges/destructiveChanges_flow.xml 

echo """
<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>
<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">
<version>56.0</version>
</Package>
""" > destructiveChanges/package_flow.xml

print_msg "Completed writing destructiveChanges_flow.xml"


print_msg "Deploy command"
echo sfdx force:source:deploy -u ${username}  -x destructiveChanges/package_flow.xml  --predestructivechanges destructiveChanges/destructiveChanges_flow.xml  -c --verbose --loglevel TRACE 

