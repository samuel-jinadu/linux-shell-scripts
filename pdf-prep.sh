#!/bin/bash

nl () {
	echo ""
}

#I got tired of ocr running and slowing down the LLM agents when I upload documents, so I'll just turn them all to text, it should be good enough in my opinion since the LLMs are good at recognising tables and such... maaybe idk


[ -d "./pdf-prep" ] && cd "./pdf-prep" || { echo "'pdf-prep' folder required!"; exit 1; }

echo "Removing output folder..."
[ -d "output" ] && rm -rf "output"

echo "Creating output folder"
mkdir -p "output" || { echo "Failed to create output directory"; exit 1; }

echo "Changing wildcard behaviour..."
shopt -s nullglob

found=0
failed=0

echo "Converting documents..."
for file in *.pdf; do
	found=1
	echo "Converting '$file'..."
	nl
	result="output/${file%.*}.txt"
	pdftotext -enc UTF-8 -layout -bom "$file" "$result" && echo "'$result' saved!" || { echo "Conversion failed!"; failed=1;}
	nl


done

[ "$found" -eq 0 ] && { echo "No documents found!"; exit 1; }
[ "$failed" -eq 1 ] && exit 1
sleep 10