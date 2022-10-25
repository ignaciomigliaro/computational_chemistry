#!/bin/bash

#master to launch molecule builder, remove and send structures, check queue to send more structures
for j in $( ls -d ./molecule/gjf/*/)
do
dir=$j"*.gjf"
for i in $dir
do
rm $i
done
done
/home/im0225/Scripts/neuralnetworks4/moleculebuilder2.1.py
for j in $( ls -d ./molecule/gjf/*/)
do
dir=$j"*.gjf" 
for i in $dir
do
echo $i
g16 $i -l
qcheck=$(qstat | grep im0225 | tail -1 | awk '{print $5}')
status='Q'
sleep 10
while [ "$qcheck" == "$status" ]
do                            
sleep 30
qcheck=$(qstat | grep im0225 | tail -1 | awk '{print $5}')
done
done 
done 
while [ "$(qstat -u im0225)" ]
do
sleep 30m
done 

