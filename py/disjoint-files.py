#!/usr/local/bin/python3
# print disjoint lines between file1 and  file2 
# mchinnappan
#--------------------------------------------------
import sys
usage = """
----------------------------------------------------------------
python3 disjoint-files.py   file1 file2 
- Checks and prints any line  in the file1  not in the file2
----------------------------------------------------------------
"""
if len(sys.argv) != 3  :
    print (f"Usage: {usage}")
    exit(0)

file1 =  sys.argv[1]
file2 =  sys.argv[2]

with  open(file1, 'r') as f1:
    file1_contents = [line.strip() for line in f1.readlines()]
set1 = set (file1_contents)

with  open(file2, 'r') as f2:
    file2_contents = [line.strip() for line in f2.readlines()]
set2 = set (file2_contents)

for  item in set1:
    if item  not in set2:
        print(item.strip())


