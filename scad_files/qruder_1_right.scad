
include <../planelib/inspectoer.scad>

RuderCut( 
    zList=[zQList[1],zQList[2],zQList[3]], 
    ptRuder=ptQRuder, 
    hRuder=hQRuder, 
    dSpace=0.4, 
    positiv=true )
    {
        wingSegment( [s(zRuder1),s(zRuder2)], [o(zRuder1),o(zRuder2)] );
    }
    
RuderHorn( 
        dbase=hQRuder * s(zQList[1]),
        pos = o(zQList[1]) + [-ptQRuder.x*s(zQList[1]), +ptQRuder.y*s(zQList[1]), 1],
        h=2
        );

