import pandas as pd
import argparse

def vlookup(file1_path, file2_path, on_column, how):
    # Load the CSV files into DataFrames
    file1 = pd.read_csv(file1_path)
    file2 = pd.read_csv(file2_path)

    # Perform the VLOOKUP-like operation using the merge function
    result = pd.merge(file1, file2, on=on_column, how=how)

    # Display the result
    print(result)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Perform a VLOOKUP-like operation between two CSV files.')
    parser.add_argument('file1', help='Path to the first CSV file')
    parser.add_argument('file2', help='Path to the second CSV file')
    parser.add_argument('--on', required=True, help='Column on which to perform the VLOOKUP')
    parser.add_argument('--how', default='left', choices=['left', 'right', 'outer', 'inner'],
                        help='Type of join to perform: left, right, outer, or inner (default is left)')

    args = parser.parse_args()

    vlookup(args.file1, args.file2, args.on, args.how)
