include <inspectoer.scad>

//solid:
*wingSolid();
*wingSegment([s(zBase),s(zBow)], [o(zBase),o(zBow)]);

//the right wing in 4 parts + ruder in 2 parts:
*wingSegment( [s(zBase),s(zBoom)], [o(zBase),o(zBoom)] ); // (no ruder)

//up(10)
*RuderWingCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
    intersection(){
        union(){
            wingBow( draw=true );
            wingSegment( [s(zRuder1+zRuderDist),s(zBow)], [o(zRuder1+zRuderDist),o(zBow)] );
            }
        RuderCutBox( p1 = QRPoints(zRuder2, ptQRuder)[0], p2 = QRPoints(zBow+100, ptQRuder)[0] ); // cut lower side only
        }
    }

//left(10) 
*RuderCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
    intersection(){
        wingSegment( [s(zRuder1),s(zBow)], [o(zRuder1),o(zBow)] );
        RuderCutBox( p1 = QRPoints(zRuder1+zRuderDist, ptQRuder)[0], p2 = QRPoints(zRuder2, ptQRuder)[0] ); // cut lower and upper side
        }
}

*RuderWingCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
    intersection(){
        wingSegment( [s(zRuder1),s(zRuder2)], [o(zRuder1),o(zRuder2)] ); // the complete ruder part
        RuderCutBox( p1 = QRPoints(zRuder1+zRuderDist, ptQRuder)[0], p2 = QRPoints(zRuder2, ptQRuder)[0] ); // cut lower and upper side
        }
}

//down(10) left(10)
*RuderCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
    intersection(){
		wingSegment( [s(zRuder1),s(zRuder2)], [o(zRuder1),o(zRuder2)] ); // the complete ruder part
        RuderCutBox( p1 = QRPoints(zBase, ptQRuder)[0], p2 = QRPoints(zRuder1+zRuderDist, ptQRuder)[0] ); // cut upper side only
        }
}

//down(10)
*RuderWingCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
    intersection(){
		wingSegment( [s(zBoom),s(zRuder2)], [o(zBoom),o(zRuder2)] );
        RuderCutBox( p1 = QRPoints(zBase, ptQRuder)[0], p2 = QRPoints(zRuder1+zRuderDist, ptQRuder)[0] ); // cut upper side only
        }
}

*RuderHorn( 
        dbase=hQRuder * s(zQList[1]),
        pos = o(zQList[1]) + [-ptQRuder.x*s(zQList[1]), +ptQRuder.y*s(zQList[1]), -2-0.4],
		rot = [0,+9.58,0],
        h=2
        );
*mirror([0,0,1]) ServoDiff(pos=wingservopos+[150,0,0],rot=wingservorot);

*fuseSolid();  
*fuseBattery();
*#translate([fuseLength0-40,1.5+fuseY0,0]) fuseCamera2( ang=0, open=false );
*CamPan();
*left(60) xrot(180) bottom_half() fuseCamera3();
*top_half() fuseCamera3();

*fusePoly();
*translate([335,0,50]) spant3d( d=0.3, offset=[0,0,0],    size=605,   r=0, p=pClarkFuse );
*fuseCoverFront(d=0);
*fuseCoverHook( true );
*fuseCoverHook( false );
*translate([20,35,0]) rotate([90,90,0]) fuseCoverHookKnop2();
*fuseSegment([3]);
*fuseSegment([0,1,2,3]);
*import("../stl_files/body_3.stl");
*translate([10,0,0])  color("Red") cube([75,45,45],center=true); // akku
*color("Green") fuseCoverFront();
*color("Green") fuseCoverFrontVtx();
*color("Green") fuseCoverMid();
*color("Green") fuseCoverBak();
*fuseSkid2( r=0.1 );
*fuseCoverMount_1()

*tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 );
*tubeFlansh();
wingConnect();
*wingElectric();

*Ruder1();
*HRuder2();
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
