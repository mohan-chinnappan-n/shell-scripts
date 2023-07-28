#!/bin/bash

# Check if three arguments are provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 input_file from_version to_version"
  exit 1
fi

input_file="$1"
from_version="$2"
to_version="$3"

# Perform the in-place edit using sed
sed -i '' "s/<version>$from_version<\/version>/<version>$to_version<\/version>/" "$input_file"

