
include <../planelib/inspectoer.scad>

RuderWingCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
	wingSegment( [s(zBoom),s(zRuder1+90)], [o(zBoom),o(zRuder1+90)] );
}
