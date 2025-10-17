
include <../planelib/inspectoer.scad>

mirror([0,0,1])
{
RuderCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
	wingSegment( [s(zRuder1+zRuderDist),s(zRuder2)], [o(zRuder1+zRuderDist),o(zRuder2)] );
}
}

