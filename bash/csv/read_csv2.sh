read_csv() {
    local csvfile="$1"
    local FSEP="$2" #field spearator
    
    # Check if the file exists
    if [ ! -f "$csvfile" ]; then
        echo "Error: File '$csvfile' does not exist."
        return 1
    fi
    
    # Read the CSV file line by line
    while IFS= read -r line; do
        # Split the line by comma and store values in an array
        IFS="${FSEP}" read -ra values <<< "$line"
        
        # Process the values as needed (echo all fields in a single line)
        echo "${values[*]}"
    done < "$csvfile"
}

#-------------
read_csv $1 $2
