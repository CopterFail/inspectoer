
include<inspectoer.scad>



// Dokmentation:
*exploreWing();
*exploreFuse();
*complete();



module complete()
{

//view: [ -138.68, -75.77, 45.99 ] [ 142.00, 35.00, 175.90 ] 1754.01 22.50

    Ruder2( ptStart=[-p1.x+o1,+p1.y,z1], dStart=d1, ptStop=[-p2.x+o2,+p2.y,z2], dStop=d2, dSpace=0.8, steps=7 )
        union(){
            *wingSegment( [s[3],s[4]], [o[3],o[4]] ); // was last segment
            wingBow();
            wingSegment( [s[2],s[3]], [o[2],o[3]] );
            wingSegment( [s[1],s[2]], [o[1],o[2]] );
            wingSegment( [s[0],s[1]], [o[0],o[1]] );
            }
    RuderHorn( dbase=d1, pos = o[2] + [-ptQRuder.x*s[2], +ptQRuder.y*s[2], 0]  ); /*dSpace is 0.8*/    
    wingConnect();     

    
    mirror([0,0,1]){
        Ruder2( ptStart=[-p1.x+o1,+p1.y,z1], dStart=d1, ptStop=[-p2.x+o2,+p2.y,z2], dStop=d2, dSpace=0.8, steps=7 )
            union(){
                *wingSegment( [s[3],s[4]], [o[3],o[4]] ); // was last segment
                wingBow();
                wingSegment( [s[2],s[3]], [o[2],o[3]] );
                wingSegment( [s[1],s[2]], [o[1],o[2]] );
                wingSegment( [s[0],s[1]], [o[0],o[1]] );
                }
        RuderHorn( dbase=d1, pos = o[2] + [-ptQRuder.x*s[2], +ptQRuder.y*s[2], 0]  ); /*dSpace is 0.8*/      
        wingConnect();   
        }
        
    fuseSegment( seg=0 );
    fuseSegment( seg=1 );
    fuseSegment( seg=2 );
    fuseSegment( seg=3 );
    
    fuseWingMount(dx=0);
    mirror([0,0,1]) fuseWingMount(dx=0);

    wingMotor();
    wingMotorPlate();
    mirror([0,0,1]) wingMotor();
    mirror([0,0,1]) wingMotorPlate();

    color("Red") fuseSkid( r=-0.5 );
    color("GhostWhite") fuseCoverFront();
    color("GhostWhite") fuseCoverMid();
    color("GhostWhite") fuseCoverBak();
    
    tail(); 
}

module exploreFuse()
{
    show([20,0,0]){
        *fuseMotor( d=0.5, holes=true);
        fuseSegment( seg=0 );
        union(){
            fuseSegment( seg=1 );
            translate( [0,0,-100]) fuseWingMount();
            translate( [0,50,0]) color("GhostWhite") fuseCoverBak();
            }
        fuseSegment( seg=2 );
        translate( [0,50,0]) color("GhostWhite") fuseCoverMid();
        color("Red") translate( [0,-50,0]) fuseSkid( r=-0.5 );
        fuseSegment( seg=3 );
        translate( [0,50,0]) color("GhostWhite") fuseCoverFront();
    }
}

module exploreWing()
{
    show([0,0,20]){
        translate([-20,0,0]) exploreFuse();
    
        Ruder2( ptStart=[-p1.x+o1,+p1.y,z1], dStart=d1, ptStop=[-p2.x+o2,+p2.y,z2], dStop=d2, dSpace=0.8, steps=7 )
            union(){
                wingSegment( [s[0],s[1]], [o[0],o[1]] );
                }
        union(){
            wingMotor();
            wingMotorPlate();
            }

        
        union(){
            translate([tubeOffset2-260,-8,zBoom]) 
                rotate([0,90,0])  
                    cylinder(d=dBar1, h=440, center=true);
            tubeFlansh2();
            HRuder();
            sideSolid(r=0);
            }
            
     translate([0,0,80])
     Ruder2( ptStart=[-p1.x+o1,+p1.y,z1], dStart=d1, ptStop=[-p2.x+o2,+p2.y,z2], dStop=d2, dSpace=0.8, steps=7 )
        union(){
            wingSegment( [s[2],s[3]], [o[2],o[3]] );
            RuderHorn( dbase=d1, pos = o[2] + [-ptQRuder.x*s[2], +ptQRuder.y*s[2], 0]  ); /*dSpace is 0.8*/         
            }
     fuseWingMount(dx=0);
     Ruder2( ptStart=[-p1.x+o1,+p1.y,z1], dStart=d1, ptStop=[-p2.x+o2,+p2.y,z2], dStop=d2, dSpace=0.8, steps=7 )
        union(){
            wingSegment( [s[1],s[2]], [o[1],o[2]] );
            }
     
     translate([0,0,80])
     Ruder2( ptStart=[-p1.x+o1,+p1.y,z1], dStart=d1, ptStop=[-p2.x+o2,+p2.y,z2], dStop=d2, dSpace=0.8, steps=7 )
        union(){
            *wingSegment( [s[3],s[4]], [o[3],o[4]] );
            wingBow();
            }
        }
        
        color("Black") xTube( diameter=8, length=1000, tubeoffset=tubeOffset1 );
        color("Black") xTube( diameter=6, length=400, tubeoffset=tubeOffset2 );
}

