#!/bin/sh

echo ">>> This program shows how default valuues for variables work and also the \`whoami\` command that outputs the name of the user"

echo -n ">>> What is your name (default value is \"`whoami`\"): "; read name

echo "Your name is: \"${name:-`whoami`}\""