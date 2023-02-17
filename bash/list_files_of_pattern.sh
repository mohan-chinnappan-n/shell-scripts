## list files of pattern  '* 2.*'
## go to top folder and run the following command
find . -name '* 2.*' > /tmp/dup_files.txt

# to delete these files, uncomment the next line
# cat /tmp/dup_files.txt | sed 's/\(.*\)/"\1"/g' | xargs rm -f 
