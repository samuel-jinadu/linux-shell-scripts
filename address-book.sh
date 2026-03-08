#!/bin/bash

# It should use functions to perform the required tasks. It should be menu-based, allowing you the options of:

# ADDRESS_FILE contents look like this
# John Doe:08022343234:john.doe@gmail.com
# John Smith:08167365432:john.smith@example.com

# Search address book
# ./address-book.sh -s "John Doe"
# found "John Doe"!
# Name: John Doe; Phone Number: 08123454378; Email Address: john.doe@gmail.com 

# ./address-book.sh 08123454378
# found "08123454378"!
# Name: John Doe; Phone Number: 08123454378; Email Address: john.doe@gmail.com

# ./address-book.sh "Mary Jane"
# "Mary Jane" Not found!



# # Add entries
# ./address-book.sh -a 


# Remove entries
# ./address-book.sh -r "John"


# edit entries
# ./address-book.sh -e "John Doe|Jane Doe"

# You will also need a "display" function to display a record or records when selected.

ADDRESS_FILE="./address-book.txt"

usage() {
    echo "Usage:"
    echo "  $0 [-a]                    # Add a new contact (interactive)"
    echo "  $0 [-r 'search term']             # Remove contact by name or phone or email"
    echo "  $0 [-e 'old name|new name'] # Edit contact name"
    echo "  $0 'search term'            # Search by name or phone or email"
    echo "  $0                          # Displays entire address book (default action)"
    exit 1
}


input () {
	echo -n "Full Name: " >&2; read name;
	echo -n "Phone Number: " >&2; read no;
	echo -n "Email Address: " >&2; read email;
	echo "$name:$no:$email"
}

safe_append() {
    local file="$1"
    local text="$2"

    # If file exists, is not empty, and does NOT end with newline
    if [ -s "$file" ] && [ "$(tail -c1 "$file" | wc -l)" -eq 0 ]; then
        printf '\n' >> "$file"
    fi
    printf '%s\n' "$text" >> "$file"
}

display() {
	local content
	content=$(cat "$ADDRESS_FILE")
	echo "$content" | awk -F: '{ printf "Name: %s; Phone Number: %s; Email Address: %s\n", $1, $2, $3 }'
}



add() {
	local entry
	entry=$(input)
	while [[ ! $entry =~ ^[^:]+:[0-9]+:[^@]+@[^@]+\.[^@]+$ ]]; do
		echo "Invalid input, try again!"
		entry=$(input)
	done
	echo -n "Do you want to add '$entry' (y/n): "; read enter;
	if [[ "$enter" == [yY] || "$enter" == [yY][eE][sS] ]]; then
    	safe_append "$ADDRESS_FILE" "$entry"
		echo
		tail -3 "$ADDRESS_FILE"
	fi
	


}



search () {
	local results
	local search_term
	search_term="$1"
	results=$(grep "$search_term" $ADDRESS_FILE)
	if [[ -z "$results" ]]; then
    	echo "No matches found!"
	else
	    echo "Found '$1'!"
	    echo
		# Format each line with awk
        echo "$results" | awk -F: '{ printf "Name: %s; Phone Number: %s; Email Address: %s\n", $1, $2, $3 }'
	fi
	
}


remove() {
	local search_term
	search_term="$1"
	search "$search_term"
	echo -n "Do you want to delete the above (y/n): "; read delete;
	if [[ "$delete" == [yY] || "$delete" == [yY][eE][sS] ]]; then
    	sed -i "/$search_term/d" $ADDRESS_FILE
	fi
	
}


edit () {
	local old
	local new
	old=$1
	new=$2
	echo -n "Do you want to change '$old' to '$new' (y/n): "; read change;
	if [[ "$change" == [yY] || "$change" == [yY][eE][sS] ]]; then
    	sed -i.temp "s/$old/$new/" $ADDRESS_FILE
	fi
	
}

if [[ $# = 0 ]]; then
	display
	exit
elif [[ $# -ge 1 && $1 != -* ]]; then
    # All arguments are the search term (join them)
    search_term="$*"
    search "$search_term"
	exit
fi


while getopts "s:ar:e:" opt; do
    case $opt in
        s)
            search_term="$OPTARG"
            search "$search_term"
            ;;
        a)
            add
            ;;
        r)
            remove "$OPTARG"
            ;;
        e)
			old=$(echo "$OPTARG" | cut -d'|' -f1)
			new=$(echo "$OPTARG" | cut -d'|' -f2)
			if [[ -z "$old" || -z "$new" ]]; then
				echo "Invalid syntax!"
				usage
			fi
			edit "$old" "$new"
            ;;
        \?)
            echo "ERROR: Invalid option -$OPTARG" >&2
            usage
            ;;
        :)
            echo "ERROR: Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done


shift $((OPTIND-1))
if [ $# -gt 0 ]; then
    echo "ERROR: Unexpected arguments: $*" >&2
    usage
fi