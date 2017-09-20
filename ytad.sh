#!/bin/bash
# [Y]ou[T]ube [A]lbum [D]isassembler
# 	small script to cut an album made of one file (typically albums downloaded from youtube)
#   into separate files for each song,


### INPUT
# titles
namelist=(
	"title 1"
	"title 2"
	"title 3"
)
# times
timelist=(
	"00:00" # start time
	"01:20"
	"02:45"
	"05:00" # end time
)
# file name of the album (or path)
file="file.mp3"
# string to which the title will be appended
output="artist"


echo "${#timelist[*]}"

### CODE
size=$[ ${#timelist[*]} - 1 ]
if [ $size -ne ${#namelist[*]} ]; then
	echo "error. incoherence between times and titles"
fi


i=0
for ((i=0; i<$size;i++))
do
	divtime=$(echo ${timelist[i]} | tr ":" "\n")

	j=0
	for wrd in $divtime
	do
		divtimelist[j]=$wrd
		j=$[ $j+1 ]
	done
	#echo "$j"


	if [ $j -lt 2 ] || [ $j -gt 3 ]; then
		echo "error in timelist[i]"
		exit 1
	fi

	if [ $j -eq 2 ]
	then
		divtimelist[2]=${divtimelist[1]}
		divtimelist[1]=${divtimelist[0]}
		divtimelist[0]="00"
	fi

	timelist[i]="${divtimelist[0]}:${divtimelist[1]}:${divtimelist[2]}"
	#echo "  ${timelist[i]}"

	next=$[ $i+1 ]
	divtime2=$(echo ${timelist[next]} | tr ":" "\n")

	j=0
	for wrd in $divtime2
	do
		divtimelist2[j]=$wrd
		j=$[ $j+1 ]
	done
	if [ $j -lt 2 ] || [ $j -gt 3 ]; then
		echo "error in timelist[i]"
		exit 1
	fi
	if [ $j -eq 2 ]; then
		divtimelist2[2]=${divtimelist2[1]}
		divtimelist2[1]=${divtimelist2[0]}
		divtimelist2[0]="00"
	fi
	#echo "- ${divtimelist2[0]}:${divtimelist2[1]}:${divtimelist2[2]}"

	sec=$[ ${divtimelist2[2]} - ${divtimelist[2]} ]
	min=$[ ${divtimelist2[1]} - ${divtimelist[1]} ]
	hor=$[ ${divtimelist2[0]} - ${divtimelist[0]} ]
	diff=$[ ($sec) + ($min*60) + ($hor*3600) ]
	#echo "= $diff"

	filename="$output - ${namelist[i]}"
	~/bin/ffmpeg.exe -ss ${timelist[i]} -t $diff -i $file -vn -acodec aac -vbr 5 -crf 10 $filename.aac
done















