include <inspectoer.scad>

//solid:
*wingSolid();

*difference(){
    Ruder3( ptStart=[-p1.x+o1,+p1.y,z1], dStart=d1, ptStop=[-p2.x+o2,+p2.y,z2], dStop=d2, dSpace=0.8, steps=5 )
        union(){
            *wingSegment( [s[2],s[3]], [o[2],o[3]] );
            *wingSegment( [s[1],s[2]], [o[1],o[2]] );
            wingSegment( [s[0],s[1]], [o[0],o[1]] );
            }
    RuderHorn( dbase=d1, pos = o[2] + [-ptQRuder.x*s[2], +ptQRuder.y*s[2], 0], diff=0.2  ); /*dSpace is 0.8*/         
}

*wingSegment( [s[0],s[3]], [o[0],o[3]] ); // complete wing in one call

tp1 = [-p1.x+o1,+p1.y,z1]; // z1 is start of ruder , 280
tp4 = [-p2.x+o2,+p2.y,z2]; // z2 is end of ruder , 530
tp2 = (tp4-tp1)*0.25 + tp1; // todo: sync with cut , 350 -> 460
tp3 = (tp4-tp1)*0.75 + tp1;
*RuderWingCut( pts=[tp1,tp2,tp3,tp4], hgt=[d1,d1-0.25*(d1-d2),d1-0.75*(d1-d2),d2], dSpace=0.4, positiv=true ){
	wingSegment( [s[0],s[3]], [o[0],o[3]] );
	*wingSegment( [s[1],s[2]], [o[1],o[2]] );
}

*left(60)
RuderCut( pts=[tp1,tp2,tp3,tp4], hgt=[d1,d1-0.25*(d1-d2),d1-0.75*(d1-d2),d2], dSpace=0.4, positiv=true ){
	wingSegment( [s[0],s[3]], [o[0],o[3]] );
	*wingSegment( [s[1],s[2]], [o[1],o[2]] );
}

*RuderHorn( dbase=d1, pos = o[2] + [-ptQRuder.x*s[2], +ptQRuder.y*s[2], 0]  ); /*dSpace is 0.8*/         

*wingBow( draw=true );
*translate(v = [0,30,0]) wingBow( draw=false );

*fuseSolid();  
*fuseBattery();
translate([fuseLength0-40,1.5+fuseY0,0]) fuseCamera2( ang=45, open=false );

*fusePoly();
*translate([335,0,50]) spant3d( d=0.3, offset=[0,0,0],    size=605,   r=0, p=pClarkFuse );
*fuseCoverFront(d=0);
*fuseCoverHook( true );
*fuseCoverHook( false );
*translate([20,35,0]) rotate([90,90,0]) fuseCoverHookKnop();
fuseSegment([3]);
*fuseSegment([0,1,2,3]);
*translate([10,0,0])  color("Red") cube([75,45,45],center=true); // akku
*color("Green") fuseCoverFront();
*color("Green") fuseCoverMid();
*color("Green") fuseCoverBak();
*fuseSkid2( r=0.1 );
*fuseCoverMount_1()

*tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 );
*tubeFlansh();
*wingConnect();
*wingElectric();
*HRuder();
*RuderHorn( dh1, pos = [-ptHRuder.x*120, +ptHRuder.y*120, 0] );
*sideSolid();
*tubeFlansh2();
*tail();  
*#fuseCoverHookKnop2( a=10);
*#fuseCoverHookBase2();

// dBar contains 0.4 offset, reduce to 0.2
*translate([-tubeOffset1*s[1]+o[1].x,0,o[1].z-7]) mirror([0,1,0]) tubeConnect( d1=dBar1, d2=dBar1+2-0.2, a=8, w=6 ); 
*translate([-tubeOffset2*s[1]+o[1].x-5,0,o[1].z-7]) mirror([0,1,0]) tubeConnect( d1=dBar1, d2=dBar1+2-0.2, a=8, w=6 );
*xTube( diameter=dBar1, length=lBar1, tubeoffset=tubeOffset1 );
*xTube( diameter=dBar2, length=lBar2, tubeoffset=tubeOffset2 );

*translate([0,-25,0]) color("Red") fuseSkid();
*wingMotor();
*wingMotorPlate();
*fpvPlate();
