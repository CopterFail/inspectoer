
include <../planelib/inspectoer.scad>

mirror([0,0,1])
{
RuderCut( zList=[zQList[0],zQList[1]], ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
	wingSegment( [s(zRuder1),s(zRuder2)], [o(zRuder1),o(zRuder2)] );
}
}

