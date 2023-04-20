# JSON to YAML convertor
# json2yaml.py

# mchinnappan

import yaml
import json
import sys

usage="Usage json2yaml.py <file.json> <file.yaml>"

if  len(sys.argv) < 3:
    print(f'{usage}');
    sys.exit(0)

json_file =  sys.argv[1]
yaml_file =  sys.argv[2]


# Read JSON file
with open(json_file, "r") as json_file:
    json_data = json.load(json_file)

# Convert JSON to YAML
yaml_data = yaml.dump(json_data)

# Write YAML to file
with open(yaml_file, "w") as yaml_file:
    yaml_file.write(yaml_data)


