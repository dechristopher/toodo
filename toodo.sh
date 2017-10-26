#! /bin/bash
#
# TOODO
#   __________  ____  ____  ____ 
#  /_  __/ __ \/ __ \/ __ \/ __ \
#   / / / / / / / / / / / / / / /
#  / / / /_/ / /_/ / /_/ / /_/ / 
# /_/  \____/\____/_____/\____/  
#
# Given the current working directory, find all of the files of the  
# type given and search for TODO and FIXME comments in them and return
# a nicely formatted list of those items.
#
# Install: ./toodo.sh install
#
# Usage: td
# Usage: td <dir> <file extension>
#
# td . *.go (searches local directory in .go files) 

# Set directory to search [ASSUMES .]
DIR=$1
if [ -z "$DIR" ]; then
	DIR='.'
fi

# Set filetypes [ASSUMES *.go]
TYPES=$2
if [ -z "$TYPES" ]; then
	TYPES='*.go'
fi

# Set the window title
echo -n -e "\033]0;toodo\007"

# Process files
while true; do
	find "$DIR" -name "$TYPES" -type f | while read file; do
		todoresults=$(grep -i 'TODO' "$file");
        	fixmeresults=$(grep -i 'FIXME' "$file");
		if [ -n "$todoresults" ]; then
			printf "\n[ \e[1m\e[32m$file\e[0m\e[39m ]\n"
			echo "$todoresults" | tr -d '\011' | awk '{print $NF}' FS=/
			echo "$fixmeresults" | tr -d '\011' | awk '{print $NF}' FS=/
			
		fi
	done > .todos;

	# Clear scrollback and render
	printf "\033c";
	cat .todos && rm .todos;
	sleep 5;
done;
