# yaml2json.py

# mchinnappan

import yaml
import json
import sys

usage="Usage yaml2json.py <file.yaml> <file.json>"

if  len(sys.argv) < 3:
    print(f'{usage}');
    sys.exit(0)

yaml_file =  sys.argv[1]
json_file =  sys.argv[2]


# Read YAML file
with open(yaml_file, "r") as yaml_file:
    yaml_data = yaml.load(yaml_file, Loader=yaml.FullLoader)

# Convert YAML to JSON
json_data = json.dumps(yaml_data)

# Write JSON to file
with open(json_file, "w") as json_file:
    json_file.write(json_data)

