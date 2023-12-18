#!/bin/bash

# Check if the correct number of command-line arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_folder> <output_folder>"
    exit 1
fi

input_folder=$1
output_folder=$2

# Create the output folder if it doesn't exist
mkdir -p "$output_folder"

# Iterate over each XML file in the input folder
for xml_file in "$input_folder"/*.xml; do
    echo "$xml_file"
    if [ -e "$xml_file" ]; then
        # Extract file name without extension
        file_name=$(basename "$xml_file")

        # Convert XML to JSON using the sfdx command
        json_file="$output_folder/${file_name}.json"
        echo "json_file: $json_file"
        sfdx mohanc:xml:xml2json -i "$xml_file" -o "$output_folder"

        # Find the number of regions in the JSON file using jq
        number_regions=$(jq '.FlexiPage.flexiPageRegions' "$json_file" | jq 'length')
        # Extract region types using jq
        #region_types=$(jq -r '.FlexiPage.flexiPageRegions[].type' "$json_file" | tr '\n' ',' | sed 's/,$//')
        region_summary=$(jq -r '.FlexiPage.flexiPageRegions | group_by(.type) | map({"type": .[0].type, "count": length}) | map("\(.type):\(.count)") | join(", ")' "$json_file")

        # Extract and summarize component instances using jq
        component_instances=$(jq -r '.FlexiPage.flexiPageRegions | map(.itemInstances.componentInstances[]?.componentName) | group_by(.) | map("\(.[0]):\(.|length)") | join(", ")' "$json_file")

       

        # Output to CSV file
        echo "$file_name,$number_regions, $region_summary, $component_instances" >> "${output_folder}/output.csv"

        echo "Processed: $xml_file"
    fi
done

echo "Script execution completed."

