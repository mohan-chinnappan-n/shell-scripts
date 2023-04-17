#!/usr/local/bin/python3
# print disjoint lines between stdin and input file 
# mchinnappan
#--------------------------------------------------
import sys
usage = """
----------------------------------------------------------------
python3 disjoint-stdin.py   ref_file.txt
- Checks and prints any line  in the stdin  not in the ref_file
----------------------------------------------------------------
"""
if len(sys.argv) != 2  :
    print (f"Usage: {usage}")
    exit(0)


file2 =  sys.argv[1]
file1_contents  = [line.strip() for line in sys.stdin.readlines()]
set1  = set(file1_contents)

with  open(file2, 'r') as f2:
    file2_contents = [line.strip() for line in f2.readlines()]
set2 = set (file2_contents)

for  item in set1:
    if item  not in set2:
        print(item.strip())


