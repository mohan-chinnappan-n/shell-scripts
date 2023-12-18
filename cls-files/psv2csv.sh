#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_psv> <output_csv>"
    exit 1
fi

# Get the input_psv and output_csv from the command line
input_psv="$1"
output_csv="$2"

# Use awk to replace '|' with ',' and enclose fields in double quotes
awk 'BEGIN { OFS="\",\""; print "\"" } { gsub(/\|/,"\",\""); print } END { print "\"" }' "$input_psv" > "$output_csv"
