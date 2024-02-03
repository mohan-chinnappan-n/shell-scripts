#!/bin/bash

# Default values
spec="contact.json"
output="contacts.csv"
num_records=1000

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --spec)
            spec=$2
            shift 2
            ;;
        --num-records)
            num_records=$2
            shift 2
            ;;
        --output)
            output=$2
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

echo "=== getting the config file ==="
curl -O https://raw.githubusercontent.com/mohan-chinnappan-n/project-docs/main/datagen/py/${spec}

echo "=== getting the script ==="
curl -O https://raw.githubusercontent.com/mohan-chinnappan-n/shell-scripts/master/py/mock/generate_mock_data.py

echo "=== Using spec ==="
cat $spec
echo ==================

# Uncomment the next line to install Faker if not installed
# pip3 install Faker

echo "=== Generate $num_records records in csv format ==="
python3 generate_mock_data.py --config $spec --records $num_records --output-format csv --output-file $output

echo "=== First few lines of the $output ==="
head -n 5 $output
echo ==================

pbcopy < $output

echo "=== Opening the output file: $output in datatable in web browser ==="
open "https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=csv"
