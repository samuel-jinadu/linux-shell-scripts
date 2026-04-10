#!/bin/bash


#I got tired of ocr running and slowing down the LLM agents when I upload documents, so I'll just turn them all to text, it should be good enough in my opinion since the LLMs are good at recognising tables and such... maaybe idk

# Automatically detect cores (works on Linux, macOS, Git Bash/Windows)
export NUM_CORES=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

sanitize_filename() {
    local name="$1"
    # Remove everything except ASCII letters, digits, dot, dash, underscore, space
    name=$(echo "$name" | LC_ALL=C tr -cd 'a-zA-Z0-9._ -')
    # ... (rest of cleaning as above)
    echo "$name"
}

export -f sanitize_filename


pdfprep() {
	file=$1
	echo "Converting '$file'..."
	echo ""
	file=$(basename "$file")
	sanitized=$(sanitize_filename "$file")
	newname=$sanitized
	if [[ "$sanitized" == *" -- "* ]]; then
		echo "Renaming file..."
		newname="${sanitized%% -- *}.${sanitized##*.}"
	    mv -n -- "$file" "$newname"
		result="output/${newname%.*}.txt"
		pdftotext -enc UTF-8 -layout -bom -- "$newname" "$result" && echo "'$result' saved!" || { echo "Conversion failed!"; return 1;}
	else
		result="output/${file%.*}.txt"
		pdftotext -enc UTF-8 -layout -bom -- "$file" "$result" && echo "'$result' saved!" || { echo "Conversion failed!"; return 1;}
	fi
	
	echo ""
	
	echo ""
}

export -f pdfprep


[ -d "./pdf-prep" ] && cd "./pdf-prep" || { echo "'pdf-prep' folder not found! Current working directory will be used instead"; }

echo "Removing output folder..."
[ -d "output" ] && rm -rf "output"

echo "Creating output folder"
mkdir -p "output" || { echo "Failed to create output directory"; exit 1; }

echo "Checking for pdfs..."
compgen -G "*.pdf" > /dev/null || { echo "No documents found!"; exit 1; }

if ! command -v pdftotext &> /dev/null; then
	echo "ERROR: pdftotext not found! Install poppler-utils."
	exit 2
fi


echo "Converting documents..."

printf '%s\0' *.pdf | xargs -0 -n 1 -P "$NUM_CORES" bash -c 'pdfprep "$1"' _

xargs_exit=$?
if [ $xargs_exit -ne 0 ]; then
	echo "ERROR: Some conversions failed (exit code: $xargs_exit)"
	sleep 60
	exit 1
fi

echo "All conversions completed!"
