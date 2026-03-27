#!/bin/bash

nl () {
	echo ""
}

[ -d "./docx-to-epub" ] && cd "./docx-to-epub" || { echo "'docx-to-epub' folder required!"; exit 1; }

echo "Removing output folder..."
[ -d "output" ] && rm -rf "output"

echo "Creating output folder"
mkdir -p "output" || { echo "Failed to create output directory"; exit 1; }

echo "Changing wildcard behaviour..."
shopt -s nullglob

found=0

echo "Converting documents..."
for file in *.docx *.pdf; do
	found=1
	echo "Converting '$file'..."
	nl
	
	result_epub="output/${file%.*}.epub"
	result_pdf="output/${file%.*}.pdf"
	case "$file" in
		*.docx )  ebook-convert "$file" "$result_epub" --title "${file%.*}"  && echo "'$result_epub' saved!" || echo "Conversion failed!" ;;
		*.pdf)    ebook-convert "$file" "$result_epub" --title "${file%.*}"  --enable-heuristics --linearize-tables --dont-split-on-page-breaks --flow-size 0 --no-chapters-in-toc --max-toc-links 0   && echo "'$result_epub' saved!" || echo "Conversion failed!"
			;;
	esac
	nl
	[[ "$file" == *.pdf ]] || { ebook-convert "$file" "$result_pdf" && echo "'$result_pdf' saved!" || echo "Conversion failed!"; }
	nl
	cp "$file" "output/"

done

[ "$found" -eq 0 ] && echo "No documents found!"
sleep 10