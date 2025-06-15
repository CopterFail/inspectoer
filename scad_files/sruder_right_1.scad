
include <../planelib/inspectoer.scad>

Slice(){
    mirror([0,0,1]) sideSolid();
    translate([-420-130,150-200,-200]) cube([150,200,400]); 
    }
