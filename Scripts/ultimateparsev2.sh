#!/bin/bash
#Program designed 
#Program designed by Ignacio Migliaro 2017
COUNTER=0
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
p=1
echo "                                           "
echo "                                           "
echo "Welcome to the Gaussian Tasker"
echo "*******************************************"
echo "This program will allow you to keep track of the calculations you are running"
echo "                                             "
echo "Detecting the queue line"
echo "     "
#sleep 3s
QU=$(qstat | grep $(whoami))
if [[($QU)]];
then
	echo "There are files running"
	echo "Your files are: "
	echo "  " 
	echo  $QU
	echo "  "
	sleep 3s 
	echo " " 
else
	echo "                        "
	echo "************************"
	echo "*Your Files are Done!!!*"
	echo "************************"
	echo " "
	sleep 3s
fi 
		DIR=$(pwd)
		if [[ $(ls $DIR/*.log) ]];
		then 
			for i in $(ls $DIR/*.log); 
			do 
			let COUNTER=($COUNTER+1)
			done
			#sleep 3s
			ERROR="ERROR: Calculations did not finish correctly!"
			echo "There are $COUNTER files in the directory"
				echo "===================================================================================================="
			echo "Filename                              H. Corr          G. Corr          E0"
			echo "----------------------------------------------------------------------------------------------------"
		for i in $(ls $DIR/*.log);
		do
		HC=$(cat $i | grep Enthalpy | cut -d "=" -f 2 | cut -d " " -f 19)
		GC=$(cat $i | grep Gibbs | cut -d "=" -f 2 | cut -d " " -f 10)
		SH=$(cat $i | grep "Sum of electronic and Enthalpies" | cut -d "=" -f 2 | cut -d " " -f 11)
		SG=$(cat $i | grep "Sum of electronic and thermal Free Energies" | cut -d "=" -f 2 | cut -d " " -f 8)
		E0=$(cat $i | grep "SCF Done" | tail -1 | cut -d " " -f 8)
		if [[($HC) && $(grep freq $i) ]];  
		then
			printf "%30s ${GREEN} %15s %15s %21s ${NC} \n" $i $HC $GC $E0 
		elif [[ $(grep opt $i) && $(grep "Normal termination of" $i) ]];
		then 
			printf "%30s ${GREEN}           %21s ${NC} \n" $i $E0
		else
			printf "%30s       ${RED} Error: Calculations did not finish correctly! ${NC} \n" $i
		fi 
			done 
					fi 





	
