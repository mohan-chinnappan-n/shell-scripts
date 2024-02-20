"""
Salesforce Package XML Combiner

Author: Mohan Chinnappan
----------------------------------------------------------------------
Script to combine two XML files representing Salesforce package metadata into one.

The script takes two input XML files, parses them, and combines their content into a single XML file.
The combined XML file contains unique types and members from both input files.

Usage:
    python combine_xml.py --file1 file1.xml --file2 file2.xml --output_file output.xml

Options:
    --file1 : Path to the first input XML file.
    --file2 : Path to the second input XML file.
    --output_file : Path to the output combined XML file. Default is stdout.
----------------------------------------------------------------------

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

    for types_elem in root2.findall(".//types"):
        name_elem = types_elem.find("name")
        name = name_elem.text
        existing_types = root1.findall(f".//types[name='{name}']")
        if existing_types:
            unique_members = set(member.text for existing_type in existing_types for member in existing_type.findall("members"))
            for member in types_elem.findall("members"):
                member_name = member.text
                if member_name not in unique_members:
                    existing_types[0].append(member)
                    unique_members.add(member_name)
        else:
            root1.append(types_elem)

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
