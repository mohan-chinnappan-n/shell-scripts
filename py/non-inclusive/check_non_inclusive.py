#!/usr/bin/env python
#  mchinnappan
help_str ="""
Check Non-Inclusive Words in Text Files within a Folder and Create Backup Files.

This script reads a list of non-inclusive words and their corresponding inclusive equivalents
from a file and replaces non-inclusive words in text files with the inclusive versions. The inclusive
words are enclosed in square brackets to indicate the replacements. The script recursively traverses
all text files within a specified folder (and its subfolders) and applies the non-inclusive language check
to each file. It creates a backup file with the ".bak" extension for each processed text file,
leaving the original files unchanged.

Usage:
python check_non_inclusive.py --noninclusive <non_inclusive_file> --folder <folder_path> --ext <file_extensions> [--delim <delimiter>]

Arguments:
  --noninclusive    Path to the non-inclusive words file, which contains lines in the format:
                    non-inclusive, inclusive
  --folder          Path to the folder containing text files to check.
  --ext             File extensions to process (e.g., txt, csv, log, xml, json).
  --delim           Field delimiter for the input data file (default: ',')

Example:
python check_non_inclusive.py --noninclusive non_inclusive_words.txt --folder data_files --ext txt csv log --delim ;

Notes:
- The script supports text files with the specified file extensions provided via --ext.
- The inclusive replacements are written to backup files with the ".bak" extension.
- The original text files remain unchanged, and the backups contain the replaced content.


"""
import os
import argparse

def load_inclusive_mapping(file_path, delim):
    inclusive_mapping = {}
    with open(file_path, "r") as file:
        for line in file:
            non_inclusive, inclusive = map(str.strip, line.strip().split(delim))
            inclusive_mapping[non_inclusive.lower()] = inclusive
    return inclusive_mapping

def replace_non_inclusive(document, inclusive_mapping):
    words = document.split()
    replacements_count = 0

    for i, word in enumerate(words):
        lower_word = word.lower()
        if lower_word in inclusive_mapping:
            words[i] = f"[{word}/{inclusive_mapping[lower_word]}]"
            replacements_count += 1

    replaced_document = " ".join(words)
    return replaced_document, replacements_count

def check_non_inclusive_file(file_path, inclusive_mapping):
    with open(file_path) as f:
        sample_document = f.read()

    replaced_document, replacements_count = replace_non_inclusive(sample_document, inclusive_mapping)
    return replaced_document, replacements_count

def main():
    parser = argparse.ArgumentParser(description=help_str)
    parser.add_argument("--noninclusive", type=str, required=True, help="Path to the non-inclusive words file")
    parser.add_argument("--folder", type=str, required=True, help="Path to the folder containing files to check")
    parser.add_argument("--ext", type=str, nargs='+', required=True, help="File extensions to process")
    parser.add_argument("--delim", type=str, default=',', help="Field delimiter for the input data file (default: ',')")
    args = parser.parse_args()

    inclusive_mapping = load_inclusive_mapping(args.noninclusive, args.delim)

    total_replacements = 0

    for root, _, files in os.walk(args.folder):
        for file in files:
            file_path = os.path.join(root, file)
            file_extension = os.path.splitext(file_path)[1].lower()
            if file_extension[1:] in args.ext:
                backup_file_path = file_path + ".bak"
                replaced_document, replacements_count = check_non_inclusive_file(file_path, inclusive_mapping)
                with open(backup_file_path, "w") as backup_file:
                    backup_file.write(replaced_document)
                total_replacements += replacements_count

    print(f"Total replacements made: {total_replacements}")

if __name__ == "__main__":
    main()

