#!/bin/bash


################################################################################
# Script Name: resty.sh
# Description: This script queries a Salesforce entity using Salesforce REST API
# Author: Mohan Chinnappan 
# Version: 1.0
# Examples:
# bash resty.sh --credentials ~/tmp/credentials_sel2.json  --entity 'v60.0/sobjects/Account/describe'
# bash resty.sh --credentials ~/tmp/credentials_sel2.json  --entity 'v60.0/limits' 
# bash resty.sh --credentials ~/tmp/credentials_sel2.json  --entity ' '  
################################################################################

# 
# Function to display usage
usage() {
    echo "Usage: $0 --credentials <credentials_file> --entity <entity>"
    echo "Options:"
    echo "  --credentials <credentials_file>: Specify the path to the credentials JSON file."
    echo "  --entity <entity>: Specify the Salesforce entity to query."
    echo "  --help: Display this help message."
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --credentials) credentials="$2"; shift ;;
        --entity) entity="$2"; shift ;;
        --help) usage ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# Check if credentials file and entity are provided
if [ -z "$credentials" ] || [ -z "$entity" ]; then
    echo "Error: Credentials file or entity not provided."
    usage
fi

# Trim whitespace from entity
entity=$(echo "$entity" | awk '{$1=$1};1')

# Check if credentials file exists
if [ ! -f "$credentials" ]; then
    echo "Error: Credentials file not found."
    exit 1
fi

# Read credentials from JSON file
if [ -f "$credentials" ]; then
    ACCESS_TOKEN=$(jq -r '.ACCESS_TOKEN' "$credentials")
    INSTANCE_URL=$(jq -r '.INSTANCE_URL' "$credentials")
    API_VERSION=$(jq -r '.API_VERSION' "$credentials")
else
    echo "Error: Credentials file not found."
    exit 1
fi

# Construct URL
#URL="${INSTANCE_URL}/services/data/${API_VERSION}/${entity}/"
URL="${INSTANCE_URL}/services/data/${entity}"
echo "URL: $URL" >&2

# Make the API request
curl "$URL" -H "Authorization: Bearer $ACCESS_TOKEN" -H "X-PrettyPrint: 1"
