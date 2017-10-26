#! /bin/bash
# Given the current working directory, find all of the files of the  
# type given and search for TODO and FIXME comments in them and return
# a nicely formatted list of those items.
#
# Usage: todo
# Usage: todo <dir> '*.go' 

# Set directory to search ASSUMES .
DIR=$1
if [ -z "$DIR" ]; then
    DIR="."
fi

# Set filetypes ASSUMES *.go
TYPES=$2
if [ -z "$TYPES" ]; then
    TYPES='*.go'
fi

# Set the window title
echo -n -e "\033]0;todo\007"

# Process files
while true; do
    find "$DIR" -name "$TYPES" -type f | while read file; do
        results=$(grep -i 'TODO' "$file");
        if [ -n "$results" ]; then
            printf "\n[ \e[1m\e[32m$file\e[0m\e[39m ]\n"
	    echo "$results" | tr -d '\011' | awk '{print $NF}' FS=/
        fi
    done > .todos;

    # Clear scrollback and render
    printf "\033c";
    cat .todos && rm .todos;
    sleep 5;
done;
