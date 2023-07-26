import xmltodict
import json
import argparse

def convert_package_xml_to_json(package_xml_path):
    # Read the package.xml file
    with open(package_xml_path, 'r') as file:
        package_xml_content = file.read()

    # Convert XML to OrderedDict
    xml_dict = xmltodict.parse(package_xml_content)

    # Convert OrderedDict to JSON
    json_data = json.dumps(xml_dict, indent=4)

    return json_data

def list_files_to_copy(json_data, file_path):
    # Load JSON data
    data = json.loads(json_data)

    # Extract the file names
    file_names = []
    for types in data['Package']['types']:
        members = types.get('members')
        if isinstance(members, str):
            file_names.append(f"{file_path}/{members}")
        elif isinstance(members, list):
            file_names.extend([f"{file_path}/{member}" for member in members])

    return file_names


# Create an argument parser
parser = argparse.ArgumentParser(description='List files to be copied based on Salesforce package.xml content')

# Add the argument for package.xml path
parser.add_argument('-x', type=str, help='Path to package.xml file')

# Add the argument for file path
parser.add_argument('-p', type=str, help='File path')

# Parse the command-line arguments
args = parser.parse_args()

# Get the package.xml path from the command-line argument
package_xml_path = args.x
file_path = args.p






# Call the function to convert package.xml to JSON
json_data = convert_package_xml_to_json(package_xml_path)
# Print the JSON data
print(json_data)


# Call the function to list the files to be copied
files_to_copy = list_files_to_copy(json_data, file_path)

# Print the list of files
print("Files to be copied:")
for file_name in files_to_copy:
    print(file_name)


