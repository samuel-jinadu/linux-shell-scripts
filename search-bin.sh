#!/bin/bash
# search a binary for readable text
# search-bin.sh

search_bin() {
  local search_string="$1"
  local target_file="$2"



  # Check if the user provided both arguments
  if [ -z "$search_string" ] || [ -z "$target_file" ]; then
    echo "Usage: $0 <search_string> <file>"
    exit 1
  fi

  # Check if the file exists
  if [ ! -f "$target_file" ]; then
    echo "File '$target_file' not found."
    exit 1
  fi

  mime=$(file -b --mime-type "$target_file" 2>/dev/null)
    if [[ ! "$mime" =~ ^application/ ]]; then
        echo "Skipping non-binary file (MIME: $mime): $target_file" >&2
        exit 1
    fi

  if ! command -v strings &>/dev/null; then
    echo "Error: 'strings' command not found. Install binutils (Linux) or Sysinternals (Windows)."
    exit 1
  fi

  # extract strings and search for the pattern
  strings -o "$target_file" | grep "$search_string"
}


search_bin "$1" "$2"