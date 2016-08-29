#!/bin/bash

# Christopher Finn 2011 ECE373
# Assignment 2: Unix Scripting for HR Resume Sorter


findkeyword () {
	keyword=`echo $keyword | awk '{print tolower($1)}'`
	file="$2"
        n=0
	IFS=$' ';
	for word in `cat $file`
	do
		word=`echo $word | awk '{print tolower($word)}'`
		if [[ $word =~ .*${keyword}.* ]]
		then 
			n=$(($n+1))
		fi
	done
	return $n
}

scorefile () {
  filename="$1"
  fileshort=`echo $filename | awk -F'/' '{print $NF}'`
  score=0 
  IFS=$'\n';
  for inputLine in `cat ./input.txt`
  do
	keyword=`echo $inputLine | awk -F' ' '{print $1}'`
	weight=`echo $inputLine | awk -F' ' '{print $2}'`
	findkeyword "$keyword" $filename
	score=$(($score+$(($weight * $?))))
  done
	echo "$score $fileshort" >> ./output.temp
}

for xx in `ls submissions/*`
do
	filename=$xx
	scorefile $filename
done

sort -n -r output.temp >> ./output.txt

cat ./output.txt
rm ./output.temp
rm ./output.txt
