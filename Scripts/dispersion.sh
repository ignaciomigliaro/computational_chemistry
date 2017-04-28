#!/bin/bash
#Codigo para utilizar newzmat en Gaussian
#Ignacio Migliaro 2017

echo "Filename" 
read NOMBRE
/home/gaussian/g09/newzmat -ichk -oxyz -step 1 $NOMBRE $NOMBRE 
 sed -i '1s/^/109\nTITULO\n/' $NOMBRE.xyz

echo "Which density functional do you want to use?"
read FUNC 
DIR=$NOMBRE.xyz
~/dftd3 $DIR -func $FUNC -zero > $NOMBRE.d3
tail -100 $NOMBRE.d3
