# Mock data gen tool

spec="contact.json"
output="contacts.csv"
num_records=1000

echo "=== getting the config file ==="
curl -O https://raw.githubusercontent.com/mohan-chinnappan-n/project-docs/main/datagen/py/${spec}

echo "=== getting the script ==="
curl -O https://raw.githubusercontent.com/mohan-chinnappan-n/shell-scripts/master/py/mock/generate_mock_data.py

echo === Using spec ===
cat $spec
echo ==================


# install Faker if not installed
# pip3 install Faker

echo "=== Generate $num_records records in csv format ==="
python3 generate_mock_data.py --config contact.json --records $num_records --output-format csv --output-file $output

echo === First few lines of the $output ===
head -n 5 $output
echo ==================


pbcopy < $output

echo "=== Opening the output file: $output  in datatable in web browser ==="
open "https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=csv"
