#!/bin/bash

# Script to look for duplicate Facet-Ids and Identifiers in Salesforce flexpages
# Author: mohan chinnappan
#------------------------------------------------------------------------------

# Check if input folder argument is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 --input-folder <folder_path>"
    exit 1
fi

# Check if the provided argument is --input-folder
if [ "$1" != "--input-folder" ]; then
    echo "Usage: $0 --input-folder <folder_path>"
    exit 1
fi

# Extract folder path
folder_path=$2

# Check if the provided folder exists
if [ ! -d "$folder_path" ]; then
    echo "Error: Folder '$folder_path' does not exist."
    exit 1
fi

# Loop through each file in the folder
for file in "$folder_path"/*; do
    if [ -f "$file" ]; then
        identifiers=$(sed -n 's/.*<identifier>\(flexipage_.*\)<\/identifier>.*/\1/p' "$file" | sort | uniq -d)
        facets=$(sed -n 's/.*<name>\(Facet.*\)<\/name>.*/\1/p' "$file" | sort | uniq -d)
        
        echo "Looking at the file: $file"
        
        if [ ! -z "$identifiers" ]; then
            echo "Identifiers:"
            echo "$identifiers"
        fi
        
        if [ ! -z "$facets" ]; then
            echo "Facets:"
            echo "$facets"
        fi
        
        echo "-------------------------"
    fi
done
