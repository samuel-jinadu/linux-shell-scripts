#!/bin/bash

[ -d "./docx-to-epub" ] && cd "./docx-to-epub" || { echo "'docx-to-epub' folder required!"; exit 1; }

echo "Removing output folder..."
[ -d "output" ] && rm -rf "output"

echo "Creating output folder"
mkdir -p "output" || { echo "Failed to create output directory"; exit 1; }

echo "Changing wildcard behaviour..."
shopt -s nullglob

found=0

echo "Converting word documents..."
for file in *.docx; do
	found=1
	echo "Converting '$file'..."
	result="output/${file%.docx}.epub"
	ebook-convert "$file" "$result"  && echo "'$result' saved!" || echo "Conversion failed!"
done

[ "$found" -eq 0 ] && echo "No documents found!"
sleep 10