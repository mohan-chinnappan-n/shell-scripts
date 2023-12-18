#!/bin/bash

# Check if the correct number of command-line arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_json_file> <output_image_file>"
    exit 1
fi

input_json=$1
output_image=$2

# Create a DOT file
dot_file="flexipage.dot"

# Redirect the output to the DOT file
echo "digraph FlexiPage {" > "$dot_file"

# Parse JSON with jq to extract relevant information
jq -r '
  .FlexiPage.flexiPageRegions as $regions |
  "  FlexiPage [shape=box];",
  "  FlexiPage -> " + ($regions | map("Region\(.index)")) + ";",
  $regions | map("  Region\(.index) [label=\"\(.type)\", shape=box];") | .[],
  $regions | map("  FlexiPage -> Region\(.index) [label=\"Region\(.index)\"];") | .[],
  $regions[] | .itemInstances // [] | map("  Region\(.regionIndex) -> Component\(.index) [label=\"Item\(.index)\"];") | .[],
  $regions[] | .itemInstances // [] | .[] | .componentInstance | map("  Component\(.index) [label=\"\(.componentName)\", shape=component];") | .[],
  $regions[] | .itemInstances // [] | .[] | .componentInstance | map("  Region\(.regionIndex) -> Component\(.index) [label=\"Item\(.index)\"];") | .[]
' "$input_json" >> "$dot_file"

echo "}" >> "$dot_file"

# Generate the image using Graphviz
dot -Tpng "$dot_file" -o "$output_image"

# Display the image
open "$output_image"
