"""
Salesforce Package XML Combiner

Script to combine two XML files representing Salesforce package metadata into one.

The script takes two input XML files, parses them, and combines their content into a single XML file.
The combined XML file contains unique types and members from both input files.

Usage:
    python combine_xml.py --file1 file1.xml --file2 file2.xml --output_file output.xml

Options:
    --file1 : Path to the first input XML file.
    --file2 : Path to the second input XML file.
    --output_file : Path to the output combined XML file. Default is stdout.
"""

import xml.etree.ElementTree as ET
import argparse
import sys

def combine_xml_files(file1, file2, output_file):
    """
    Combines two Salesforce package metadata XML files into one.

    Args:
        file1 (str): Path to the first input XML file.
        file2 (str): Path to the second input XML file.
        output_file (str or file object): Path to the output combined XML file.
            If None, the combined XML will be written to stdout.

    Returns:
        None
    """
    tree1 = ET.parse(file1)
    root1 = tree1.getroot()

    tree2 = ET.parse(file2)
    root2 = tree2.getroot()

    # Combine types from file2 into file1
    for types_elem in root2.findall(".//types"):
        name_elem = types_elem.find("name")
        name = name_elem.text
        existing_types = root1.findall(f".//types[name='{name}']")
        if existing_types:
            # If the type already exists in file1, merge members
            for member_elem in types_elem.findall("members"):
                member = member_elem.text
                if member not in [m.text for m in existing_types[0].findall("members")]:
                    existing_types[0].append(member_elem)
        else:
            # If the type does not exist in file1, append it
            root1.append(types_elem)

    # Remove namespace
    for elem in root1.iter():
        if '}' in elem.tag:
            elem.tag = elem.tag.split('}', 1)[1]

    combined_tree = ET.ElementTree(root1)
    if output_file == sys.stdout:
        combined_tree.write(sys.stdout, encoding="utf-8", xml_declaration=True)
    else:
        combined_tree.write(output_file, encoding="utf-8", xml_declaration=True)
        print(f"Combined XML is written to {output_file}")

def main():
    parser = argparse.ArgumentParser(description="Combine two XML files into one.")
    parser.add_argument("--file1", type=str, help="Path to the first input XML file.")
    parser.add_argument("--file2", type=str, help="Path to the second input XML file.")
    parser.add_argument("--output_file", type=str, default=None, help="Path to the output combined XML file. Default is stdout.")
    args = parser.parse_args()

    if not args.file1 or not args.file2:
        print("Please provide paths for both input files.")
        return

    if args.output_file is None:
        combine_xml_files(args.file1, args.file2, sys.stdout)
    else:
        combine_xml_files(args.file1, args.file2, args.output_file)

if __name__ == "__main__":
    main()
