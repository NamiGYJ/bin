#!/bin/bash
# prints a list of files and directories who do not exist in the directory
# on the specified harddisk

if [[ $# != 2 ]]; then
	echo "Illegal number of params"
	echo "usage:"
	echo "$0 <dest-hdd-letter> <directory>"
	exit
fi

path=`pwd`
current=${path:1:1}
path=$(echo $path | sed "s%^\(/\)[a-z]%\1$1%")
echo -e "path: $path"
echo

find "$2" | while read file;
do
	if [ ! -e "${path}/$file" ]; then
		echo -e "$file"
	fi
done