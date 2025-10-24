
include <../planelib/inspectoer.scad>

mirror([0,0,1])
RuderWingCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
    intersection(){
        wingSegment( [s(zRuder1),s(zRuder2)], [o(zRuder1),o(zRuder2)] ); // the complete ruder part
        RuderCutBox( p1 = QRPoints(zRuder1+zRuderDist, ptQRuder)[0], p2 = QRPoints(zRuder2, ptQRuder)[0] ); // cut lower and upper side
        }
}
