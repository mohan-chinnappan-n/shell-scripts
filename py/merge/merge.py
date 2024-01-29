import sys

def merge_files(file1_path, file2_path, output_path):
    with open(file1_path, 'r') as file1:
        lines1 = file1.readlines()

    with open(file2_path, 'r') as file2:
        lines2 = file2.readlines()

    merged_lines, conflicts = merge_lines(lines1, lines2)

    if conflicts:
        print("Conflict detected. Merged lines with conflict markers:")
        for line in merged_lines:
            print(line, end="")
    else:
        with open(output_path, 'w') as output_file:
            output_file.writelines(merged_lines)
        print(f"Merged files '{file1_path}' and '{file2_path}' into '{output_path}' without conflicts.")

def merge_lines(lines1, lines2):
    merged_lines = []
    conflicts = False
    index1, index2 = 0, 0

    while index1 < len(lines1) and index2 < len(lines2):
        line1 = lines1[index1]
        line2 = lines2[index2]

        if line1 == line2:
            merged_lines.append(line1)
            index1 += 1
            index2 += 1
        else:
            # Conflict resolution: Keep both conflicting lines
            merged_lines.append(f"<<<<<<< HEAD\n{line1}=======\n{line2}>>>>>>>")
            conflicts = True
            index1 += 1
            index2 += 1

    # Append the remaining lines from both files, if any
    merged_lines.extend(lines1[index1:])
    merged_lines.extend(lines2[index2:])

    return merged_lines, conflicts

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python merge_files.py <file1_path> <file2_path> <output_path>")
        sys.exit(1)

    file1_path = sys.argv[1]
    file2_path = sys.argv[2]
    output_path = sys.argv[3]

    merge_files(file1_path, file2_path, output_path)
