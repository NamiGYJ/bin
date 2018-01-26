#!/bin/bash
# prints a list of files and directories who do not exist in the directory
# on the specified harddisk

if [[ $# != 2 ]]; then
	echo "Illegal number of params"
	echo "usage:"
	echo "$0 <local-dir> <dist-dir>"
	exit
fi

# append a slash if there is none at the end
dst=`echo $2 | sed "/\/$/! s/\(.*\)/\1\//"`
src=`echo $1 | sed "/\/$/! s/\(.*\)/\1\//"`
echo -e "path: $dst"
echo

find "$1" | while read file;
do
	if [ ! -e "${dst}${file#$src}" ]; then
		echo -e "$file"
	fi
done