#!/bin/bash

#if the variable is not set in $1 use the default "apple"
fruit="${1:-apple}"

case $fruit in

  "apple")
	echo "An apple a day keeps the doctor away"
    ;;

  "mango")
	echo "Mango makes me happy - symbol of prosperity and happiness"
    ;;

  "pineapple")
	echo "Be a pineapple: Stand tall, wear a crown, and be sweet on the inside"
    ;;


  *)
    echo "$fruit is new one to me!"
    ;;
esac
