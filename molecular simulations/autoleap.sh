#!/bin/bash
AMBERHOME=/opt/amber16
source $AMBERHOME/amber.sh
addparam_dir=../out
out_dir=./
lig_dir=../out
for f in $addparam_dir/*.mol2; do
    b=`basename $f .mol2`
    echo building parameters of $b
    cat > leap-${b}.in << EOF
source leaprc.gaff
source leaprc.water.tip3p
loadamberparams $addparam_dir/${b}.frcmod
lig = loadmol2 $f
PBradii = mbondi3
saveamberparm lig $out_dir/${b}_dry.prmtop $out_dir/${b}_dry.rst
solvateoct lig TIP3PBOX 20.0 iso
##addionsrand lig Na+/Cl- 0
saveamberparm lig $out_dir/${b}_solvated.prmtop $out_dir/${b}_solvated.rst
quit
EOF
   $AMBERHOME/bin/tleap -f leap-${b}.in
done
exit
