#!/bin/bash

# Function to search for '<lightning-' in HTML files and list findings with filenames
search_lightning_components() {
    local directory="$1"  # The directory to search
    local output_file="$2"  # The file to store the findings

    if [ ! -d "$directory" ]; then
        echo "Directory ($directory) not found."
        return 1
    fi

    if [ -z "$output_file" ]; then
        echo "Output file not specified."
        return 1
    fi

    # Search for '<lightning-' in HTML files and store findings with filenames in the output file
    echo "filename, component, count" > "$output_file"
    find "$directory" -type f -name "*.html" -exec grep -H -o '<lightning-[^ ]*' {} \; | sort | uniq -c | awk '{print $2 ", " $3 ", " $1}' >> "$output_file"
}

# Example usage:
# Call the function with the directory to search and the output file
# The findings with filenames will be saved in the output file
#search_lightning_components "/path/to/your/directory" "findings.csv"
search_lightning_components $1 $2 