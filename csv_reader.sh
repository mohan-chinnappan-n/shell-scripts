#!/bin/bash
# IFS = Internal Field Separator 

input_file='/tmp/input.csv'

cat  > $input_file <<EOF
fname|lname|invention
Dennis|Ritchie|Unix,C,Plan9
Ken|Thompson|ed,Unix,B,Golang
EOF

 
csv_reader() {
	input_file=$1
	IFS=$2
	start=$3
	fields=$4
        echo "=== reading file: $1 with field separtor: $2 with start:$3 ==="
	while read -r fields
	do
		echo  $fields
	done < <(tail -n +$start $input_file)
}

fields=(fname lname invention)
csv_reader $input_file "|" 2 "${fields[@]}" 



