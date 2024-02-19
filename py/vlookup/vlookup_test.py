import argparse
from vlookup_mc import VLookup

"""
---------------------------------------
vlookup_test.py
---------------------------------------
Test app to show the VLookup usage

Author: Mohan Chinnappan
---------------------------------------

Dependencies:
pip install vlookup-mc==0.1.0


Sample input files:

fruits.csv
==========

Name,Qty
Mango,100
Jackfruit,200
Peach,300
Pear,400
Plum,500



wearhouse.csv
=============


Name,WH
Mango,W2
Jackfruit,W11
Peach,W12



Usage:

 python3 vlookup_test.py --file1 ~/tmp/vlookup/fruits.csv --file2 ~/tmp/vlookup/wearhouse.csv --key-col1 Name --key-col2 Name --output-file ~/tmp/vlookup/FW.csv


Output file:


FW.csv
======

Name,Qty,WH
Mango,100,W2
Jackfruit,200,W11
Peach,300,W12
Pear,400,
Plum,500,

---------------------------------------
"""

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Perform VLOOKUP operation on two CSV files.")
    parser.add_argument("--file1", required=True, help="Path to the first CSV file")
    parser.add_argument("--file2", required=True, help="Path to the second CSV file")
    parser.add_argument("--key-col1", required=True, help="Column name for the key in the first CSV file")
    parser.add_argument("--key-col2",  required=True, help="Column name for the key in the second CSV file")
    parser.add_argument("--output-file", required=True, help="Path to the output CSV file")

    args = parser.parse_args()

    vlookup_processor = VLookup(args)
    vlookup_processor.vlookup()