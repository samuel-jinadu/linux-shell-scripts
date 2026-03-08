echo -n "Type a number: "; read X
echo $X | grep "[^0-9]" > /dev/null 2>&1
if [ "$?" -eq 0 ]; then
	echo "This is not an integer"
elif [[ "$X" == 7 ]]; then
	echo "You've found the magic number"
fi