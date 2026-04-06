#!/bin/bash
# A script that searches a directory's binary files for a string
# usage: dir-bin-search <search_string> <dir>
# depends on search-bin.sh

dir_bin_search() {
	local search_string=$1
	local directory=$2

	# Check if the user provided both arguments
	if [ -z "$search_string" ] || [ -z "$directory" ]; then
		echo "Usage: $0 <search_string> <directory>"
		exit 1
	fi

	find "$directory" -type f -print0 | while IFS= read -r -d '' file; do
		# Only proceed if MIME type starts with 'application/'
	if file -b --mime-type "$file" | grep -q '^application/'; then
	    filename=$(basename "$file")
        "$(dirname "$0")/search-bin.sh" "$search_string" "$file" | sed "s|^|$filename: |"
	fi
		
    done

}


dir_bin_search "$1" "$2"