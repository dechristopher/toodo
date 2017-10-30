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
	cols=$(tput cols)
	cols=$((cols+18))
	fmt='%-'
	fmt+=$cols
	fmt+='s'
	printf $fmt "$GRAYBG$BLACK  TOODO v0.1$NORMAL"
	printf "$NORMBG\n"
}

# Process files
while true; do
	find "$DIR" -name "$TYPES" -type f | while read file; do
		todoresults=$(grep -e '#TODO' -e '# TODO' -e '//TODO' -e '// TODO' "$file");
        fixmeresults=$(grep -e '#FIXME' -e '# FIXME' -e '//FIXME' -e '// FIXME' "$file");
		if [ -n "$todoresults" ]; then
			# TODO: Make this easier to read, use the color codes
			printf "\n[ \e[1m\e[32m$file\e[0m\e[39m ]\n"
			echo "$todoresults" | tr -d '\011' | awk '{print $NF}' FS=/ | awk '{print $NF}' FS=#
			echo "$fixmeresults" | tr -d '\011' | awk '{print $NF}' FS=/ | awk '{print $NF}' FS=#
		fi
	done > .todos;

	# Clear scrollback
	printf "\033c";

	# Render header bar
	header

	# Render TODOs and FIXMEs
	cat .todos && rm .todos;

	# Repeat in five seconds
	sleep 5;
done;

