"""
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


