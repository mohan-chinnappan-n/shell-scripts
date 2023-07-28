#!/bin/bash

# Check if three arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 input_file  to_version"
  exit 1
fi

input_file="$1"
to_version="$2"

# Perform the in-place edit using sed
sed -i '' "s/<version>[^<]*<\/version>/<version>$to_version<\/version>/" "$input_file"

