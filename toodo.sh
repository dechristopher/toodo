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

# Set up colors
RESTORE="$(echo -en '\033[0m')"
BLACK="$(echo -en '\033[30m')"
NORMAL="$(echo -en '\033[39m')"
GOLD="$(echo -en '\033[00;33m')"
GREEN="$(echo -en '\033[00;32m')"
GRAYBG="$(echo -en '\033[00;47m')"
NORMBG="$(echo -en '\033[00;49m')"

# Check for install command
if [ -n "$1" ] && [ "$1" == "install" ]; then
	printf "[$GOLD TOODO $RESTORE] Installing..."
	sudo cp ./toodo.sh /usr/local/bin/td
	printf "$GREEN Success!$RESTORE\n"
	exit 0
fi

# Set directory to search [ASSUMES '.']
DIR=$1
if [ -z "$DIR" ]; then
	DIR='.'
fi

# Set filetypes [ASSUMES '*.go']
TYPES=$2
if [ -z "$TYPES" ]; then
	TYPES='*.go'
fi

# Set the window title
echo -n -e "\033]0;toodo\007"

# Set header bar function
header ()
{
	printf '%-284s' "$GRAYBG$BLACK  TODO v0.1$NORMAL"
	printf "$NORMBG\n"
}

# Set header bar
#header="$GRAYBG"
#header="$header$BLACK  TOODO v0.1$NORMAL"
#for i in $(seq 12 $COLUMNS)
#for ((i=7;i<=136;i+=1))
#do
#	header="$header "
#done
# Return to normal background
#header="$header$NORMBG\n"

# DEBUG
# header
# exit 0

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

	# Clear scrollback
	printf "\033c";

	# Render header bar
	#echo -en $header
	header

	# Render TODOs and FIXMEs
	cat .todos && rm .todos;

	# Repeat in five seconds
	sleep 5;
done;

