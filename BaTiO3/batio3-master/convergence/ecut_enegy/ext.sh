#!/bin/bash
> try
for i in `seq -w 50 50 800`
do
cd $i
free_ene=`grep 'FreeEng = ' BaTiO3.out | cut -d = -f 2`
echo $i' '$free_ene   >> ../try
cd ..
done
awk '{print ($1) "\t" ($3)}'   try > ecut.dat
rm try


