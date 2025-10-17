
include <../planelib/inspectoer.scad>

RuderCut( 
    zList=zQList, 
    ptRuder=ptQRuder, 
    hRuder=hQRuder, 
    dSpace=0.4, 
    positiv=true )
    {
        wingSegment( [s(zRuder1),s(zRuder1+zRuderDist)], [o(zRuder1),o(zRuder1+zRuderDist)] );
    }
    
RuderHorn( 
        dbase=hQRuder * s(zQList[1]),
        pos = o(zQList[1]) + [-ptQRuder.x*s(zQList[1]), +ptQRuder.y*s(zQList[1]), -2-0.4],
        h=2
        );

