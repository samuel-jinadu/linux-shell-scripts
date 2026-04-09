#!/bin/bash

nl () {
	echo ""
}

#I got tired of ocr running and slowing down the LLM agents when I upload documents, so I'll just turn them all to text, it should be good enough in my opinion since the LLMs are good at recognising tables and such... maaybe idk

# Automatically detect cores (works on Linux, macOS, Git Bash/Windows)
export NUM_CORES=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

pdfprep() {
	file=$1
	echo "Converting '$file'..."
	nl
	result="output/${file%.*}.txt"
	pdftotext -enc UTF-8 -layout -bom "$file" "$result" && echo "'$result' saved!" || { echo "Conversion failed!"; exit 2;}
	nl
	if [[ "$file" == *" -- "* ]]; then
		echo "Renaming file..."
		newname="${file%% -- *}.${file##*.}"
	    mv -- "$file" "$newname"
	fi
	nl
}

export -f pdfprep


[ -d "./pdf-prep" ] && cd "./pdf-prep" || { echo "'pdf-prep' folder not found! Current working directory will be used instead"; }

echo "Removing output folder..."
[ -d "output" ] && rm -rf "output"

echo "Creating output folder"
mkdir -p "output" || { echo "Failed to create output directory"; exit 1; }

echo "Checking for pdfs..."
compgen -G "*.pdf" > /dev/null || { echo "No documents found!"; exit 1; }


echo "Converting documents..."

printf '%s\0' *.pdf | xargs -0 -n 1 -P "$NUM_CORES" bash -c 'pdfprep "$1"' _

