
include <../planelib/inspectoer.scad>

RuderCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
    intersection(){
		wingSegment( [s(zRuder1),s(zRuder2)], [o(zRuder1),o(zRuder2)] ); // the complete ruder part
        RuderCutBox( p1 = QRPoints(zBase, ptQRuder)[0], p2 = QRPoints(zRuder1+zRuderDist, ptQRuder)[0] ); // cut upper side only
        }
}

RuderHorn( 
        dbase=hQRuder * s(zQList[1]),
        pos = o(zQList[1]) + [-ptQRuder.x*s(zQList[1]), +ptQRuder.y*s(zQList[1]), -2-0.4],
		rot = [0,+9.58,0],
        h=2
        );

