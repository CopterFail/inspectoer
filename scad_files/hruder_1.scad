
include <../planelib/inspectoer.scad>

Slice(){
    HRuder1();
    translate([-420-130,-75,zHList[0]]) cube([150,150,zHList[2]-zHList[0]]);
    }

