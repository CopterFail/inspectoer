
include <../planelib/inspectoer.scad>

mirror([0,0,1]){
Ruder2( ptStart=[-p1.x+o1,+p1.y,z1], dStart=d1, ptStop=[-p2.x+o2,+p2.y,z2], dStop=d2, dSpace=0.8, steps=5 )
    union(){
        *wingSegment( [s[3],s[4]], [o[3],o[4]] ); // was last segment
        wingSegment( [s[2],s[3]], [o[2],o[3]] );
        *wingSegment( [s[1],s[2]], [o[1],o[2]] );
        *wingSegment( [s[0],s[1]], [o[0],o[1]] );
        }
RuderHorn( dbase=d1, pos = o[2] + [-ptQRuder.x*s[2], +ptQRuder.y*s[2], 0]  ); /*dSpace is 0.8*/         
}

