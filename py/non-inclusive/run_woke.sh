#!/bin/bash
echo "Checking non-inclusive language in the given folder"
FILES=$1
for f in $FILES
do
  echo "Processing $f file..." 
  woke $f >> non-inc.txt 
done

