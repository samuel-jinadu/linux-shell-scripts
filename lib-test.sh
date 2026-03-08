#!/bin/bash
tail -n +4 $0;


# This program will display how lbraries wok in bash
echo
. ./common.lib


echo "Before"
echo
ls
echo
rename "$1" "$2"
echo
echo "After"
echo
ls



# This is where the program ends