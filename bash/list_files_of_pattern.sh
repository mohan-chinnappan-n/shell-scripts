# list files of pattern  '* 2.*'
# go to top folder
find . -name '* 2.*' >> /tmp/dup_files.txt
# delete these files, uncomment the next lines
# xargs rm -rf < /tmp/dup_files.txt
