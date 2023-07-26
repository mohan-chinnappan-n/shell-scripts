import xml.etree.ElementTree as ET
import argparse

def list_files_to_copy(package_xml_path):
    # Read the package.xml file
    with open(package_xml_path, 'r') as file:
        package_xml_content = file.read()

    print (package_xml_content)

    # Parse the XML content
    root = ET.fromstring(package_xml_content)

    print (root)
    # Extract the file names from the XML
    file_names = []
    for types in root.findall('types'):
        print('----')
        print(types)
        for member in types.findall('members'):
            file_names.append(member.text)

    return file_names

# Create an argument parser
parser = argparse.ArgumentParser(description='List files to be copied based on Salesforce package.xml content')

# Add the argument for package.xml path
parser.add_argument('-x', type=str, help='Path to package.xml file')

# Parse the command-line arguments
args = parser.parse_args()

# Get the package.xml path from the command-line argument
package_xml_path = args.x

# Call the function to list the files to be copied
files_to_copy = list_files_to_copy(package_xml_path)

# Print the list of files
print("Files to be copied:")
for file_name in files_to_copy:
    print(file_name)

