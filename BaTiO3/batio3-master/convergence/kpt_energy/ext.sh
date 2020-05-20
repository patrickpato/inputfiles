#!/bin/bash
> try
for i in `seq -w 2 1 24`
do
cd $i
free_ene=`grep 'FreeEng = ' BaTiO3.out | cut -d = -f 2`
echo $i' '$free_ene   >> ../try
cd ..
done
awk '{print ($1) "\t" ($3)}'   try > kpoint.dat
rm try


