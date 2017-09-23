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
file="artist - album (full album).mp4"

# name of the folder in which you want to put it (album)
album="album"

# string to which the title will be appended (artist?)
artist="artist"



### CODE ###

# check number of times and number of titles
size=$[ ${#timelist[*]} - 1 ]
if [ $size -ne ${#namelist[*]} ]; then
	echo "error. incoherence between times and titles"
fi
# create the directory
mkdir -p "$artist"
mkdir -p "$artist"/"$album"


# loop for all songs
i=0
for ((i=0; i<$size;i++))
do
	# divide time string in newlines
	divtime=$(echo ${timelist[i]} | tr ":" "\n")

	# loop through the newlines
	j=0
	for wrd in $divtime
	do
		# put each sub-time in a different element of array
		divtimelist[j]=$wrd
		j=$[ $j+1 ]
	done

	# check if we had hh:mm:ss or mm:ss
	if [ $j -lt 2 ] || [ $j -gt 3 ]; then
		echo "error in timelist[i]"
		exit 1
	fi

	# if mm:ss, we need to add "00" for the hours
	if [ $j -eq 2 ]
	then
		divtimelist[2]=${divtimelist[1]}
		divtimelist[1]=${divtimelist[0]}
		divtimelist[0]="00"
	fi

	# element is now without a doubt in hh:mm:ss format
	timelist[i]="${divtimelist[0]}:${divtimelist[1]}:${divtimelist[2]}"

	# do the same for next element in timelist
	next=$[ $i+1 ]
	# divide time string in newlines
	divtime2=$(echo ${timelist[next]} | tr ":" "\n")
	# loop through the newlines
	j=0
	for wrd in $divtime2
	do
		# put each sub-time in a different element of array
		divtimelist2[j]=$wrd
		j=$[ $j+1 ]
	done
	# check if we had hh:mm:ss or mm:ss
	if [ $j -lt 2 ] || [ $j -gt 3 ]; then
		echo "error in timelist[i]"
		exit 1
	fi
	# if mm:ss, we need to add "00" for the hours
	if [ $j -eq 2 ]; then
		divtimelist2[2]=${divtimelist2[1]}
		divtimelist2[1]=${divtimelist2[0]}
		divtimelist2[0]="00"
	fi

	# calculate time difference (song length)
	echo "${divtimelist2[2]} - ${divtimelist[2]}"
	sec=$[ 10#${divtimelist2[2]} - 10#${divtimelist[2]} ]
	min=$[ 10#${divtimelist2[1]} - 10#${divtimelist[1]} ]
	hor=$[ 10#${divtimelist2[0]} - 10#${divtimelist[0]} ]
	tdiff=$[ ($sec) + ($min*60) + ($hor*3600) ]

	# make the filename (artist+title)
	filename="$artist - ${namelist[i]}"

	# just for debugging
	echo ""
	echo "../bin/ffmpeg.exe -ss ${timelist[i]} -t $tdiff -i \"$file\" -vn -c:a flac -crf 1 -metadata title=\"${namelist[i]}\" -metadata track=\"$(( $i+1 ))\" \"$album\"/\"$filename.flac\""
	echo ""
	# ffmpeg command
	../bin/ffmpeg.exe -ss ${timelist[i]} -t $tdiff -i "$file" -vn -c:a flac -vbr 5 -crf 1 \
	-metadata title="${namelist[i]}" \
	-metadata track="$(( $i+1 ))" \
	-metadata artist="$artist" \
	-metadata album="$album" \
	"$artist"/"$album"/"$filename.flac"
done