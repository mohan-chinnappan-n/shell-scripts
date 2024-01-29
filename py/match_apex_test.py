import os
import re
import argparse
import csv

def read_files_in_folder(folder_path, file_extensions):
    files = []
    for file_extension in file_extensions:
        pattern = re.compile(f".*{re.escape(file_extension)}$")
        files.extend([f for f in os.listdir(folder_path) if pattern.match(f)])
    return files

def match_apex_with_tests(folder_path):
    cls_files = read_files_in_folder(folder_path, ['.cls'])
    test_cls_files = read_files_in_folder(folder_path, ['*._Test.cls', '*.Test.cls'])
    matched_classes = {}

    for cls_file in cls_files:
        apex_class_name, _ = os.path.splitext(cls_file)
        apex_class_name = apex_class_name.strip()
        # Skip if the class file is a test class
        if not ( cls_file.endswith('_Test.cls') or cls_file.endswith('.Test.cls')):
            print (cls_file)

        # Use regular expressions to find corresponding test classes
        test_class_pattern1 = re.compile(rf"{re.escape(apex_class_name)}_Test\.cls")
        test_class_pattern2 = re.compile(rf"{re.escape(apex_class_name)}Test\.cls")
        
        matching_test_classes = [
            test_cls for test_cls in test_cls_files
            if test_class_pattern1.match(test_cls) or test_class_pattern2.match(test_cls)
        ]

        test_classes = ', '.join(matching_test_classes) if matching_test_classes else None
        if test_classes is not None:
            matched_classes[apex_class_name] = test_classes

    return matched_classes

def write_to_csv(output_file, matched_classes):
    with open(output_file, 'w', newline='') as csvfile:
        fieldnames = ['ClassName', 'TestClass']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for apex_class, test_classes in matched_classes.items():
            writer.writerow({'ClassName': apex_class, 'TestClass': test_classes})

def main():
    parser = argparse.ArgumentParser(description="Match Salesforce Apex classes with their test classes and write to CSV.")
    parser.add_argument("folder_path", help="Path to the folder containing Apex classes and test classes.")
    parser.add_argument("--output", default="output.csv", help="Output CSV file path.")
    args = parser.parse_args()

    matched_classes = match_apex_with_tests(args.folder_path)
    write_to_csv(args.output, matched_classes)

    print(f"Results written to {args.output}")

if __name__ == "__main__":
    main()
