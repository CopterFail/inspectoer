include<inspectoer.scad>

// Dokmentation:
*exploreWing();
*exploreFuse();
*exploreTail();
*complete();

module wing( v=[0,0,0]){

    show(v){
        // wing ordered from the root to the tip
        wingSegment( [s(zBase),s(zBoom)], [o(zBase),o(zBoom)] ); // (no ruder)
        RuderWingCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
            wingSegment( [s(zBoom),s(zRuder1+zRuderDist)], [o(zBoom),o(zRuder1+zRuderDist)] );
            }
        translate([-2*v.z,0,0])union(){
            RuderCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
                wingSegment( [s(zRuder1),s(zRuder1+zRuderDist)], [o(zRuder1),o(zRuder1+zRuderDist)] );
                }
            RuderHorn( 
                    dbase=hQRuder * s(zQList[1]),
                    pos = o(zQList[1]) + [-ptQRuder.x*s(zQList[1]), +ptQRuder.y*s(zQList[1]), -2-0.4],
                    h=2
                    );
            RuderCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
                wingSegment( [s(zRuder1+zRuderDist),s(zRuder2)], [o(zRuder1+zRuderDist),o(zRuder2)] );
                }
            }
        wingConnect();
        RuderWingCut( zList=zQList, ptRuder=ptQRuder, hRuder=hQRuder, dSpace=0.4, positiv=true ){
            wingSegment( [s(zRuder1+zRuderDist),s(zRuder2)], [o(zRuder1+zRuderDist),o(zRuder2)] );
        }
        wingSegment( [s(zRuder2),s(zBow)], [o(zRuder2),o(zBow)] ); // (no ruder)
        wingBow( draw=true );
        }
}

module complete()
{

//view: [ -138.68, -75.77, 45.99 ] [ 142.00, 35.00, 175.90 ] 1754.01 22.50


    wing();
    mirror([0,0,1]){
        wing();
        }
        
    fuseSegment( [0,1,2,3] );
    wingMotor();
    wingMotorPlate();
    mirror([0,0,1]) wingMotor();
    mirror([0,0,1]) wingMotorPlate();

    color("Red") fuseSkid( r=-0.5 ){ fuseSolid( seg=10, r=0 ); fuseSolid( seg=10, r=SkidWall ); };
    color("GhostWhite") fuseCoverFront();
    color("GhostWhite") fuseCoverMid();
    color("GhostWhite") fuseCoverBak();
    
    tail(); 
}

module exploreFuse()
{
    show([20,0,0]){
        *fuseMotor( d=0.5, holes=true);
        fuseSegment( [0] );
        union(){
            fuseSegment( [1] );
            translate( [0,50,0]) color("GhostWhite") fuseCoverBak();
            }
        fuseSegment( [2] );
        translate( [0,50,0]) color("GhostWhite") fuseCoverMid();
        color("Red") translate( [0,-50,0]) fuseSkid( r=-0.5 );
        fuseSegment( [3] );
        translate( [0,50,0]) color("GhostWhite") fuseCoverFront();
    }
}

module exploreWing()
{
    wing([0,0,20]);

    *translate([-20,0,0]) exploreFuse();
    *union(){
        wingMotor();
        wingMotorPlate();
        }

    *union(){
        translate([tubeOffset2-260,-8,zBoom]) 
            rotate([0,90,0])  
                cylinder(d=dBar1, h=440, center=true);
        tubeFlansh2();
        HRuder();
        sideSolid(r=0);
        }

    color("Black") xTube( diameter=8, length=1000, tubeoffset=tubeOffset1 );
    color("Black") xTube( diameter=6, length=400, tubeoffset=tubeOffset2 );
}

module exploreTail() 
{
    translate([0,0,0]) HRuder1();
    translate([-40,0,0]) HRuder2();
    
    translate([0,40,40]) mirror([0,0,1]) sideSolid();
    translate([0,40,-40]) sideSolid();
    
    translate([0,-40,40]) tubeFlansh2();
    translate([0,-40,-40]) mirror([0,0,1]) tubeFlansh2();

    //if($preview){
    color( "BLACK") translate([-40, tailz0-40, +zBoom+40]) rotate([0,-90,0]) cylinder(d=8,h=450);
    color( "BLACK") translate([-40, tailz0-40 ,-zBoom-40]) rotate([0,-90,0]) cylinder(d=8,h=450);
    //}
}

