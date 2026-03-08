#!/bin/sh

tail -n +4 $0;

# "This program displays how external commands function"

# the external command results are been saved into a var
HTML_FILES=`find ~/Downloads -name "*.html" -print` 

# the var is printed using echo and then funnel into grep to fiter for the regex 
echo "$HTML_FILES" | grep "/index.html$" 
echo "$HTML_FILES" | grep "/contents.html$"

# === RESULTS ===

