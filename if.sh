B_NAME=$1
if [ "${B_NAME}" == "devsubbranch1.1" ]; then
	echo "$1"
# if you put elif like this:
# elif [ "${B_NAME}" == "developr2" ] 
# you will get syntax error:
#  syntax error near unexpected token `else' 
elif [ "${B_NAME}" == "developr2" ]; then
	echo "$1"
else 
	echo "unknown branch"

fi
