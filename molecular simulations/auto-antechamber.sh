#!/bin/bash
AMBERHOME=/opt/amber16
source $AMBERHOME/amber.sh
ANTE_CHAMBER=$AMBERHOME/bin/antechamber
lig_charges=0
verbose_opt=2
charge_cal=bcc
iFORM=pdb
oFORM=mol2
out_dir=./
for f in ../ligs/*.pdb; do
    b=`basename $f .pdb`
    echo Running ANTECHAMBER $b
    $ANTE_CHAMBER -i $f -fi $iFORM -o $out_dir/${b}.$oFORM -fo $oFORM -nc $lig_charges -c $charge_cal -s $verbose_opt
    $AMBERHOME/bin/parmchk2 -i $out_dir/${b}.$oFORM -f $oFORM -o $out_dir/${b}.frcmod
done
exit
