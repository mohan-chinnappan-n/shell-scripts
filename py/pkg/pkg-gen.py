import os
import argparse
from xml.etree.ElementTree import Element, SubElement, tostring
from xml.dom import minidom

def generate_package_xml(components):
    package = Element('Package', xmlns="http://soap.sforce.com/2006/04/metadata")

    for component_type, component_names in components.items():
        types = SubElement(package, 'types')
        for name in component_names:
            member = SubElement(types, 'members')
            member.text = name
        name = SubElement(types, 'name')
        name.text = component_type

    version = SubElement(package, 'version')
    version.text = "50.0"  # You may adjust the API version as needed

    return package

def write_package_xml(package, output_path):
    with open(output_path, 'w') as f:
        xml_str = minidom.parseString(tostring(package)).toprettyxml(indent="    ")
        f.write(xml_str)

def analyze_folder(folder_path):
    components = {}
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            file_path = os.path.join(root, file)
            # Analyze the file to determine the component type and name
            # For simplicity, let's assume all files are Apex classes
            component_type = 'ApexClass'
            component_name, _ = os.path.splitext(file)

            if component_type not in components:
                components[component_type] = []
            components[component_type].append(component_name)

    return components

def main():
    parser = argparse.ArgumentParser(description='Generate package.xml for a Salesforce project.')
    parser.add_argument('project_folder', help='Path to the Salesforce project folder.')
    parser.add_argument('package_xml_path', help='Path to output the package.xml file.')
    args = parser.parse_args()

    components = analyze_folder(args.project_folder)
    package_xml = generate_package_xml(components)
    write_package_xml(package_xml, args.package_xml_path)

if __name__ == "__main__":
    main()
