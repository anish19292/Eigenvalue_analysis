#!/bin/bash
AMBERHOME=/opt/amber18
source $AMBERHOME/amber.sh
EXE=$AMBERHOME/bin/pmemd.cuda
EXE2=$AMBERHOME/bin/ambpdb
## Re-minimzation of LAST MD frame
for f in ../MDs/*_prod.rst; do
    b=`basename $f _prod.rst`
    echo Optimizing $b
    $EXE -O -i ../protocol/remin.in -o ${b}_min.out -p ../sys/${b}_solvated.prmtop -c $f -r ${b}_min.rst
done
### Converting PDB files
for f in ./*_min.rst; do
    b=`basename $f _min.rst`
    echo Converting $b
    $EXE2 -nobox -p ../sys/${b}_solvated.prmtop -c $f >${b}_min.pdb
done
for f in ./*_min.pdb; do
    b=`basename $f _min.pdb`
    echo converting $b
    awk '/UNK/ {print}' $f > ./${b}_FINAL.pdb
done
echo "YOUR FILES FOR EVANS"
exit
