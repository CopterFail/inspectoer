// test für oberflächen

$fn=50;

include <profiles.scad> // wing profile polygon definition, ClarkY
include <skin.scad> // skin funktionen
include <wing.scad> // spant , segment funktionen, brauchen o[] und s[]

sf= 30/500; // forward = 30mm pro 500mm  (550???)
o = [   [+sf*0,   0, 50],     
        [+sf*100, 0, 150],
        [+sf*300, 0, 350],
        [+sf*500, 0, 550] ]; //offset: x,y,z 
s = [ 250, 230, 200, 170 ]; //size = factor   250 - (z-50)*

tubeOffset1 = 0.25; 
tubeOffset2 = 0.5; /*-s[0]/3;*/    // tube offset
tubeAng1 = atan2( (o[3]-o[0]).z, -o[3].x - tubeOffset1*(s[0]-s[3]) ) - 90;
tubeAng2 = atan2( (o[3]-o[0]).z, -o[3].x - tubeOffset2*(s[0]-s[3]) ) - 90;
//echo(tubeAng1 , tubeAng2);
solidOffset1 = 0.2;
solidOffset2 = 0.55;

tubeOffset3 = -160; /*-s[0]/3;*/    // tube offset
dRips = 1;      // strength of the rips
yRips = 40;     // distance of the rips
dSkin = 0.4;    // strength of the outer hull
dBar1 = 6.4;    // diameter of the 1st tube
dBar2 = 4.5;    // diameter of the 2nd tube
zBoom = 130;


servo_size_1 = [24,20,36];  // mg90s
servo_size_2 = [32.6,20,3];
wall = 0.5;
ruderseg=2;
ruderrot=11;


*exploreWing();
*mirror( [0,0,1] ) exploreWing();
*exploreFuse();

//solid:
*wingSolid();
*mirror( [0,0,1] ) wingSolid();
*translate([-250,0,0])wingSolid();
*translate([0,0,0])wingSegment([s[0],s[1]], [o[0],o[1]]);
wingSegment( [s[2],s[3]], [o[2],o[3]] );
*segment( s=[s[0],s[1]], o=[o[0],o[1]], r=0, p=pSD6060, begin=solidOffset1, end=solidOffset2 )

*fuse0();
*fuseSolid();  
*fuseSkin(); 
*translate([335,0,50]) spant3d( d=0.3, offset=[0,0,0],    size=605,   r=0, p=pClarkFuse );
*fuseNaca();


*translate([0,-25,0]) color("Red") fuseSkid();

*hinterteil();
*test();
*test2();
*polyline( size=605, p=pClarkFuse ); 

module test()
{
    seg=0;
    translate([0,-25,0])
        difference(){
            union(){
                *spant3dDiff( d=0.4, offset=o[seg], size=s[seg], ri=0);
                gridSlice(dy = yRips) // die Rippen
                    outerSkin(d = dRips ) 
                        segment(seg, r=-dRips-dSkin );
                outerSkin(d = dSkin, h = dSkin)     // die Haut
                    segment(seg, r=-dSkin);
                intersection(){
                    union(){
                        translate([tubeOffset1,0,0])
                            xBarTube( length=1000, xsize=60, diameter=dBar1, $fn=50 );
                        translate([tubeOffset2,0,0])
                            xBarTube( length=1000, xsize=60, diameter=dBar2, $fn=50 );
                        }
                    segment(seg, r=0);
                    }
                 }
            union(){
                translate([tubeOffset1,0,0])
                    xTube( diameter=dBar1, length=1000, $fn=50 );
                translate([tubeOffset2,0,0])
                    xTube( diameter=dBar2, length=1000, $fn=50 );
                }
            }
    translate([0,+25,0])
        difference(){
            segment(seg, r=0);
            union(){
                translate([tubeOffset1,0,0])
                    xTube( diameter=dBar1, length=1000, $fn=50 );
                translate([tubeOffset2,0,0])
                    xTube( diameter=dBar2, length=1000, $fn=50 );
                }
           }
        
}

module test2()
{
    seg=0;
    translate([0,+25,0])
        difference(){
            segment(seg, r=0);
            union(){
                translate([tubeOffset1,0,0])
                    xBarTube2( diameter=dBar1, length=1000, xsize=60, w=0.1, $fn=50 );
                translate([tubeOffset2,0,0])
                    xBarTube2( diameter=dBar2, length=1000, xsize=60, w=0.1, $fn=50 );
                translate([tubeOffset3,0,0])
                    xBarTube2( diameter=0, length=1000, xsize=60, w=0.1 , $fn=50 );
                }
           }
}


module exploreFuse()
{
    show([20,0,0]){
        fuseMotor();
        fuseSegment( seg=0 );
        fuseSegment( seg=1 );
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
        *fuseSegment( seg=1 );
        translate([-20,0,0]) exploreFuse();
        wingSegment([s[0],s[1]], [o[0],o[1]]);
        union(){
            translate([tubeOffset1,0,zBoom]) tubeConnect( d1=dBar1, d2=dBar1+2, a=8, w=3 );
            translate([tubeOffset2,0,zBoom]) tubeConnect( d1=dBar1, d2=dBar1, a=8, w=3 );
            translate([tubeOffset2-150,-8,zBoom]) 
                rotate([0,90,0])  
                    xTube( length=440, diameter=dBar1, $fn=50 );
            translate([-420,0,zBoom]) tubeFlansch();
            translate([-420,30,0]) heigtSolid(r=0);
            translate([-420,60,zBoom]) sideSolid(r=0);
            }
        wingConnect(d=4, r=-0.5, width=12 /*1.4*/, offset=o[1], size=s[1] );
        wingSegment([s[1],s[2]], [o[1],o[2]]);
        wingConnect(d=4, r=-0.5, width=1.4, offset=o[2], size=s[2] );
        wingSegment([s[2],s[3]], [o[2],o[3]]);
        wingConnect(d=4, r=-0.5, width=1.4, offset=o[3], size=s[3] );
        lastsegment();
        }
        
        translate([tubeOffset1,0,500/2])
            xTube( length=500, diameter=dBar1, $fn=50 );
        translate([tubeOffset2,0,500/2])
            xTube( length=500, diameter=dBar2, $fn=50 );
        translate([tubeOffset1,0,zBoom/2+10])
            xTube( length=zBoom, diameter=dBar1+2, $fn=50 );
        translate([tubeOffset2,0,zBoom/2+10])
            xTube( length=zBoom, diameter=dBar2+2, $fn=50 );
            
        
    
}

module wingSolid(r=0)
{
    for(i=[0:len(o)-2]) segment(i, r);
    lastsegment();
}

module wingSegment( s=[s[0],s[1]], o=[o[0],o[1]] )
{
    *translate(o[0]-[s[0]*1.5,s[0]*0.5,0]) cube( [s[0]*2,s[0],o[1].z-o[0].z], center=false  );
        difference(){
            union(){
                linearSlice( sx=s[0], sh=o[1].z-o[0].z, org=o[0], center=true )
                union(){
                    *spant3dDiff( d=0.4, offset=o[0], size=s[0], ri=-4 ); // der Boden

                    gridSlice(dy = yRips) // die Rippen
                        outerSkin(d = dRips, h=dSkin ) 
                            segment( s, o, r=-dRips-dSkin );
                    outerSkin2(d = dSkin, h=dSkin){     // die Haut
                        segment(s, o, r=-dSkin);
                        segment(s, o, r=-dSkin, begin=solidOffset1 , end=solidOffset2 );
                        }
                    }
                    
                intersection(){
                    union(){
                    echo( o , s );
                        translate([-tubeOffset1 * s[0] + o[0].x,0,o[0].z])
                        rotate([0,tubeAng1,0])
                            xBarTube( length=1000, xsize=60, diameter=dBar1, $fn=50 );
                        translate([-tubeOffset2 * s[0] + o[0].x,0,o[0].z])
                        rotate([0,tubeAng2,0])
                            xBarTube( length=1000, xsize=60, diameter=dBar2, $fn=50 );
                        }
                    segment(s, o, r=0);
                    }
                    
                *if(ruderseg==seg){
                    RuderSkin( seg, size=45,d=0 );
                    ServoSkin( seg );
                    }
                }
                
            union(){
                translate([-tubeOffset1 * s[0] + o[0].x,0,o[0].z])
                    rotate([0,tubeAng1,0])
                        #xTube( diameter=dBar1, length=1000, $fn=50 );
                translate([-tubeOffset2 * s[0] + o[0].x,0,o[0].z])
                    rotate([0,tubeAng2,0])
                        #xTube( diameter=dBar2, length=1000, $fn=50 );
                wingConnect(d=4, r=-dSkin+0.1, width=1.5, offset=o[0], size=s[0] );
                wingConnect(d=4, r=-dSkin+0.1, width=1.5, offset=o[1], size=s[1] );
                }
            *if(ruderseg==seg){
                RuderDiff( seg, size=45,d=0.3 );
                ServoDiff( seg );
                }
        }

}

module RuderSkin(i=0, size = 45, d=0.3 )
{
    // dreicksleiste, cut ruder
    db = 10; // abstand vom rand 
    module triangle( a=20,h=100 ){
        b=a/3;
        w=0.4;
        pt = [[ 0-w, 0],[ 0, 0],[ 0+w, 0], [+b+w,+a], [-b-w,+a]];
        rotate([0,ruderrot,0])
            linear_extrude( height=h, center=false ) 
                polygon( pt );
    }
    sx = s[i];
    hz = o[i+1].z-o[i].z - 2 *db; 
    intersection(){
        difference(){
            union(){
                translate( o[i] + [-s[i]+size + db ,+d/2, db])
                    triangle( a=20,h=hz+2 );
                translate( o[i] + [-s[i]+size + db,-d/2, db])
                    mirror([0,1,0]) triangle( a=20,h=hz+2);
                }
            *translate( o[i] + [-s[i]+size,0,hz*1/5])
                cube([6,1,hz/8],center=true);
            *translate( o[i] + [-s[i]+size,0,hz*4/5])
                cube([6,1,hz/8],center=true);
                }
        segment(i,r=0);
    }
}

module RuderDiff(i=0, size = 45, d=0.3 )
{
 // dreicksleiste, cut ruder, 3mm hole   
    db = 10; // abstand vom rand
 
    module triangle( a=20,h=100 ){
        b=a/3;
        pt = [[ 0, 0], [+b,+a], [-b,+a]];
        rotate([0,ruderrot,0])
            linear_extrude( height=h, center=false ) 
                polygon( pt );
    }
    sx = s[i];
    hz = o[i+1].z-o[i].z - 2 * db;
    union(){
        translate( o[i] + [-s[i]+size + db ,0,db]) // dreiecksleiste oben
            triangle( a=20,h=hz ); // dreiecksleiste unten
        translate( o[i] + [-s[i]+size +db, 0, db])
            mirror([0,1,0]) triangle( a=20,h=hz );
            *translate( o[i] + [-s[i]+size,0,hz*1/5])
                cube([6,0.5,hz/8],center=true);   // verbinder unten
            *translate( o[i] + [-s[i]+size,0,hz*4/5])
                cube([6,0.5,hz/8],center=true);   // verbinder oben
            translate( o[i] + [-s[i]+size + db + hz*sin(ruderrot), -size/2, db + hz*cos(ruderrot) ])
                rotate([0,ruderrot+180,0])
                    cube([size+2,40,1],center=false);   // 1mm trenner oben, 
            translate( o[i] + [-s[i]+size + db , -size/2, db] )
                rotate([0,ruderrot+180,0])
                    cube([size+2,40,1],center=false);   // 1mm trenner unten, 
            translate( o[i] + [-s[i]+size + db, -size/2, db])
                rotate([0,ruderrot,0])
                    cube([0.1,40,hz],center=false);   // 0.1mm trenner gesammtes ruder
            
    }
}

module ServoSkin( i=0 )
{
    module servo(){
        cube( servo_size_1 + [4*wall,4*wall,4*wall], center=true );
        translate([0,0,4]) 
            cube( servo_size_2 + [4*wall,4*wall,4*wall], center=true );
 
        //Fehlt: drehung, 60 grad Rampe zum drucken
        
        //support:
        translate([0,0,-1.5]) rotate([-30,0,0])
            cube( servo_size_2 + [4*wall,4*wall,4*wall+1], center=true );
        translate([0,7.9,-7.9]) rotate([-30,0,0])
            cube( servo_size_1 + [4*wall,4*wall,4*wall], center=true );
        
    }
    sx = s[i];
    hz = o[i+1].z-o[i].z;
    intersection(){
        translate( o[i] + [-s[i]/2, +11, hz/2])
            rotate([0,ruderrot,4])
                servo();
        segment(i,r=0);
    }
}

module ServoDiff( i=0 )
{ 
    module servo(){
        cube( servo_size_1, center=true );
        translate([0,0,4]) 
            cube( servo_size_2, center=true );
    }
    sx = s[i];
    hz = o[i+1].z-o[i].z;
    translate( o[i] + [-s[i]/2, +11, hz/2])
            rotate([0,ruderrot,4])
                servo();
                
    translate( o[i] + [-s[i]/2+10, +11-2-2, hz/2-13])
            rotate([0,90,4])
                cylinder(d=10, h=10);
}

module xTube( diameter=6, length=100 )
{
    rotate([0,0,0]) cylinder(d=diameter, h=length, center=true); // inner tube
}

module xBarTube( length=600, xsize=30, diameter=6, w=0.8 )
{
    // w=0.8 is 2 walls
    difference(){
        union(){
            rotate([0, 0, +45]) cube([xsize,w,length], center=true);    // X-bar
            rotate([0, 0,-45]) cube([xsize,w,length], center=true);
            rotate([0,0,0]) cylinder(d=diameter+2*w, h=length, center=true); // outer tube
            xTube( diameter=diameter+2*w, length=length );
        }
        
        union(){
            *xtube(diameter=diameter, length=length+2);
            for( y=[-length/2:1.0*xsize:+length/2] )    // holes to reduce weight
                translate([0,0,y])
                    rotate([90,0,0]) 
                        scale([0.38,0.7,1])
                        cylinder(d=xsize, h=xsize, center=true);
        }
    }        
}

module xBarTube2( length=600, xsize=30, diameter=6, w=0.8 )
{
    // w=0.8 is 2 walls
    difference(){
        union(){
            rotate([0, 0, +45]) translate([(xsize+diameter)/2+0.8+0*w,0,0]) cube([xsize,w,length], center=true);    // X-bar
            rotate([0, 0,+135]) translate([(xsize+diameter)/2+0.8+0*w,0,0]) cube([xsize,w,length], center=true);    // X-bar
            rotate([0, 0,-135]) translate([(xsize+diameter)/2+0.8+0*w,0,0]) cube([xsize,w,length], center=true);    // X-bar
            rotate([0, 0,-45])  translate([(xsize+diameter)/2+0*w,0,0]) cube([xsize,w,length], center=true);

            rotate([0,0,0]) cylinder(d=diameter+2*w, h=length, center=true); // outer tube
            xTube( diameter=diameter+2*w, length=length );
        }
        
        union(){
            *xTube(diameter=diameter, length=length+2);
            *for( y=[-length/2:1.0*xsize:+length/2] )    // holes to reduce weight
                translate([0,0,y])
                    rotate([90,0,0]) 
                        scale([0.38,0.7,1])
                        cylinder(d=xsize, h=xsize, center=true);
        }
   }

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

module fuse()
{
    Slice(){
        fuse0();
        cube([50,100,100],center=true);
        }
}
module fuse0()
{
    gridSlice(dy = 20)             // die Rippen
        translate([0,0,0])  // 
            outerSkin(d = 2, h=0.8 ) 
                fuseSolid(r=-2.8);    // 2.8 = 2(grid) + 0.8(outer skin)
    outerSkin(d = 0.8, h=0.8 ) 
                fuseSolid(r=-0.8);
    translate([0,0,-0.15]) spant3d( d=0.3, offset=o[0], size=s[0] );
    translate([0,0,-0.15]) spant3d( d=0.3, offset=-o[0], size=s[0] );
    // spant3d ist nicht zentriert!!!!
    
    fuseConnect(h=2)          
        fuseSolid(r=-2.8);
      
    *fuseSolid();
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
            *gridSlice(dy = yRips) // die Rippen
                outerSkin(d = dRips ){ 
                    fuseSolid( r=-dRips-fuseSkin );
                    }
            *outerSkin(d = fuseSkin, h = fuseSkin){     // die Haut
                fuseSolid( r=0 );
                *segment( 0 ); 
                *mirror( [0,0,1] ) segment( 0 ); 
                }
            fuseSolid( r=0 );
            }
        union(){
            *hull(){
                segment( 0 ); 
                mirror( [0,0,1] ) segment( 0 ); 
                }                    
            fuseSolid( r=-fuseSkin );
            fuseCoverMask(x=220, type=0);
            fuseCoverMask(x=0, r=60, h=120, type=2);
            translate([-280,0,0]){   // cutout inner Motormount
                rotate([0,90,0]) cylinder( d=30, h=40 );
                }
            translate([-310,0,0]){   // cutout outer Motormount
                rotate([0,90,0]) cylinder( d=35, h=40 );
                }
            translate([tubeOffset1,0,0])
                xTube( diameter=dBar1+2, length=1000, $fn=50 );
            translate([tubeOffset2,0,0])
                xTube( diameter=dBar2+2, length=1000, $fn=50 );
            translate([-260,0,+30])
                rotate([0,-90,0])
                    cylinder(d=10,h=30);
            translate([-260,0,-30])
                rotate([0,-90,0])
                    cylinder(d=10,h=30);
             fuseSkid();
             #translate([260,-8,+23]) rotate([8,0,0 ]) scale(8) fuseNaca(w=-10);
             #translate([260,-8,-23]) rotate([180-8,0,0 ]) scale(8) fuseNaca(w=-10);

            }
        }
       
       *wingSegment( 0 );
       *mirror( [0,0,1] ) wingSegment( 0 );
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

module fuseCoverFront()
{
    coverSkin = 2;
    Slice(){
        innerSkin(){
            fuseSolid( r=0 );
            fuseSolid( r=-coverSkin );
            }
        fuseCoverMask(x=220, type=0);
        }
}

module fuseCoverMid()
{
    coverSkin = 2;
    Slice(){
        innerSkin(){
            fuseSolid( r=0 );
            fuseSolid( r=-coverSkin );
            }
        fuseCoverMask(x=0, r=60, h=120, type=2);
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


module tubeConnect( d1=8, d2=6, h=10, a=8, w=3 )
{
    // min a is d1?
    difference(){
        hull(){
            cylinder(d=d2+w, h=h, center = true );
            translate( [0,-a,0] )
            rotate( [0,90,0] )
                cylinder(d=d1+w, h=h, center = true );
                }
        cylinder(d=d2, h=h+10, center = true );
        translate( [0,-a,0] )
        rotate( [0,90,0] )
            cylinder(d=d1, h=h+10, center = true );
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

module polyline( d=3, size=605, p=pClarkFuse )
{
    //translate([0,100,0])
    for( i=[0:(len(p)-2)] ){
        hull(){
            translate([p[i].x*size, p[i].y*size,0]) 
                sphere( d=d );
            translate([p[i+1].x*size, p[i+1].y*size,0]) 
                sphere( d=d );
            }
        echo( p[i] );
        }
}
