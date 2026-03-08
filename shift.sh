#!/bin/sh

original=$#

if [[ $# == 0 ]]; then
	echo the program closed itself because there were no arguments; exit;
fi


while [[ $# -gt 0 ]]; do
	echo \"\$1\" is \"$1\"
	shift; echo \"shift\" was just run; echo There are \"$#\" parameters left from a starting number of \"$original\"
	echo
done
