
include <../planelib/inspectoer.scad>

RuderCut( zList=[zQList[1],zQList[2],zQList[3]], ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
	wingSegment( [s(zRuder1),s(zRuder2)], [o(zRuder1),o(zRuder2)] );
}
*RuderHorn( dbase=d1, pos = o[2] + [-ptQRuder.x*s[2], +ptQRuder.y*s[2], 0]  ); /*dSpace is 0.8*/         

