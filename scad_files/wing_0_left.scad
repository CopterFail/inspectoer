include <../planelib/inspectoer.scad>

mirror([0,0,1])
{
    wingSegment( [s(zBase),s(zBoom)], [o(zBase),o(zBoom)] ); // (no ruder)
}