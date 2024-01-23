#!/bin/bash
AMBERHOME=/opt/amber16
source $AMBERHOME/amber.sh
EXE=$AMBERHOME/bin/pmemd.cuda
min=../protocol/min.in
heat=../protocol/heat.in
density=../protocol/density.in
prod=../protocol/prod.in
for f in ../sys/*_solvated.prmtop; do
    b=`basename $f _solvated.prmtop`
    echo Minimizing system $b
    $EXE -O -i $min -o ${b}_min.out -p $f -c ../sys/${b}_solvated.rst -r ${b}_min.rst -ref ../sys/${b}_solvated.rst
done
for f in ../sys/*_solvated.prmtop; do
    b=`basename $f _solvated.prmtop`
    echo heating system $b
    $EXE -O -i $heat -o ${b}_heat.out -p $f -c ./${b}_min.rst -r ${b}_heat.rst -ref ./${b}_min.rst -x ${b}_heat.nc
done
for f in ../sys/*_solvated.prmtop; do
    b=`basename $f _solvated.prmtop`
    echo density setting system $b
    $EXE -O -i $density -o ${b}_den.out -p $f -c ./${b}_heat.rst -r ${b}_den.rst -x ${b}_den.nc
done
for f in ../sys/*_solvated.prmtop; do
    b=`basename $f _solvated.prmtop`
    echo running prod for system $b
    $EXE -O -i $prod -o ${b}_prod.out -p $f -c ./${b}_den.rst -r ${b}_prod.rst -x ${b}_prod.nc
done
exit

