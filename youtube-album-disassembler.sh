#!/bin/bash


namelist=(
	"title 1"
	"title 2"
)
timelist=(
	"00:00" # start time
	"01:20"
	"02:45"
	"05:00" # end time
)

i=2

divtime=$(echo ${timelist[i]} | tr ":" "\n")

j=0
for wrd in $divtime
do
	divtimelist[j]=$wrd
	j=$[ $j+1 ]
done
echo "$j"

echo "${divtimelist[0]}:${divtimelist[1]}:${divtimelist[2]}"

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

echo "${divtimelist[0]}:${divtimelist[1]}:${divtimelist[2]}"

