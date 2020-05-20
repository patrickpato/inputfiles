#!/bin/bash
LC_NUMERIC="en_US.UTF-8"
> try
for i in `seq -w 3.5 0.05 4.5`
do
cd $i
free_ene=`grep 'FreeEng = ' BaTiO3.out | cut -d = -f 2`
echo $i' '$free_ene   >> ../try
cd ..
done
awk '{print ($1) "\t" ($3)}'   try > alat_ene.dat
rm try


