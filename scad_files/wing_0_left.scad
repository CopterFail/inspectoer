
include <../planelib/inspectoer.scad>

mirror([0,1,0])
*wingSegment( [s[0],s[1]], [o[0],o[1]], do = 2 );
wingConnectCut();
