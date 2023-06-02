# get SOQL and filename and linenumber
grep -irn "SELECT.*FROM" *.cls > SOQLs.txt

# get the SOQLs
sed 's/.*\[\([^]]*\)\].*/\1/' SOQLs.txt'
