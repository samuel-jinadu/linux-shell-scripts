#!/bin/sh

echo This program was called with "\"$#\"" parameters
echo The program name is stored in "\"\$0\"" as "\"$0\""
echo The first parameter is stored in \"\$1\" as \"$1\"
echo All parameters are stored in \"\$@\" as \"$@\"
echo All parameters are \"${@:1:9}\"
