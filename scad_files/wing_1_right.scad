
include <../planelib/inspectoer.scad>

RuderWingCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
    intersection(){
		wingSegment( [s(zBoom),s(zRuder2)], [o(zBoom),o(zRuder2)] );
        RuderCutBox( p1 = QRPoints(zBase, ptQRuder)[0], p2 = QRPoints(zRuder1+zRuderDist, ptQRuder)[0] ); // cut upper side only
        }
}
