// Inspectoer

$fn=50;

include <profiles.scad> // wing profile polygon definition, ClarkY
include <skin.scad> // skin funktionen
include <wing.scad> // spant , segment funktionen, brauchen o[] und s[]
include <polyline.scad> 
include <servo.scad>
include <qruder.scad>   // for wing
include <hruder.scad>   // for tail

sf= 30/500; // forward = 30mm pro 500mm  (550???)
o = [   [+sf*0,   0, 50],     
        [+sf*100, 0, 150],
        [+sf*300, 0, 350],
        [+sf*500, 0, 550] ]; //offset: x,y,z 
s = [ 250, 230, 200, 170 ]; //size = factor   250 - (z-50)*

tubeOffset1 = 0.25; 
tubeOffset2 = 0.5; /*-s[0]/3;*/    // tube offset in [%]
tubeAng1 = atan2( (o[3]-o[0]).z, -o[3].x - tubeOffset1*(s[0]-s[3]) ) - 90;
tubeAng2 = atan2( (o[3]-o[0]).z, -o[3].x - tubeOffset2*(s[0]-s[3]) ) - 90;
tubeAng = (tubeAng1 + tubeAng2) / 2;    // different angles will make problems
*echo(tubeAng, tubeAng1 , tubeAng2);

dBar1 = 6.4;    // diameter of the 1st tube
dBar2 = 6.4;    // diameter of the 2nd tube
//zBoom = 130+13;

wall = 0.5;
ruderseg=2;
ruderrot=tubeAng;
ptQRuder = [pSD6060[9].x, (pSD6060[9].y+pSD6060[51].y)/2];
hQRuder = pSD6060[9].y - pSD6060[51].y;
ptHRuder = [pNaca0012[5].x, (pNaca0012[5].y+pNaca0012[57].y)/2];
hHRuder = pNaca0012[5].y - pNaca0012[57].y;
dPoly = 2.2;


// Dokmentation:
*exploreWing();
*exploreFuse();
*complete();

//solid:
*wingSolid();
*wingSegment( [s[0],s[1]], [o[0],o[1]], do = 2 );
*wingSegment( [s[1],s[2]], [o[1],o[2]], do = 0 );
*QRuderSegment();
*translate([-0,0,0]) QRuder();
*lastsegment();   

*fuseSolid();  
*fuseSkin(); 
*fusePoly();
*translate([335,0,50]) spant3d( d=0.3, offset=[0,0,0],    size=605,   r=0, p=pClarkFuse );
*fuseNaca();
*fuseCoverMid(d=0);
*fuseCoverFront(d=0);
*fuseCoverHook( true );
*fuseCoverHook( false );
*fuseCoverHookKnop();
*fuseSegment(0);
*fuseSegment(1);
*fuseSegment(2);
*fuseSegment(3);
*translate([200,0,0])  color("Grey") cube([75,45,45],center=true); // akku
*fuseWingMount(pos=0);
*fuseWingMount(pos=1);

*tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 );
*tubeFlansh();

*wingConnectCut();
// dBar contains 0.4 offset, reduce to 0.2
*translate([-tubeOffset1*s[1]+o[1].x,0,o[1].z-7]) mirror([0,1,0]) tubeConnect( d1=dBar1, d2=dBar1+2-0.2, a=8, w=6 ); 
*translate([-tubeOffset2*s[1]+o[1].x-5,0,o[1].z-7]) mirror([0,1,0]) tubeConnect( d1=dBar1, d2=dBar1+2-0.2, a=8, w=6 );
*xTube( diameter=8, length=1200, tubeoffset=tubeOffset1 );
*xTube( diameter=8, length=1200, tubeoffset=tubeOffset2 );

*tail();            
*HRuderSegment();
*translate([-0,0,0]) HRuder();
            
            

*translate([0,-25,0]) color("Red") fuseSkid();
*fuseMotor(d=0.5, holes=true);





module complete()
{

//view: [ -138.68, -75.77, 45.99 ] [ 142.00, 35.00, 175.90 ] 1754.01 22.50

    wingConnectCut();
    wingSegment( [s[1],s[2]], [o[1],o[2]], do = 0 );
    QRuderSegment();
    translate([-0,0,0]) QRuder();
    lastsegment();   
    mirror([0,0,1]){
        wingConnectCut();
        wingSegment( [s[1],s[2]], [o[1],o[2]], do = 0 );
        QRuderSegment();
        translate([-0,0,0]) QRuder();
        lastsegment();   
        }
    fuseMotor( d=0.5, holes=true);
    fuseSegment( seg=0 );
    fuseSegment( seg=1 );
    fuseSegment( seg=2 );
    fuseSegment( seg=3 );
    color("GhostWhite") fuseCoverMid();
    color("Red") fuseSkid( r=-0.5 );
    color("GhostWhite") fuseCoverFront();
    tail(); 
}

module exploreFuse()
{
    show([20,0,0]){
        fuseMotor( d=0.5, holes=true);
        fuseSegment( seg=0 );
        union(){
            fuseSegment( seg=1 );
            translate( [0,-100,0]) fuseWingMount(pos=0);
            translate( [0,-100,0]) fuseWingMount(pos=1);
            }
        fuseSegment( seg=2 );
        translate( [0,50,0]) fuseCoverMid();
        color("Red") translate( [0,-50,0]) fuseSkid( r=-0.5 );
        fuseSegment( seg=3 );
        translate( [0,50,0]) color("GhostWhite") fuseCoverFront();
    }
}

module exploreWing()
{
    show([0,0,20]){
        translate([-20,0,0]) exploreFuse();
        wingConnectCut();
        union(){
            *translate([-tubeOffset1*s[1],0,zBoom]) tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 ); // need an update
            *translate([-tubeOffset2*s[1],0,zBoom]) tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 );
            *translate([tubeOffset2-260,-8,zBoom]) 
                rotate([0,90,0])  
                    cylinder(d=dBar1, h=440, center=true);
            translate([-420,0,zBoom]) tubeFlansh();
            translate([-420,30,0]) heigtSolid(r=0);
            translate([-420,60,zBoom]) sideSolid(r=0);
            }
        wingSegment([s[1],s[2]], [o[1],o[2]]);
        union(){
            QRuderSegment();
            translate([-20,0,0]) QRuder();

            }
        lastsegment();
        }
        
        *xTube( diameter=6, length=500, tubeoffset=tubeOffset1 );
        *xTube( diameter=6, length=500, tubeoffset=tubeOffset2 );

        /*
        translate([tubeOffset1,0,500/2])
            xTube( length=500, diameter=dBar1, $fn=50 );
        //translate([tubeOffset2,0,500/2])
            xTube( length=500, diameter=dBar2, $fn=50 );
        //translate([tubeOffset1,0,zBoom/2+10])
            xTube( length=zBoom, diameter=dBar1+2, $fn=50 );
        //translate([tubeOffset2,0,zBoom/2+10])
            xTube( length=zBoom, diameter=dBar2+2, $fn=50 );
        */
}

module wingSolid(r=0)
{
    for(i=[0:len(o)-2]) segment(i, r);
    lastsegment();
}

module wingSegment( s=[s[0],s[1]], o=[o[0],o[1]], do = 0 )
{
    
    difference(){
        union(){
            linearSlice( sx=s[0], sh=o[1].z-o[0].z, org=o[0], center=true )
                segment(s, o, r=0);
            }
        union(){    
            ServoDiff();

            xTube( diameter=dBar1+do, length=1200, tubeoffset=tubeOffset1 );
            xTube( diameter=dBar2+do, length=1200, tubeoffset=tubeOffset2 );

            wingPolyLine( d=dPoly, pt=pSD6060[31], off=[+2,+0.5] );
            wingPolyLine( d=dPoly, pt=ptQRuder, off=[+0,+0] );
            wingElectric();
            }
    }
}

module lastsegment( r=0, h=10, ds=50, p=pSD6060 )
{
    i = len(o) - 1;
    dx = s[i]*(100-ds)/100/2;
    
    difference()
    {
    hull()
        {
        spant3d( d=0.3, offset=o[i], s[i], r=r, p=p );  
        spant3d( d=0.3, offset=o[i]+[-dx,0,h], s[i]*ds/100, r=r, p=p );
        }
    wingPolyLine( d=dPoly, pt=pSD6060[31], off=[+2,+0.5] );
    wingPolyLine( d=dPoly, pt=ptQRuder, off=[+0,+0] );
    }

}

module wingElectric()
{
    off = (tubeOffset1+tubeOffset2)/2;
    l = 407;
    translate([-off * s[0] + o[0].x,0,o[0].z-1])  // based of the 1st segment
        rotate([0,tubeAng,0]) 
            translate([0,4,l/2-10]) cube( [12,6,l],center=true);
    mirror([0,0,1])    // for the fuse, we need both sides, so mirror and dublicate     
    translate([-off * s[0] + o[0].x,0,o[0].z-1])  // based of the 1st segment
        rotate([0,tubeAng,0]) 
            translate([0,4,l/2-10]) cube( [12,6,l],center=true);
}

module xTube( diameter=6, length=1200, tubeoffset=tubeOffset1 )
{
    translate([-tubeoffset * s[0] + o[0].x,0,o[0].z])  // based of the 1st segment
        rotate([0,tubeAng,0]) 
            cylinder(d=diameter, h=length, center=true); // inner tube
}

module QRuderSegment(){
    difference(){
        wingSegment( [s[2],s[3]], [o[2],o[3]], do = 0 );
        QRuderCut2();    
        QRuderDiff2();
        }
    QRuderAdd2(); 
}

module QRuder(){
    difference(){
        wingSegment( [s[2],s[3]], [o[2],o[3]], do = 0 );
        QRuderCut3();
        QRuderDiff3();
        }
    QRuderAdd3();
    QRuderHorn();
}

module HRuderSegment(){
    difference(){
        union(){
        difference(){
            heigtSolid(r=0);
            HRuderCut2();    
            HRuderDiff2();
            
            *translate([0, 11-8,-zBoom]) mirror([0,0,1])tubeFlansh(r=0.2);
            *translate([0, 11-8,+zBoom-1]) tubeFlansh(r=0.2);
            hull(){ 
                translate([-2, 0, -ho-dPoly]) sphere(d=dPoly); 
                translate([-2, 0, +ho+dPoly]) sphere(d=dPoly); 
                }

            }
        HRuderAdd2(); 
        }
        translate([-35,2,0]) servo_sg90();
        translate([-53,0,-80]) rotate([0,20,0]) cube([12,6,140], center=true );
    }

}

module HRuder(){
    difference(){
        heigtSolid(r=0);
        HRuderCut3();
        HRuderDiff3();
        }
   HRuderAdd3();
   HRuderHorn();
}










module tail() 
{
    z0 = +8;
    translate([-420, 8-3, 0]) HRuderSegment();
    translate([-420, 8-3, 0]) HRuder();
    translate([-420, 8+6, +zBoom+3]) mirror([0,0,1]) sideSolid();
    translate([-420, 8+6, -zBoom-3]) sideSolid();
    color( "BLACK") translate([-40, z0, +zBoom]) rotate([0,-90,0]) cylinder(d=6,h=450);
    color( "BLACK") translate([-40, z0 ,-zBoom]) rotate([0,-90,0]) cylinder(d=6,h=450);
    
    translate([-420, z0, +zBoom]) tubeFlansh();
    translate([-420, z0, -zBoom]) mirror([0,0,1])tubeFlansh();
}

module sideSolid(r=0)
{
    bardist = 130;
    difference(){
        hull(){
            translate([0,0,0]) rotate([90,0,0]) spant3d( d=0.3, offset=[0,0,0], size=120, r=r, p=pSD6060 );
            translate([0,zBoom,0]) rotate([90,0,0]) spant3d( d=0.3, offset=[10,0,0], size=58, r=r, p=pSD6060 );
            }
        translate([0,2-8,0]) mirror([0,0,1])tubeFlansh(r=0.2);
    }
}

module heigtSolid(r=0)
{
    br = zBoom-6;
    difference(){
        hull(){
            translate([0,0,-br]) spant3d( d=0.3, offset=[0,0,0], size=120, r=r, p=pNaca0012 );
            translate([0,0,+br-0.3]) spant3d( d=0.3, offset=[0,0,0], size=120, r=r, p=pNaca0012 );
            }
        ;
        }
}









fuseWidth = 52;    // Rumpfbreite war 50
fuseLength0 = 355; // Spitze vor dem nullpunkt bei r=0 , war 355
fuseLength1 = 270; // hinterster Punkt - 5, die Länge in Dirks plan war 605mm
fuseMotorDia = 40;    // Durchmesser am Motor

module fuseSolid( r=0 )
{
    hull()
    {
        translate([-(fuseLength1 + r),0,0]) rotate([0,90,0]) cylinder(d=fuseMotorDia+2*r,h=5,center=true); //motor
        translate([0,0,-0.15])  spant3d( d=0.3, offset=(o[0]+[0,0,r]),  size=s[0],  r=r, p=pSD6060 );
        translate([fuseLength0,0,-0.15]) spant3d( d=0.3, offset=[0,0,fuseWidth/2+r],    size=605,   r=r, p=pClarkFuse );
        translate([fuseLength0,0,-0.15]) spant3d( d=0.3, offset=[0,0,-(fuseWidth/2+r)], size=605,   r=r, p=pClarkFuse );
        translate([0,0,-0.15])  spant3d( d=0.3, offset=-(o[0]+[0,0,r]), size=s[0],  r=r, p=pSD6060 );
    }
}

module fuseCoverMask( x=0, y=100, r=90, h=400, type = 0 )
{
    if( type==1 ) 
        translate([x,y,0]){   // cutout der Haube als Kugel
            sphere(r=r);
            }
    else if( type==2 )
        translate([x,y,0]){   // cutout der Haube als Cylinder
            rotate([0,90,0]) cylinder( r=r, h=h );
            }
    else if( type==3 )
        translate([x,y,0]){   // cutout der Haube in klassischer 2 rampen form
            hull(){
            translate([x,+r/2,0]) cube([h+2*r,0.1,r], center=true);
            translate([x,-r/2,0]) cube([h,0.1,r], center=true);
            }
            }
    else
        translate([x,y,0]){   // cutout der Haube
            if ( type == 0) sphere(r=r);
            rotate([0,90,0]) cylinder( r=r, h=h );
            }

}

module fuseSkin( fuseSkin = 5 )
{
    innerSkin(){
        union(){
            fuseSolid( r=0 );
            }
        union(){
            fuseSolid( r=-fuseSkin );
            
            fuseCoverMask(x=120, y=63, r=fuseWidth+20, h=100, type=3);
            fuseCoverMask(x=35, y=80, r=fuseWidth+40, h=80, type=3);
            fuseCoverFront(d=0.3);
            fuseCoverMid(d=0.3);
            
            *translate([-280,0,0]){   // cutout inner Motormount
                rotate([0,90,0]) cylinder( d=30, h=40 );
                }
            *translate([-310,0,0]){   // cutout outer Motormount
                rotate([0,90,0]) cylinder( d=35, h=40 );
                }
                
            fuseMotor(d=0, holes=false);
                
            xTube( diameter=dBar1+2, length=100, tubeoffset=tubeOffset1, $fn=50 );
            mirror([0,0,1]) xTube( diameter=dBar1+2, length=100, tubeoffset=tubeOffset1, $fn=50 );
            xTube( diameter=dBar2+2, length=100, tubeoffset=tubeOffset2, $fn=50 );
            mirror([0,0,1]) xTube( diameter=dBar2+2, length=100, tubeoffset=tubeOffset2, $fn=50 );
            
            translate([-200,-5,+30])
                rotate([0,-90,20])
                    cylinder(d=10,h=80,center=true);
            translate([-200,-5,-30])
                rotate([00,-90,20])
                    cylinder(d=10,h=80,center=true);
            translate([-258,+20,0])
                rotate([00,-90,-20])
                    cylinder(d=10,h=80,center=true);

             fuseSkid();
             fusePoly();
             wingElectric();
             fuseCamera();
             
             translate([260,-8,+23]) rotate([8,0,0 ]) scale(8) fuseNaca(w=-10);
             translate([260,-8,-23]) rotate([180-8,0,0 ]) scale(8) fuseNaca(w=-10);

            }
        }
       
       *fuseMotor(d=0.5, holes=true);
       *wingSegment( [s[0],s[1]], [o[0],o[1]], do = 2 );
       *mirror( [0,0,1] ) wingSegment( [s[0],s[1]], [o[0],o[1]], do = 2 );
}

module fuseSegment( seg=0 )
{
    length = 170;
    start = -140+seg*length;
    radialSlice( sh=length, sx=100, org=[-length+start,0,0], rot=[0,90,0], mode=2, center=false )
    {
        fuseSkin( fuseSkin = 5 );
    }
}
module fuseWingMount(pos=0)
{
    ox = (pos<=0) ? 0 : 62.5;
    to = (pos<=0) ? tubeOffset1 : tubeOffset2;
    
    intersection(){
        difference(){
            union(){
                Slice(){
                    innerSkin(){
                        fuseSolid( r=-5.3 );
                        fuseSolid( r=-10 );
                        }
                    union(){
                        translate([-63.5-ox,0,0]) rotate([0,90,0])cylinder(d=100,h=15,center=true);
                        }
                    }
                    
                xTube( diameter=dBar2+2+4, length=102, tubeoffset=to, $fn=50 );
                mirror([0,0,1]) xTube( diameter=dBar2+2+4, length=102, tubeoffset=to, $fn=50 );
                translate([-75.0-ox,0,-2.5]) rotate([0,0,-6.5])cube([15,40,5]);
                mirror([0,1,0]) translate([-75.0-ox,0,-2.5]) rotate([0,0,-8])cube([15,40,5]);
                }
            xTube( diameter=dBar1+2, length=102, tubeoffset=to, $fn=50 );
            mirror([0,0,1]) xTube( diameter=dBar1+2, length=102, tubeoffset=to, $fn=50 );
            }
        fuseSolid( r=-5.3 );
        }

}

module fuseCoverHookKnop()
{
    difference(){
        hull(){
            translate([-10,0,-8])cylinder(d=1,h=5);
            translate([0,0,-10])cylinder(d=8,h=8.3);
            translate([+10,0,-8])cylinder(d=1,h=5);
            }
        translate([0,0,-10])cylinder(d=6.4,h=10);
    }
}

module fuseCoverHook(op=false)
{
    cylinder(d=8,h=7);    
    hull()
    {
        translate([0,0,4]) cylinder(d=8,h=2);
        translate([4,0,4]) cylinder(d=8,h=2);
        }
    if( op == true ){
        translate([0,0,-10])cylinder(d=6,h=10);
        *fuseCoverHookKnop();
    }else{
        translate([0,0,-2])cylinder(d=6,h=2);
    }
}

module fuseCoverFront(d=0.1)
{
    coverSkin = 2;
    hx1 = 296-4;
    hy1 = 37;
    hx2 = 172.5;
    hy2 = 52.5;

    Slice(){
        innerSkin(){
            fuseSolid( r=+d );
            union(){
                fuseSolid( r=-coverSkin-d );
                *translate([250,40,0]) rotate([-90,0,0 ]) scale(6) fuseNaca(w=-10+11);
                translate([ hx1, hy1, 0])
                    rotate([90,0,-12])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                translate([hx2, hy2, 0])
                    rotate([90,180,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                }
            }
        fuseCoverMask(x=120, y=63-3-d, r=fuseWidth+20, h=100, type=3);
        }
    *translate([hx1,hy1,0])
        rotate([90,0,-12])
            fuseCoverHook();

    *translate([hx2,hy2,0])
        rotate([90,180,0])
            fuseCoverHook( true );
}

module fuseCoverMid(d=0.1)
{
    coverSkin = 2;
    hx1 = 122;
    hy1 = 52.5;
    hx2 = 22.5;
    hy2 = 47;

    Slice(){
        innerSkin(){
            fuseSolid( r=+d );
            union(){
                fuseSolid( r=-coverSkin-d );
                *translate([100,50,0]) rotate([-90,0,0 ]) scale(6) fuseNaca(w=-10);
                translate([ hx1, hy1, 0])
                    rotate([90,0,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                translate([hx2, hy2, 0])
                    rotate([90,180,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                }
            }
        fuseCoverMask(x=35, y=80-3-d, r=fuseWidth+40, h=80, type=3);
        }
    *translate([hx1,hy1,0])
        rotate([90,0,0])
            fuseCoverHook();

    *translate([hx2,hy2,0])
        rotate([90,180,0])
            fuseCoverHook( true );
}

module fuseMotor(d=0.5, holes=true)
{
// 19mm Löcher, Motokreuz: Balken mit 2 Schrauben, Gegenstück in den Rumpf kleben....
    translate([9.5,0,0])
    difference()
    {
        union()
        {
            translate([-280,0,0]){   // cutout inner Motormount
                rotate([0,90,0]) cylinder( d=30-d, h = 3 ); // h=5 was too fat, because it is solid
                }
            translate([-282,0,0]){   // cutout outer Motormount
                rotate([0,90,0]) cylinder( d=35-d, h=3 );
                }
            translate([-282,0,0]){   // cutout outer Motormount
                rotate([0,90,0]) resize([50,20,3])cylinder( d=35-d, h=3 );
                }
            translate([-260,0,+20]) 
                    rotate([0,-90,0]) 
                        cylinder( d=3.8, h=30 );   
            translate([-260,0,-20]) 
                    rotate([0,-90,0]) 
                        cylinder( d=3.8, h=30 );  
            if( !holes ){
            translate([-250+6,0,-20]) 
                    rotate([0,-90,0]) 
                        cylinder( d=6.5, h=30,$fn=6 );   
            translate([-250+6,0,+20]) 
                    rotate([0,-90,0]) 
                        cylinder( d=6.5, h=30,$fn=6 );   
                }
            
        }
        if(holes)
        union()
        {
            translate([-270,0,0]) 
                    rotate([0,-90,0]) 
                        cylinder( d=9, h=40 );   
            translate([-270,0,0])
                rotate([0,-90,0])
                    for( rot=[0:90:360] )
                        rotate([0,0,rot+45])
                            translate([0,19/2,0])
                                    cylinder( d=3.8, h=40 );
            translate([-260,0,+20]) 
                    rotate([0,-90,0]) 
                        cylinder( d=3.8, h=30 );   
            translate([-260,0,-20]) 
                    rotate([0,-90,0]) 
                        cylinder( d=3.8, h=30 );   
        }
    }
}

module fuseNaca(w=-12)
{
    module hole(){
    p = [[-5,0], [-5,1.5], [0,1.5], [1,1.25], [2,0.8] ,[3,0.6] ,[4,0.4], [10,0.4], [10,0]];
    linear_extrude(height=1 )polygon(p);
    mirror([0,1,0]) linear_extrude(height=1 )polygon(p);
    }
    
    translate([0,0,0]) rotate([0,w,0]) hole();
    // fehlt die Schraegung und der Luftkanal...
}

module fuseSkid( r=0 )
{
    // wechselbare Platte für den Boden... 25x5cm, 2 Layer?
    // Rand ???
    d = 40;
    l = 250-d;
    Slice(){
        innerSkin(){
            fuseSolid( r=0 );
            fuseSolid( r=-0.5 );
            }
        *translate([200,-25,0]) rotate([90,0,0]) resize([3*45-r,45-r,45-r]) cylinder(d=45,h=50);
        #translate([200,-15,0]) 
            rotate([90,0,0]) 
                hull(){
                    translate([-l/2,0,0]) cylinder(d=d-r,h=50);
                    translate([+l/2,0,0]) cylinder(d=d-r,h=50);
                    }
        }
}

module fuseCamera()
{
    translate([332,3,0])
        rotate([0,90,0])
            union(){
                cylinder(d=15, h=30);
                cube([21,21,15], center=true);
                }
}

module fusePoly()
{
    translate([355-5,0,0])
        mirror([1,0,0])
        {
            fusePolyLine( d=dPoly, off=[-2.7+fuseWidth/2,-4], size=605, p=pClarkFusePolyUp ); 
            fusePolyLine( d=dPoly, off=[-2.+fuseWidth/2,+5], size=605, p=pClarkFusePolyDown ); 

            fusePolyLine( d=dPoly, off=[+2.7-fuseWidth/2,-4], size=605, p=pClarkFusePolyUp ); 
            fusePolyLine( d=dPoly, off=[+2.5-fuseWidth/2,+5], size=605, p=pClarkFusePolyDown ); 
            
            //offsetPolyLine(  d=dPoly, size=605, off=0, p=pClarkY );
            //offsetPolyLine(  d=dPoly, size=605, off=-10, p=pClarkY );
            
            }
    fusePolyLineQ( d=dPoly, pt=pSD6060[31], off=[+2,+0.5] );
    fusePolyLineQ( d=dPoly, pt=ptQRuder, off=[+0,+0] );

}

module wingConnectCut()
{
    difference()
    {
        wingSegment( [s[0],s[1]], [o[0],o[1]], do = 2 );
        translate([-tubeOffset1*s[1]+o[1].x,0,o[1].z-7]) mirror([0,1,0]) tubeConnectCut();
        translate([-tubeOffset2*s[1]+o[1].x-5,0,o[1].z-7]) mirror([0,1,0]) tubeConnectCut();
        translate([tubeOffset2-260,+8,zBoom]) 
            rotate([0,90,0])  
                cylinder(d=dBar1+2, h=440, center=true);
        translate([-tubeOffset2*s[1]+o[1].x+40,3,o[1].z-1.4]) 
            cube([20,4.1,3],center = true );
    }
}

module tubeConnectCut()
{
    minkowski(){
        hull(){
            tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 );
            }
        translate([0,0,-0.8]) cylinder(r=3,h=4);
        }
}

module tubeConnect( d1=8, d2=6, h=10, a=8, w=3 )
{
    // min a is d1?
    
    sp = -a-h/2;  // position of screw
    difference(){
        hull(){
            rotate( [0,+tubeAng,0] )
                cylinder(d=d2+w, h=h, center = true );  // cylinder d2 (rotated)
            translate( [0,-a,0] )
                rotate( [0,90,0] )
                    cylinder(d=d1+w, h=h, center = true );// cylinder d1 (not rotated)
            translate( [0,sp,0] )
                rotate( [0,90,0] )
                    sphere(d=h+2);  // was: cube([d1+w,h,h], center = true );

                }
        rotate( [0,+tubeAng,0] )
            cylinder(d=d2, h=h+10, center = true );     // cylinder d1 (rotated)
        translate( [0,-a,0] )
            rotate( [0,90,0] )
                cylinder(d=d1, h=h+10, center = true ); // cylinder d2 (not rotated)
        translate( [0,sp,0] )
            rotate( [0,90,0] )
                cube([1,-sp,-sp], center = true );    // cut a 1mm gap
        translate( [0,sp,0] )
            cylinder(d=2.2, h=h+10, center = true );    // 3mm screw
        translate( [0,sp,-5] )
            cylinder(d=4.5, h=3, center = true, $fn=6 );// screw nut
        translate( [0,sp,+5] )
            cylinder(d=4.5, h=3, center = true );       // screw head
        }
}

module tubeFlansh( d=6, a=0, h=60, w=3, r=0 )
{
    offh = +(d+w)/2+1;
    translate([-20,0,0])
    difference(){
        union(){
            hull()
                {
                translate([0,-a,0]) rotate([0,-90,0]) cylinder(d=d+w, h=h, center = false );   
                translate([20,+offh,3]) rotate([90,0,0]) 
                    mirror([0,1,0])
                        spant3d( d=0.3, offset=[0,0,0], size=120, r=0, p=pSD6060 );
                translate([20,-3,-offh]) 
                    spant3d( d=0.3, offset=[0,0,0], size=120, r=0, p=pNaca0012 );
                }
            hull()
                {
                translate([-5,offh,-1.5]) rotate([-90,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                translate([-45,offh,-1.5]) rotate([-90,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                }
            hull()
                {
                translate([-5,-3,-1.5]) rotate([180,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                translate([-45,-3,-1.5]) rotate([180,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                }
            }
        translate([-2*h,-a,0]) rotate([0,90,0]) cylinder(d=d+0.2, h=h*3, center = false );
        translate([8,-a,0]) rotate([0,90,0]) cylinder(d1=d+0.2,d2=d+1, h=12, center = false );
        
        translate([0-2*h,-a, 0] )
            rotate( [45+90,0,0] )
                cube([h*3,h*3,1], center = false );    // cut a 1mm gap

        hull(){ 
            translate([+20-ptHRuder.x*120, -3+ptHRuder.y*120, -4-dPoly]) sphere(d=dPoly); 
            translate([+20-ptHRuder.x*120, -3+ptHRuder.y*120, +3+dPoly]) sphere(d=dPoly); 
            }
        hull(){ 
            translate([+20-2, -3, -4-dPoly]) sphere(d=dPoly); 
            translate([+20-2, -3, +3+dPoly]) sphere(d=dPoly); 
            }
        translate([-53,-2,-8]) cube([12,6,10], center=true ); // servo cable - bad

        }
        
        
        
        
        
}
