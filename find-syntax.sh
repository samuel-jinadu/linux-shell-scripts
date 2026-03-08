#!/bin/sh

echo "This program \"$0\" dsiplays the syntax for \"find\" command and also uses it with \"grep\""

echo "The following code" "\"find ./ -name \"*.sh\" -print\"" "will produce"

find ./ -name "*.sh" -print

echo 

echo "While the following code" "\"find ./ -name \"*.sh\" -print\" | grep -E \"/var[0-9]?\.sh$\"" "will produce..."

find ./ -name "*.sh" -print | grep -E "/var[0-9]?\.sh$"