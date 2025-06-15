
include <../planelib/inspectoer.scad>

Slice(){
    HRuder2();
    translate([-420-130,-75,zHList[2]+0.4-200]) cube([150,150,200-0.01]); /* why is the 0.01 correction needed to avoid warnings? */
    }

