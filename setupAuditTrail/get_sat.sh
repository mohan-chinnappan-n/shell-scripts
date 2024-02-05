#!/bin/bash

# Author: Mohan Chinnappan
#------------------------------------------
#!/bin/bash

# Script for querying SetupAuditTrail in Salesforce using SFDX

# Usage: ./get_sat.sh <USER> [<TO_DATE> <FROM_DATE>]

# Arguments:
#   <USER>       Salesforce user name to filter SetupAuditTrail by
#   <TO_DATE>    End date for the query in the format 'YYYY-MM-DD' (optional, default is today)
#   <FROM_DATE>  Start date for the query in the format 'YYYY-MM-DD' (optional, default is 30 days ago)
#
# example:
# bash get_sat.sh 'mohan chinnappan' 2024-01-01 2023-10-10

# Set default values
USER=${1:-'mohan chinnappan'}
TO=${2:-$(date +"%Y-%m-%d")}
FROM=${3:-$(date -v -30d +"%Y-%m-%d")}

# Generate SOQL query and save it to a file
echo "SELECT CreatedDate,
          CreatedBy.Name, 
          CreatedByContext, 
          CreatedByIssuer, 
          Display, 
          Section, 
          DelegateUser,
          ResponsibleNamespacePrefix 
          FROM SetupAuditTrail  
          WHERE 
          CreatedBy.Name = '$USER' 
          AND CreatedDate <= ${TO}T00:00:00Z AND CreatedDate >= ${FROM}T00:00:00Z
          ORDER BY CreatedDate DESC " > _sat_query.soql

# Execute SFDX query using the generated SOQL file
sfdx mohanc data bulkapi query  -u mohan.chinnappan.n.sel2@gmail.com -q _sat_query.soql

open _sat_query.soql.csv