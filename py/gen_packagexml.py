import csv
import sys

#------------------------------------------------------
# generates package.xml for the given csv file (stdin)
# author: mohan chinnappan
#------------------------------------------------------

def generate_package_xml(csv_data):
    members_mapping = {}  # Map MemberType.MemberName to Members
    name_mapping = {}     # Map MemberType to Name

    # Read CSV data and populate mappings
    reader = csv.DictReader(csv_data)
    for row in reader:
        member_name = row['MemberName']
        member_type = row['MemberType']

        # Use lists to store multiple mappings for each MemberType or MemberName
        members_mapping.setdefault(f"{member_type}.{member_name}", set()).add(member_name)
        name_mapping.setdefault(member_type, set()).add(member_name)

    # Generate package.xml content
    package_xml_content = f"""<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <version>58.0</version>
"""
    for member_type, member_names in name_mapping.items():
        package_xml_content += f"""  <types>
"""
        for member_name in member_names:
            member_values = ', '.join(members_mapping.get(f"{member_type}.{member_name}", []))
            package_xml_content += f"""    <members>{member_values}</members>
"""
        package_xml_content += f"""    <name>{member_type}</name>
  </types>
"""

    package_xml_content += """</Package>"""

    # Write the package.xml content to stdout
    sys.stdout.write(package_xml_content)

# Example usage
# Read CSV data from stdin
csv_data = sys.stdin

generate_package_xml(csv_data)
