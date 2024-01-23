#ask the user for the extension
puts -nonewline "\n Enter the structure file extention:pdb/mae(NOT maegz)/mol2:  "
gets stdin extn
if {$extn == "maegz"} { 
puts "maegz files are not recognized by VMD"
} else {
set type $extn

set strs [glob *.$extn]
foreach str $strs {
set filename [file rootname $str]
puts $filename
mol load $type $str	
set sel [atomselect top all]
puts [measure center $sel]
set centMolx [lindex [measure center $sel] 0]
set centMoly [lindex [measure center $sel] 1]
set centMolz [lindex [measure center $sel] 2]
set atoms [$sel get serial]
set discent [open $filename.dis w]


foreach atom1 $atoms {
set atom1sel [atomselect top "serial $atom1"]
set atom1name [$atom1sel get name]
set atom1x [$atom1sel get x]
set atom1y [$atom1sel get y]
set atom1z [$atom1sel get z]
foreach atom2 $atoms {
set atom2sel [atomselect top "serial $atom2"]
set atom2name [$atom2sel get name]
set atom2x [$atom2sel get x]
set atom2y [$atom2sel get y]
set atom2z [$atom2sel get z]

#check condition
set pattern "$atom2\_$atom2name\:$atom1\_$atom1name"
set count 0

set discent [open $filename.dis r]
while {[gets $discent line] != -1} {
    incr count [regexp -all -- $pattern $line]
}
close $discent

if {("$atom1"!="$atom2") && ("$count"=="0")} {

#find bond centroid
set selBond [atomselect top "serial $atom1 or serial $atom2"]
puts [measure center $selBond]
set centBondx [lindex [measure center $selBond] 0]
set centBondy [lindex [measure center $selBond] 1]
set centBondz [lindex [measure center $selBond] 2]

set dx [expr ($centBondx -$centMolx)]
set dx2 [expr pow($dx,2)]

set dy [expr ($centBondy -$centMoly)]
set dy2 [expr pow($dy,2)]

set dz [expr ($centBondz -$centMolz)]
set dz2 [expr pow($dz,2)]
set discent [open $filename.dis a]
set distance [expr sqrt ($dx2 + $dy2 + $dz2)]
puts $discent  "$atom1\_$atom1name\:$atom2\_$atom2name\ $distance"
close $discent 
}
}	
}

set mol_IDs [molinfo list]

foreach mol_ID $mol_IDs {
mol delete $mol_ID
}
 
}
}
