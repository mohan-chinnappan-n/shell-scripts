#!/bin/bash

# Script to look for duplicate Facet-Ids and Identifiers in Salesforce flexipages
# Author: mohan chinnappan
#------------------------------------------------------------------------------

#!/bin/bash

# Function to process a single file
process_file() {
    file=$1
    identifiers=$(sed -n 's/.*<identifier>\(flexipage_.*\)<\/identifier>.*/\1/p' "$file" | sort | uniq -d)
    facets=$(sed -n 's/.*<name>\(Facet.*\)<\/name>.*/\1/p' "$file" | sort | uniq -d)

    echo "Look at the file: $file"

    if [ ! -z "$identifiers" ]; then
        echo "Identifiers:"
        echo "$identifiers"
    fi

    if [ ! -z "$facets" ]; then
        echo "Facets:"
        echo "$facets"
    fi

    echo "-------------------------"
}

# Check if input arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 (--input-folder <folder_path> | --file <file_path>)"
    exit 1
fi

# Check if the provided arguments are valid
if [ "$1" != "--input-folder" ] && [ "$1" != "--file" ]; then
    echo "Usage: $0 (--input-folder <folder_path> | --file <file_path>)"
    exit 1
fi

# Check if processing a single file
if [ "$1" == "--file" ]; then
    file_path=$2

    if [ ! -f "$file_path" ]; then
        echo "Error: File '$file_path' does not exist."
        exit 1
    fi

    process_file "$file_path"
    exit 0
fi

# Check if processing a folder
if [ "$1" == "--input-folder" ]; then
    folder_path=$2

    if [ ! -d "$folder_path" ]; then
        echo "Error: Folder '$folder_path' does not exist."
        exit 1
    fi

    for file in "$folder_path"/*; do
        if [ -f "$file" ]; then
            process_file "$file"
        fi
    done
fi
