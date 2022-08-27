while IFS=, read -r name code; do
  # do something... Don't forget to skip the header line!
  echo "$name"
   if [ "${name}" != "Name" ] ; then
     if [ "${code}}" != "US" ] ; then
	echo "$name"
     fi
  fi
done < data/countries.csv
