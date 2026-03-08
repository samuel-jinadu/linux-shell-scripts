#!/bin/sh

str=empty
echo ">>> Press \"bye\" to quit"

while [[ $str != bye ]]; do
	read -p ">>> " str
	echo ">>> You entered \"$str\""
done