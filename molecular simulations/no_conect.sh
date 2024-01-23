#!/bin/bash
for f in *.pdb; do
    b=`basename $f .pdb`
    echo doing $b
    awk '/HETATM/ {print}' $f > ../ligs/${b}.pdb
done
exit
