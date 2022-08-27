#!/bin/bash


# format
# -----------
#if TEST-COMMAND then
#  STATEMENTS
# elif TEST-COMMAND then 
#  STATEMENTS
#fi



#if the variable is not set in $1 use the default "apple"
fruit="${1:-apple}"
#echo $fruit

if [ $fruit == "apple" ]; then 
	echo "An $fruit day keeps the doctor away!"
elif [ $fruit == "mango" ]; then 
	echo "$fruit makes happy!"


fi

