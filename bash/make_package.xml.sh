API_VERSION=56.0
prefix=$(cat <<EOF 
<?xml version="1.0" encoding="UTF-8"?>

<Package xmlns="http://soap.sforce.com/2006/04/metadata">

<version>${API_VERSION}</version>

<types>
 
<name>CustomObject</name>
EOF
)

echo ${prefix}

while read line; do
  echo " <members>${line}</members>" 
done

suffix=$(cat << EOF
</types>

</Package>
EOF
)
echo ${suffix}
