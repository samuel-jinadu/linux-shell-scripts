#!/bin/bash
# lists all non-hidden directories and files 

doindent()
{
  # Do a small indent depending on how deep into the tree we are
  # Depending on your enviroment, you may need to use
  # echo "  \c" instead of
  # echo -en "  "
    j=0;
    while [ "$j" -lt "$1" ]; do
      echo -en "  " 
      j=$(($j + 1))
    done
}

traverse () {
	local location
	local indent
	location="$1"
	indent="$2"
	
	cd "$location" || { echo "Issue: '$location' not found or not accessible!"; return; }
	for i in * ; do
    	# Skip the special entries . and ..
    	[ "$i" = "." ] || [ "$i" = ".." ] && continue
    	[ -L "$i" ] && continue
    	[ ! -e "$i" ] && continue   # Skip non‑existent entries (e.g., '*' from empty dir)
		doindent "$indent"

		size=$(stat -c %s "$i" 2>/dev/null)
        # If stat fails (e.g., permission denied), show '?'
        if [[ -n $size ]]; then
		    size_display=$(numfmt --to=iec-i --suffix=B "$size" 2>/dev/null || echo "${size}B")
		else
		    size_display='not found!'
		fi
		
		if [[ -d "$i" ]]; then
			echo "Directory: $i (size: $size_display)"
			(traverse "$i" $(("$2" + 1)))
		else
			echo "File: $i (size: $size_display)"
		fi
	done
}
if [[ -z $1 ]]; then
	traverse . 0
else
	traverse "$1" 0
fi