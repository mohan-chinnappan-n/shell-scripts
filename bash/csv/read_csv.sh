read_csv() {
    local csvfile="$1"
    
    # Check if the file exists
    if [ ! -f "$csvfile" ]; then
        echo "Error: File '$csvfile' does not exist."
        return 1
    fi
    
    # Read the CSV file line by line
    while IFS= read -r line; do
        # Split the line by comma and store values in an array
        IFS=',' read -ra values <<< "$line"
        
        # Process the values as needed (replace with your own logic)
        for value in "${values[@]}"; do
            echo "$value"
        done
    done < "$csvfile"
}

read_csv $1

