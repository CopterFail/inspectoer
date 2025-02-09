// Inspectoer

$fn=50;

include <profiles.scad> // wing profile polygon definition, ClarkY
include <skin.scad> // skin funktionen
include <wing.scad> // spant , segment funktionen, brauchen o[] und s[]
include <polyline.scad> 
include <servo.scad>
include <ruder.scad>

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
echo(tubeAng, tubeAng1 , tubeAng2);

dBar1 = 6.4;    // diameter of the 1st tube
dBar2 = 6.4;    // diameter of the 2nd tube
zBoom = 130;

wall = 0.5;
ruderseg=2;
ruderrot=tubeAng;
ptRuder = [pSD6060[9].x, (pSD6060[9].y+pSD6060[51].y)/2];
hRuder = pSD6060[9].y - pSD6060[51].y;
dPoly = 2.2;





*exploreWing();
*exploreFuse();

//solid:
*wingSolid();
*wingSegment( [s[0],s[1]], [o[0],o[1]], do = 2 );
*wingSegment( [s[1],s[2]], [o[1],o[2]], do = 0 );
*wingSegment( [s[2],s[3]], [o[2],o[3]], do = 0 );

union(){
    difference(){
        wingSegment( [s[2],s[3]], [o[2],o[3]], do = 0 );
        RuderCut2();    
        RuderDiff2();
        }
    RuderAdd2(); // achtung verschließt das loch !!!
}

translate([-50,0,0])
union(){
    difference(){
        wingSegment( [s[2],s[3]], [o[2],o[3]], do = 0 );
        RuderCut3();
        RuderDiff3();
        }
    RuderAdd3();
}


*RuderMountClip(r=0);
*lastsegment();   

*fuseSolid();  
*fuseSkin(); 
*translate([335,0,50]) spant3d( d=0.3, offset=[0,0,0],    size=605,   r=0, p=pClarkFuse );
*fuseNaca();
*fuseCoverMid();
*fuseCoverFront();
*fuseSegment(1);
*fuseWingMount(pos=0);
*fuseWingMount(pos=1);

*tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 );

*difference(){
    wingSegment( [s[0],s[1]], [o[0],o[1]], do = 2 );
    translate([-tubeOffset1*s[1]+o[1].x,0,o[1].z-7]) tubeConnectCut();
    translate([-tubeOffset2*s[1]+o[1].x-5,0,o[1].z-7]) tubeConnectCut();
    translate([tubeOffset2-260,-8,zBoom+13]) 
        rotate([0,90,0])  
            cylinder(d=dBar1, h=440, center=true);

}
*translate([-tubeOffset1*s[1]+o[1].x,0,o[1].z-7]) tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 );
*translate([-tubeOffset2*s[1]+o[1].x-5,0,o[1].z-7]) tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 );
*translate([tubeOffset2-260,-8,zBoom+13]) 
    rotate([0,90,0]) 
        color( "Black")
            cylinder(d=dBar1, h=440, center=true);

*translate([0,-25,0]) color("Red") fuseSkid();

*hinterteil();
*fusePolyline( size=605, p=pClarkFuse ); 



module exploreFuse()
{
    show([20,0,0]){
        fuseMotor();
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
        wingSegment([s[0],s[1]], [o[0],o[1]]);
        union(){
            translate([-tubeOffset1*s[1],0,zBoom]) tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 );
            translate([-tubeOffset2*s[1],0,zBoom]) tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 );
            translate([tubeOffset2-260,-8,zBoom]) 
                rotate([0,90,0])  
                    cylinder(d=dBar1, h=440, center=true);
            translate([-420,0,zBoom]) tubeFlansch();
            translate([-420,30,0]) heigtSolid(r=0);
            translate([-420,60,zBoom]) sideSolid(r=0);
            }
        wingSegment([s[1],s[2]], [o[1],o[2]]);
        union(){
            wingSegment([s[2],s[3]], [o[2],o[3]]);
            RuderAdd2(); 
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
            wingPolyLine( d=dPoly, pt=ptRuder, off=[+0,+0] );
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
    wingPolyLine( d=dPoly, pt=ptRuder, off=[+0,+0] );
    }

}

module wingElectric()
{
    off = (tubeOffset1+tubeOffset2)/2;
    l = 400;
    translate([-off * s[0] + o[0].x,0,o[0].z-1])  // based of the 1st segment
        rotate([0,tubeAng,0]) 
            translate([0,0,l/2]) cube( [12,6,l],center=true);
}

module xTube( diameter=6, length=1200, tubeoffset=tubeOffset1 )
{
    translate([-tubeoffset * s[0] + o[0].x,0,o[0].z])  // based of the 1st segment
        rotate([0,tubeAng,0]) 
            cylinder(d=diameter, h=length, center=true); // inner tube
}













module hinterteil() // erstmal stark vereinfacht
{
    bardist = 130; /*150*/
    translate([-420,0,0]) heigtSolid();
    translate([-420, 0, +bardist]) mirror([0,0,1]) sideSolid();
    translate([-420, 0, -bardist]) sideSolid();
    color( "BLACK") translate([-40,-8,+bardist]) rotate([0,-90,0]) cylinder(d=6,h=450);
    color( "BLACK") translate([-40,-8,-bardist]) rotate([0,-90,0]) cylinder(d=6,h=450);
}

module sideSolid(r=0)
{
    hull(){
        translate([0,0,0]) rotate([90,0,0]) spant3d( d=0.3, offset=[0,0,0], size=120, r=r, p=pSD6060 );
        translate([0,130,0]) rotate([90,0,0]) spant3d( d=0.3, offset=[10,0,0], size=58, r=r, p=pSD6060 );
        }
}

module heigtSolid(r=0)
{
    br = 185 - 20;
    difference(){
        hull(){
            translate([0,0,-br]) spant3d( d=0.3, offset=[0,0,0], size=120, r=r, p=pNaca0012 );
            translate([0,0,+br]) spant3d( d=0.3, offset=[0,0,0], size=120, r=r, p=pNaca0012 );
            }
        #translate([-50-1.5,0,+br-35]) cube([40,20,4]);
        #translate([-50-1.5,0,-br+35]) cube([40,20,4]);
        }
}






module fuseSolid( r=0 )
{
    w0 = 50;    // innere breite
    l0 = 335;   // spitze vor dem nullpunkt bei r=0 , war 355
    l1 = 270;   // hinterster punkt - 5
    m0 = 40;    // durchmesser am motor
    
    hull()
    {
        translate([-(l1 + r),0,0]) rotate([0,90,0]) cylinder(d=40+2*r,h=5,center=true); //motor
        translate([0,0,-0.15])  spant3d( d=0.3, offset=(o[0]+[0,0,r]),  size=s[0],  r=r, p=pSD6060 );
        translate([l0,0,-0.15]) spant3d( d=0.3, offset=[0,0,w0/2+r],    size=605,   r=r, p=pClarkFuse );
        translate([l0,0,-0.15]) spant3d( d=0.3, offset=[0,0,-(w0/2+r)], size=605,   r=r, p=pClarkFuse );
        translate([0,0,-0.15])  spant3d( d=0.3, offset=-(o[0]+[0,0,r]), size=s[0],  r=r, p=pSD6060 );
    }
}

module fuseCoverMask( x=0, r=90, h=400, type = 0 )
{
    if( type==1 )
        translate([x,100,0]){   // cutout der Haube
            sphere(r=r);
            }
    else if( type==2 )
        translate([x,100,0]){   // cutout der Haube
            rotate([0,90,0]) cylinder( r=r, h=h );
            }
    else if( type==3 )
        translate([x,45,0]){   // cutout der Haube
            hull(){
            translate([x,+r/2,0]) cube([h+2*r,0.1,r], center=true);
            translate([x,-r/2,0]) cube([h,0.1,r], center=true);
            }
            }
    else
        translate([x,100,0]){   // cutout der Haube
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
            
            *fuseCoverMask(x=220, type=0);
            fuseCoverMask(x=120, r=45, h=120, type=3);
            *fuseCoverMask(x=0, r=60, h=120, type=2);
            fuseCoverMask(x=30, r=45, h=70, type=3);
            
            translate([-280,0,0]){   // cutout inner Motormount
                rotate([0,90,0]) cylinder( d=30, h=40 );
                }
            translate([-310,0,0]){   // cutout outer Motormount
                rotate([0,90,0]) cylinder( d=35, h=40 );
                }
                
            xTube( diameter=dBar1+2, length=100, tubeoffset=tubeOffset1, $fn=50 );
            mirror([0,0,1]) xTube( diameter=dBar1+2, length=100, tubeoffset=tubeOffset1, $fn=50 );
            xTube( diameter=dBar2+2, length=100, tubeoffset=tubeOffset2, $fn=50 );
            mirror([0,0,1]) xTube( diameter=dBar2+2, length=100, tubeoffset=tubeOffset2, $fn=50 );
            
            translate([-260,0,+30])
                rotate([0,-90,0])
                    cylinder(d=10,h=30);
            translate([-260,0,-30])
                rotate([0,-90,0])
                    cylinder(d=10,h=30);
             fuseSkid();
             
             translate([260,-8,+23]) rotate([8,0,0 ]) scale(8) fuseNaca(w=-10);
             translate([260,-8,-23]) rotate([180-8,0,0 ]) scale(8) fuseNaca(w=-10);

            }
        }
       
       *wingSegment( [s[0],s[1]], [o[0],o[1]], do = 2 );
       *mirror( [0,0,1] ) wingSegment( [s[0],s[1]], [o[0],o[1]], do = 2 );
}

module fuseSegment( seg=0 )
{
    length = 160;
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

module fuseCoverFront()
{
    coverSkin = 2;
    Slice(){
        innerSkin(){
            fuseSolid( r=0 );
            union(){
                fuseSolid( r=-coverSkin );
                #translate([250,40,0]) rotate([-90,0,0 ]) scale(6) fuseNaca(w=-10+11);
                }
            }
        *fuseCoverMask(x=220, type=0);
        fuseCoverMask(x=120, r=45, h=120, type=3);
        }
}

module fuseCoverMid()
{
    coverSkin = 2;
    Slice(){
        innerSkin(){
            fuseSolid( r=0 );
            union(){
                fuseSolid( r=-coverSkin );
                #translate([100,50,0]) rotate([-90,0,0 ]) scale(6) fuseNaca(w=-10);
                }
            }
        *fuseCoverMask(x=0, r=60, h=120, type=2);
        fuseCoverMask(x=30, r=45, h=70, type=3);
        }
}

module fuseMotor()
{
// 19mm Löcher, Motokreuz: Balken mit 2 Schrauben, Gegenstück in den Rumpf kleben....
    difference()
    {
        union()
        {
            translate([-280,0,0]){   // cutout inner Motormount
                rotate([0,90,0]) cylinder( d=30-0.3, h=5 );
                }
            translate([-282,0,0]){   // cutout outer Motormount
                rotate([0,90,0]) cylinder( d=35-0.3, h=3 );
                }
        }
        union()
        {
            translate([-270,0,0]) 
                    rotate([0,-90,0]) 
                        cylinder( d=7, h=40 );   
            translate([-270,0,0])
                rotate([0,-90,0])
                    for( rot=[0:90:360] )
                        hull()
                        {
                            rotate([0,0,rot+45])
                                translate([0,13/2,0])
                                        cylinder( d=3.5, h=40 );
                            rotate([0,0,rot+45])
                                translate([0,19/2,0])
                                        cylinder( d=3.5, h=40 );
                        }
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
    Slice(){
        innerSkin(){
            fuseSolid( r=0 );
            fuseSolid( r=-0.5 );
            }
        translate([200,-25,0]) rotate([90,0,0]) resize([3*45-r,45-r,45-r]) cylinder(d=45,h=50);
        }

    
    
    
    
}

module fuseConnect( w=10, h=2 )
{
    mask()
    {
        outerSkin(d = h )
            children();
        cube( [w,100,100], center=true );
    }
}

module tubeConnectCut()
{
    minkowski(){
        hull(){
            tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=6 );
            }
        cylinder(r=0.8,h=0.8);
        }
}

module tubeConnect( d1=8, d2=6, h=10, a=8, w=3 )
{
    // min a is d1?
    difference(){
        hull(){
            rotate( [0,+tubeAng,0] )
                cylinder(d=d2+w, h=h, center = true );
            translate( [0,-a,0] )
                rotate( [0,90,0] )
                    cylinder(d=d1+w, h=h, center = true );
            translate( [0,-a-h,0] )
                rotate( [0,90,0] )
                    cube([d1+w,h,h], center = true );

                }
        rotate( [0,+tubeAng,0] )
            cylinder(d=d2, h=h+10, center = true );
        translate( [0,-a,0] )
            rotate( [0,90,0] )
                cylinder(d=d1, h=h+10, center = true );
        translate( [0,-a-h,0] )
            rotate( [0,90,0] )
                cube([1,h+10,h+10], center = true );
        translate( [0,-a-h,0] )
            cylinder(d=2.2, h=h+10, center = true );
        translate( [0,-a-h,-5] )
            cylinder(d=4.5, h=3, center = true, $fn=6 );
        translate( [0,-a-h,+5] )
            cylinder(d=4.5, h=3, center = true );
        }
}

module tubeFlansch( d=6, a=8, h=40, w=3 )
{
    
    rotate([0,-90,0])
    difference(){
        union(){
            hull(){
                translate([0,-a,0]) cylinder(d=d+w, h=h, center = false );   
                translate([-d,0,0]) cube([2*d,0.1,h]);  // Fehlt: naca profil abbilden
                }
            translate([-1.5,0,0]) cube([3,20,h]);
            }
        translate([0,-a,-1]) cylinder(d=d, h=h+2, center = false );
        }
}
