#!/bin/bash
# IFS = Internal Field Separator 

 
csv_reader() {
	input_file=$1
	IFS=$2
	start=$3
	fields=$4
        echo "=== reading file: $1 with field separtor: $2 with start:$3 ==="
	while read -r fields
	do
		echo $fields
	done < <(tail -n +$start $input_file)
}

fields=(fname lname invention)
csv_reader './input.csv' "|" 2 "${fields[@]}" 



