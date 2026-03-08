#!/bin/sh
tail -n +4 $0;


# This program run factorial to displa recursion you can add arguments and it will caculate them al and the default is "4!"

# Stop if argument is missing or not a number
if [[ -z $1 || ! $1 =~ ^[0-9]+$ ]]; then
    echo "Usage: $0 <non-negative integer>"
    exit 1
fi

# Overflow threshold for 64-bit signed integers
if [[ $1 -gt 20 ]]; then
    echo "Error: $1! is too large and would cause integer overflow." >&2
    echo "Maximum safe value is 20! (2432902008176640000)." >&2
    exit 1
fi


factorial() {
	if [[ $1 -gt 1 ]]; then
		i=$(( $1 - 1 ))
		j=$(factorial $i)
		echo $(($1 * j))
	else
		echo 1
	fi
}

for i in $@; do
	echo "The factorial of \"$i\" is" \"$(factorial $i)\"
done



# This is where the script contents end and the script results begin


