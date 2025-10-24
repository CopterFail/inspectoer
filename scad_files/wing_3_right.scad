
include <../planelib/inspectoer.scad>

RuderWingCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
    intersection(){
        union(){
            wingBow( draw=true );
            wingSegment( [s(zRuder1+zRuderDist),s(zBow)], [o(zRuder1+zRuderDist),o(zBow)] );
            }
        RuderCutBox( p1 = QRPoints(zRuder2, ptQRuder)[0], p2 = QRPoints(zBow+100, ptQRuder)[0] ); // cut lower side only
        }
    }
