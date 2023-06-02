read_csv() {
    local csvfile="$1"
    local FSEP="${2:-','}" #field spearator, default: ','
    local values_array=()
    
    # Check if the file exists
    if [ ! -f "$csvfile" ]; then
        echo "Error: File '$csvfile' does not exist."
        return 1
    fi
    
    # Read the CSV file line by line
    while IFS= read -r line; do
        # Split the line by comma and store values in an array
        IFS=${FSEP} read -ra values <<< "$line"
        
        # Add the array of values to the main values array
        values_array+=("${values[@]}")
    done < "$csvfile"
    
    # Return the values array
    echo "${values_array[@]}"
}

output=$(read_csv "$1" "$2")
echo "$output"
