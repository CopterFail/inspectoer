include <../planelib/inspectoer.scad>

mirror([0,0,1])
{
    wingSegment( [s[0],s[1]], [o[0],o[1]] ); // copy the code of wing_0_right_scad
}