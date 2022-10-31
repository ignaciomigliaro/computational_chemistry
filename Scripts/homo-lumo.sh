#!/bin/bash


for i in $(ls *.out)
do

	HL=$(grep -b -1 -i " Alpha  " $i | tail -2 | awk '{print $6}')
	echo $i $HL
done



