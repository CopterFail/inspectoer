
include <../planelib/inspectoer.scad>

mirror([0,1,0])
wingSegment( [s[1],s[2]], [o[1],o[2]], do = 0 );
