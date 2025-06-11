
include <../planelib/inspectoer.scad>

mirror([0,0,1])
{
wingSegment( [s(zRuder2),s(zBow)], [o(zRuder2),o(zBow)] ); // (no ruder)
wingBow( draw=true );
}
