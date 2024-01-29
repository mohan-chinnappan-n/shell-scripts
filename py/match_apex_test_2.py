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
    test_cls_files = read_files_in_folder(folder_path, ['_Test.cls', '.Test.cls'])

    matching_classes = {}
    non_matching_classes = {}

    for cls_file in cls_files:
        apex_class_name, _ = os.path.splitext(cls_file)
        apex_class_name = apex_class_name.strip()

        # Use regular expressions to find corresponding test classes
        test_class_pattern1 = re.compile(rf"{re.escape(apex_class_name)}_Test\.cls")
        test_class_pattern2 = re.compile(rf"{re.escape(apex_class_name)}Test\.cls")
        
        matching_test_classes = [
            test_cls for test_cls in test_cls_files
            if test_class_pattern1.match(test_cls) or test_class_pattern2.match(test_cls)
        ]

        test_classes = ', '.join(matching_test_classes) if matching_test_classes else None

        if test_classes is not None:
            matching_classes[apex_class_name] = test_classes
        else:
            non_matching_classes[apex_class_name] = None

    return matching_classes, non_matching_classes

def write_to_csv(output_file, classes_dict, fieldnames):
    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for apex_class, test_classes in classes_dict.items():
            writer.writerow({'ClassName': apex_class, 'TestClass': test_classes})

def main():
    parser = argparse.ArgumentParser(description="Match Salesforce Apex classes with their test classes and write to CSV.")
    parser.add_argument("folder_path", help="Path to the folder containing Apex classes and test classes.")
    args = parser.parse_args()

    matching_classes, non_matching_classes = match_apex_with_tests(args.folder_path)

    fieldnames = ['ClassName', 'TestClass']

    # Write CSV for matching classes
    write_to_csv("matching_classes.csv", matching_classes, fieldnames)
    print("Results for matching classes written to matching_classes.csv")

    # Write CSV for non-matching classes
    write_to_csv("non_matching_classes.csv", non_matching_classes, fieldnames)
    print("Results for non-matching classes written to non_matching_classes.csv")

if __name__ == "__main__":
    main()
