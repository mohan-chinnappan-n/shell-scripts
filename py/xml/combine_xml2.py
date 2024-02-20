
from xml.etree import ElementTree as ET

def combine_xml_files(file1, file2, output_file):
    tree1 = ET.parse(file1)
    root1 = tree1.getroot()

    tree2 = ET.parse(file2)
    root2 = tree2.getroot()

    for types_elem in root2.findall(".//types"):
        name_elem = types_elem.find("name")
        name = name_elem.text
        existing_types = root1.findall(f".//types[name='{name}']")
        if existing_types:
            existing_members = set()
            for existing_type in existing_types:
                existing_members.update(member.text for member in existing_type.findall("members"))
            for member in types_elem.findall("members"):
                member_name = member.text
                if member_name not in existing_members:
                    existing_types[0].append(member)
                    existing_members.add(member_name)
        else:
            root1.append(types_elem)

    combined_tree = ET.ElementTree(root1)
    combined_tree.write(output_file, encoding="utf-8", xml_declaration=True)

    print(f"Combined XML is written to {output_file}")
