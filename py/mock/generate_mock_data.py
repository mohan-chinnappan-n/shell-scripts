
"""
generate_mock_data.py

Author: Mohan Chinnappan

This script generates mock data for a Salesforce object based on a provided configuration file.
The generated data can be saved in either CSV or JSON format. Optionally, the data can be
copied to the clipboard, and a specified URL can be opened in the default web browser.

Usage:
python generate_mock_data.py --config <config_file_path> [--records <record_count>] [--output-format <csv/json>]
                             [--output-file <output_file_name>] [--open-url]

Arguments:
  --config, -c         Path to the configuration file (e.g., config.json) [required]
  --records, -r        Number of records to generate (default: 10)
  --output-format, -o  Output format (csv or json, default: json)
  --output-file, -of   Output file name (optional)

Dependencies:
  - Faker:         Python library for generating fake data (install with 'pip install faker')

Examples:
  1. Generate 20 records in JSON format and copy to clipboard:
     python generate_mock_data.py --config config.json --records 20 --output-format json

  2. Generate 15 records in CSV format, save to 'custom_output.csv', and open the CSV URL:
     python generate_mock_data.py --config config.json --records 15 --output-format csv --output-file custom_output.csv
"""

import argparse
import random
import json


import argparse
import random
import json
import csv
from faker import Faker



fake = Faker()

def load_config(file_path):
    with open(file_path, 'r') as config_file:
        config = json.load(config_file)
    return config['fields']

def generate_mock_data(fields, record_count):
    mock_data = []

    for _ in range(record_count):
        record = {field['name']: getattr(fake, field['type'])() for field in fields}
        mock_data.append(record)

    return mock_data

def save_to_csv(data, file_path):
    with open(file_path, 'w', newline='') as csv_file:
        fieldnames = data[0].keys()
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)

def save_to_json(data, file_path):
    with open(file_path, 'w') as json_file:
        json.dump(data, json_file, indent=2)

def print_mock_data(data):
    for record in data:
        print(record)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate mock data for Salesforce object.")
    parser.add_argument('--config', '-c', help='Path to the configuration file (e.g., config.json)', required=True)
    parser.add_argument('--records', '-r', type=int, help='Number of records to generate', default=10)
    parser.add_argument('--output-format', '-o', choices=['csv', 'json'], default='json', help='Output format (csv or json)')
    parser.add_argument('--output-file', '-of', help='Output file name (optional)')

    args = parser.parse_args()

    config_file_path = args.config
    record_count = args.records
    output_format = args.output_format
    output_file = args.output_file

    fields = load_config(config_file_path)
    mock_data = generate_mock_data(fields, record_count)

    if output_format == 'csv':
        output_file_path = output_file or 'output.csv'
        save_to_csv(mock_data, output_file_path)
    elif output_format == 'json':
        output_file_path = output_file or 'output.json'
        save_to_json(mock_data, output_file_path)
   
    print(f"Mock data saved to {output_file_path}")