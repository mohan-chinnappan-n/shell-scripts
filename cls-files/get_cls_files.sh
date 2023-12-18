#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <apex_folder> <output_csv>"
    exit 1
fi

# Get the apex_folder and output_csv from the command line
apex_folder="$1"
output_csv="$2"
# sub(/,/, ";", soql); \
# Use awk to find and print full SOQL queries in Apex files to a CSV file
awk 'BEGIN {print "File|Line|SOQL"} \
     /SELECT/ { \
         file = FILENAME; \
         gsub(/^.*\//, "", file); \
         line = FNR; \
         soql = $0; \
         while (getline) { \
             soql = soql $0; \
             if (/;$/) break; \
         } \
         print file "|" line "|" soql \
     }' "$apex_folder"/*.cls > "$output_csv"
