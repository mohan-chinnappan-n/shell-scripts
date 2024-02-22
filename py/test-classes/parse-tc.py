import os 
import re 
def find_object_creations(directory, check_string_assignment=False): 
    object_creations = {} 
    object_creation_pattern = r'new\s+(\w+)\s*\(' 
    string_assignment_pattern = r'\b(\w+)\.(\w+)\s*=\s*\'\w+\'' 
    for root, dirs, files in os.walk(directory): 
        for file in files: 
            if file.endswith('.cls'): 
                file_path = os.path.join(root, file) 
                with open(file_path, 'r') as f: 
                    lines = f.readlines() 
                    for line_num, line in enumerate(lines, start=1): 
                        matches = re.findall(object_creation_pattern, line) 
                        for match in matches: 
                            if match not in object_creations: 
                                object_creations[match] = [] 
                                object_creations[match].append((file_path, line_num)) 
                        if check_string_assignment: 
                            string_assignments = re.findall(string_assignment_pattern, line) 
                            for obj, field, value in string_assignments: 
                                if obj in object_creations and field == 'Name': 
                                    object_creations[obj].append((file_path, line_num)) 
    return object_creations 
if __name__ == "__main__": 
    directory = input("Enter the directory path to scan: ") 
    check_string_assignment = input("Do you want to check for string assignments to object name fields? (y/n): ").lower() == 'y' 
    object_creations = find_object_creations(directory, check_string_assignment) 
    print("Object creations found:") 
    for obj, locations in object_creations.items(): 
        print(f"Object: {obj}") 
        for location in locations: 
            print(f" File: {location[0]}, Line: {location[1]}")