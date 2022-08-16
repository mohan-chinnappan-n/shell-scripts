#! /bin/bash 

csv_read_into_array() {
    arr_csv=() 
    while IFS=$2 read -r line 
    do
        arr_csv+=("$line")
    done < $1
}

csv_read_into_array 'input.csv' '|'
echo ${arr_csv[@]} 
echo '========='

echo "Displaying the contents of array mapped from csv file:"
index=0
for record in "${arr_csv[@]}"
do
    echo "Record at index-${index} : $record"
	((index++))
done