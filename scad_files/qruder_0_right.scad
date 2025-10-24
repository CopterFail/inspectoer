
include <../planelib/inspectoer.scad>

RuderCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
    intersection(){
        wingSegment( [s(zRuder1),s(zBow)], [o(zRuder1),o(zBow)] );
        RuderCutBox( p1 = QRPoints(zRuder1+zRuderDist, ptQRuder)[0], p2 = QRPoints(zRuder2, ptQRuder)[0] ); // cut lower and upper side
        }
}
