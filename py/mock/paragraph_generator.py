"""
Script: paragraph_generator.py
Author: Mohan Chinnappan
============================================

Description:
    This script generates paragraphs using Python Faker, allowing customization of word list
    through the command line using argparse or by reading from a CSV file.

Usage:
    1. To use a custom word list from the command line:
        python paragraph_generator.py --word-list WORD1 WORD2 WORD3 ...
   
    2. To read a custom word list from a CSV file:
        python paragraph_generator.py --csv-file FILE_PATH

Arguments:
    --word-list WORD1 WORD2 WORD3 ...:
        Custom word list for paragraph generation.

    --csv-file FILE_PATH:
        CSV file containing the custom word list.

Example:
    1. Using a custom word list from the command line:
        python paragraph_generator.py --word-list danish cheesecake sugar Lollipop
   
    2. Reading a custom word list from a CSV file:
        python paragraph_generator.py --csv-file word_list.csv

Dependencies:
    - Faker library (Install with: pip install faker)
    - pandas library (Install with: pip install pandas)
"""

from faker import Faker
import argparse
import pandas as pd

fake = Faker()

def generate_paragraph(word_list):
    if word_list:
        return fake.sentence(ext_word_list=word_list)
    else:
        return fake.sentence()

def read_word_list_from_csv(csv_file):
    try:
        df = pd.read_csv(csv_file)
        return df["word"].tolist()
    except Exception as e:
        print(f"Error reading CSV file: {e}")
        return None

def main():
    parser = argparse.ArgumentParser(description="Generate paragraphs with custom word list")
    parser.add_argument("--word-list", nargs="+", help="Custom word list for paragraph generation")
    parser.add_argument("--csv-file", help="CSV file containing the custom word list")

    args = parser.parse_args()
    word_list = args.word_list

    if args.csv_file:
        word_list_from_csv = read_word_list_from_csv(args.csv_file)
        if word_list_from_csv:
            word_list = word_list_from_csv

    paragraph = generate_paragraph(word_list)
    print(paragraph)

if __name__ == "__main__":
    main()