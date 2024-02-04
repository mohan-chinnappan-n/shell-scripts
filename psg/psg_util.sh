#!/bin/bash

# Permission Set Group (PSG) util
# Author: Mohan Chinnappan
#-------------------------------------------------------------

# Example run:
# bash psg_util.sh PROD mohan.chinnappan.n.sel2@gmail.com "Mohan Chinnappan"

SB_PROD=$1
SB_PROD=${SB_PROD:-"PROD"}

# Check if the SB_PROD argument is provided
if [ -z "$SB_PROD" ]; then
    echo "Error: SB_PROD argument not provided."
    exit 1
fi

# Determine the Salesforce login URL based on the value of SB_PROD
login_url=""
if [ "$SB_PROD" = "SB" ]; then
    login_url="https://test.salesforce.com"
elif [ "$SB_PROD" = "PROD" ]; then
    login_url="https://login.salesforce.com"
else
    echo "Error: Invalid value for SB_PROD. Expected 'SB' or 'PROD'."
    exit 1
fi

# Run Salesforce CLI login command
echo "Logging in to Salesforce with $SB_PROD environment..."
sf force auth web login -r "$login_url"

# Check the exit status of the Salesforce CLI login command
if [ $? -ne 0 ]; then
    echo "Error: Salesforce CLI login failed for $SB_PROD environment."
    exit 1
fi

# Set default values for USERNAME and create SOQL file names
USERNAME=$2
USERNAME=${USERNAME:-"mohan.chinnappan.n.sel2@gmail.com"}
USERS_PSG="users_psg"
PS_IN_PSG="ps_in_a_psg"
ASSIGNEE_NAME=$3

# Generate SOQL queries for users and PSG assignment
echo "SELECT Assignee.Name, \
PermissionSetGroup.DeveloperName,\
IsActive, \
IsRevoked, \
ExpirationDate \
FROM PermissionSetAssignment \
WHERE PermissionSetGroup.DeveloperName  != NULL " > "$USERS_PSG.soql"

# Execute Salesforce CLI data query for users and PSG assignment
echo "Executing Salesforce CLI data query for users and PSG assignment..."
sf mohanc data bulkapi query -u "$USERNAME" -q "$USERS_PSG.soql"

# Open the resulting CSV file
open "$USERS_PSG.soql.csv"

# -----------------------------------------------------------------------

# Generate SOQL query for permissions in a PSG
echo "SELECT PermissionSetGroup.DeveloperName, PermissionSet.Name \
FROM PermissionSetGroupComponent " > "$PS_IN_PSG.soql"

# Execute Salesforce CLI data query for permissions in a PSG
echo "Executing Salesforce CLI data query for permissions in a PSG..."
sf mohanc data bulkapi query -u "$USERNAME" -q "$PS_IN_PSG.soql"

# Open the resulting CSV file
open "$PS_IN_PSG.soql.csv"

# -----------------------------------------------------------------------

# Run Python script for user PSG details
# get the script
curl -O https://raw.githubusercontent.com/mohan-chinnappan-n/shell-scripts/master/psg/user_psg_details.py
python3 user_psg_details.py "$ASSIGNEE_NAME" "$USERS_PSG.soql.csv" "$PS_IN_PSG.soql.csv" output_result.csv

# Open the resulting CSV file
open output_result.csv
