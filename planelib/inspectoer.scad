// Inspectoer

$fn=50;

include <profiles.scad> // wing profile polygon definition
include <profiles2.scad> // wing profile polygon definition, use this later
include <skin.scad> // skin funktionen
include <wing.scad> // spant , segment funktionen, brauchen o[] und s[]
include <polyline.scad> 
include <servo.scad>
include <screw.scad>
include <ruder3.scad> 
include <motor.scad>  
include <vista.scad>
include <wingbow.scad> // wingbow functions and experiments with polyhedron, rotated profiles profilen etc
include <fuselage.scad> // fuselage functions

// inspectoer wing data:
sf= 30/500; // forward = 30mm pro 500mm  (550???)
o = [   [+sf*0,   0, 50],     
        [+sf*100, 0, 150],
        [+sf*300, 0, 350],
        [+sf*500, 0, 550], 
        [+sf*530, 0, 580] // gerade Randbogen als verlängerung? 
        ]; //offset: x,y,z 
s = [ 250, 234, 202, 170, 170-32/200*30 ]; //dsize is -32mm/200mm * dz

tubeOffset1 = 40; 
tubeOffset2 = tubeOffset1 + 80;
tubeOffsety = 3.5;
tubeAng1 = atan2( (o[3]-o[0]).z, -o[3].x - tubeOffset1*(s[0]-s[3]) ) - 90;
tubeAng2 = atan2( (o[3]-o[0]).z, -o[3].x - tubeOffset2*(s[0]-s[3]) ) - 90;
//tubeAng = (tubeAng1 + tubeAng2) / 2;    // different angles will make problems
tubeAng = 0;

dBar1 = 8.4;    // diameter of the front tube
lBar1 = 1005;   // length for front tube
dBar2 = 6.4;    // diameter of the rear tube
lBar2 = 400;    // length for rear tube, abs max length is 780 

zBoom = 150; //130+13;
wall = 0.5;

dPoly = 2.0;    // diameter of the polygon tubes
tailz0 = +8+4;  // z offset of the tail

// fuselage data, see module fuseSolid():
fuseWidth = 52;    // Rumpfbreite war 50
fuseLength0 = 325; // Spitze vor dem nullpunkt bei r=0 , war 355
fuseLength1 = 270; // hinterster Punkt - 5, die Länge in Dirks plan war 605mm,355+270=635,gemessen 640
fuseY0 = -10; // y offset of inner fuse
fuseMotorDia = 40;    // Durchmesser am Motor
fuseInnerSpant = 570;


// Ruder calculations:
ptWingNose = find_nose( c=sd6060_coords ); // SD6060 profile nose
ptQRuder = [1-0.32, ( p(1-0.32, pSD6060) + n(1-0.32, pSD6060) ) /2 ]; // 32% of the SD6060 profile
hQRuder = h( 1-0.32, pSD6060 );
ptHRuder = [1-0.35, ( p(1-0.35, pNaca0012) + n(1-0.35, pNaca0012) ) /2 ]; // 35% of the Naca0012 profile
hHRuder = h( 1-0.35, pNaca0012 );

z1 = 280;
p1 = RuderGetPoint( z1, zStart=o[0].z , zStop=o[3].z, s[0], s[3], ptQRuder );
o1 = RuderGetXOffset( z1, zStart=o[0].z , zStop=o[3].z, o[0].x, o[3].x );
d1 = RuderGetHeight( z1, zStart=o[0].z , zStop=o[3].z, s[0], s[3], hQRuder );
//echo( z1, p1, o1, d1);

z2 = 530;
p2 = RuderGetPoint( z2, zStart=o[0].z , zStop=o[3].z, s[0], s[3], ptQRuder );
o2 = RuderGetXOffset( z2, zStart=o[0].z , zStop=o[3].z, o[0].x, o[3].x );
d2 = RuderGetHeight( z2, zStart=o[0].z , zStop=o[3].z, s[0], s[3], hQRuder );
//echo( z2, p2, o2, d2);

zh1 = 20-zBoom;
ph1 = RuderGetPoint( zh1, zStart=0 , zStop=zBoom, 120, 120, ptHRuder );
oh1 = RuderGetXOffset( zh1, zStart=0 , zStop=zBoom, 0, 0 );
dh1 = RuderGetHeight( zh1, zStart=0 , zStop=zBoom, 120, 120, hHRuder );
//echo( zh1, ph1, oh1, dh1);

zh2 = zBoom-20;
ph2 = RuderGetPoint( zh2, zStart=0 , zStop=zBoom, 120, 120, ptHRuder );
oh2 = RuderGetXOffset( zh2, zStart=0 , zStop=zBoom, 0, 0 );
dh2 = RuderGetHeight( zh2, zStart=0 , zStop=zBoom, 120, 120, hHRuder );
//echo( zh2, ph2, oh2, dh2);


module wingSolid(r=0)
{
    for(i=[0:len(o)-2]) 
        segment(s=[s[i],s[i+1]], o=[o[i],o[i+1]], r=0);
}

module wingSegment( s=[s[0],s[1]], o=[o[0],o[1]] )
{
    
    difference(){
        union(){
            linearSlice( sx=s[0], sh=o[1].z-o[0].z, org=o[0], center=true ){
                union(){
                    segment(s, o, r=0);
                    wingMotorCoverSolid();
                    }
                }
            }
        union(){    
            mirror([0,0,1]) ServoDiff(sx=70,sy=6,sz=-(350+17),rot=0);

            wingBoom();
            xTube( diameter=dBar1, length=lBar1, tubeoffset=tubeOffset1 );
            xTube( diameter=dBar2, length=lBar2, tubeoffset=tubeOffset2 );

            wingPolyLine( d=dPoly, pt=ptWingNose, off=[+2,+0.5] );
            wingPolyLine( d=dPoly, pt=ptQRuder, off=[+0,+0] );
            wingElectric();
            mirror([0,0,1]) fuseWingMount(dx=0.2);
             
            wingMotor(diff=0.3, holes=false);
            wingMotorPlate(diff=0.3, holes=false);
            
            for(i=[1:len(o)-1])
                translate(o[i] - s[i]*[ptQRuder.x , ptQRuder.y, 0] + [-30,2.5,0] ) 
                    cylinder( d=dPoly, h=10, center=true ); // glue helper
            
            wingConnect(d=0.2);
            
            // ruder glue helper is missing??

            translate([5-35,10+2-15,zBoom-13])
                translate([-113,8,0]) cylinder(d=3.5,h=10); //hole for screw in wingMotor(), used for tail mount



            }
    }
}


module wingConnect( d=0 )
{   
    difference()
    {
        intersection()
        {
            wingSolid(r=0);
            translate( [-tubeOffset1-70+10,-20,o[2].z] ) cube([70+d,40+d,12+d], center= false ); //body
        }
       
        if( d==0 ){
        #translate( [-tubeOffset1-17+10-3, 3, o[2].z] ) cube([17+3,1,12], center= false ); //cut
        xTube( diameter=8, length=lBar1, tubeoffset=tubeOffset1 );  //tube 8mm,dBar1 will not work
        mirror([0,0,1]) ServoDiff(sx=70,sy=6,sz=-(350+17),rot=0);   // servo, what about the electric connection?
        
        translate( [-tubeOffset1+6.5, +3, o[2].z+12/2 ] ) 
            rotate([-90,0,0])
                ScrewAndHexNut( m=2 );
        
        translate( [-tubeOffset1-16.3, 6+0.5, o[2].z+4 ] ) 
            ScrewServo( dist=10 );
        translate( [-tubeOffset1-16.3-27.5, 6-0.5 , o[2].z+4 ] ) 
            ScrewServo( dist=10 );
            
        wingElectric();
        }
    }
}

module wingElectric()
{
    off1 = (tubeOffset1+tubeOffset2)/2;
    l1 = 770;
    translate([-off1 + o[0].x-8,-2-2,0])  // based of the 1st segment
        translate([0,4,0]) cube( [12,6,l1],center=true);
    l2= 290-2;
    translate( [ o[0].x-8, 5,0 ] )
        hull(){
            translate([-2,-2,0]) cylinder(d=4,h=l2,center=true );
            translate([-18,-3,0]) cylinder(d=4,h=l2,center=true );
            translate([-18,+3,0]) cylinder(d=4,h=l2,center=true );
        }
}

module xTube( diameter=6, length=1200, tubeoffset=tubeOffset1 )
{
    translate([-tubeoffset,tubeOffsety,0] )  
        cylinder(d=diameter, h=length, center=true); // inner tube
}

module tail() 
{
    HRuder();
    
    mirror([0,0,1]) sideSolid();
    sideSolid();
    
    tubeFlansh2();
    mirror([0,0,1]) tubeFlansh2();

	*wingBowDraw( vbase = [0, 0, 0], p=pNaca0012, baseSize=120, z0=20, offset=[38, 0, 0], pos=[-420, 15-2++tailz0-3, zBoom+10] ); 
	*mirror([0,0,1]) wingBowDraw( vbase = [0, 0, 0], p=pNaca0012, baseSize=120, z0=20, offset=[38, 0, 0], pos=[-420, 15-2++tailz0-3, zBoom+10] ); 
    
    //if($preview){
    color( "BLACK") translate([-40, tailz0, +zBoom]) rotate([0,-90,0]) cylinder(d=8,h=450);
    color( "BLACK") translate([-40, tailz0 ,-zBoom]) rotate([0,-90,0]) cylinder(d=8,h=450);
    //}

}

module sideSolid(r=0)
{
    bardist = 130;
    yoff=15-2;
    difference(){
        translate([-420, tailz0-2.5+yoff, -zBoom-3+1]) 
		union(){
			hull(){
				translate([0,0,0]) rotate([90,0,0]) spant3d( d=0.3, offset=[0,0,0], size=120, r=r, p=pSD6060 );
				translate([0,zBoom,0]) rotate([90,0,0]) spant3d( d=0.3, offset=[10,0,0], size=58, r=r, p=pSD6060 );
				}
				// nice, but how can this be printed? separate!
				translate([10,zBoom,0]) sideSolidB();
			}
        heigtSolid();        
        mirror( [0,0,1] )tubeFlansh2(r=0.2);
		translate([-420, yoff+tailz0-3, 0])
			heigtSolid(r=0);
    }
}

module sideSolidB()
{
	rotate([90,0,0]) 
		mirror([0,0,1])
		wingBowDraw( vbase = [0, 0, 0], p=pSD6060, baseSize=58, z0=10, offset=[19, 0, 0], pos=[0,0,0] );

}

module HRuder()
{
    yoff = 15-2;
    difference()
    {
        // HR wind profile
        translate([-420, yoff+tailz0-3, 0])
        Ruder3( ptStart=[-ph1.x+oh1,+ph1.y,zh1], dStart=dh1, 
                ptStop=[-ph2.x+oh2,+ph2.y,zh2], 
                dStop=dh2, dSpace=0.8, steps=5, inverse=true )
            heigtSolid(r=0);
// to do:  servo cable channel, 
        // ruder horn cutout
        *translate([-420, yoff+tailz0-3, 0])
            RuderHornCut( dh1, pos = [-ptHRuder.x*120, +ptHRuder.y*120, 0],diff=0  );
        
        // ruder horn, use as separte object with higher density
        translate([-420, yoff+tailz0-3, 0])
            RuderHorn( dh1, pos = [-ptHRuder.x*120, +ptHRuder.y*120, 0],diff=0.2  );
            
        // servo cutout    
        ServoDiff(sx=460-8,sy=yoff+tailz0-5,sz=-3-13,rot=0,yadd=3); // todo: das servo nach unten dicker machen damit es unten durch schaut und es mussweiter hoch
        
        // helper to glue the split ruder
        #translate( [-420 - 120 * ptHRuder.x ,yoff+tailz0-3 + 120 * ptHRuder.y, 0] ) 
            cylinder( d=dPoly, h=10, center=true ); // glue helper , missing in RuderHorn() ?
         
        // horizontal hole to mount ruder
        hull(){
            translate( [-420 - 120 * ptHRuder.x , yoff+tailz0-3 + 120 * ptHRuder.y, -zBoom-40] ) sphere(d=dPoly); 
            translate( [-420 - 120 * ptHRuder.x , yoff+tailz0-3 + 120 * ptHRuder.y, +zBoom+40] ) sphere(d=dPoly); 
            } // poly for full length
            
        // horizontal hole in nose
        hull(){
            translate( [-420 - 2, yoff+tailz0-3 + 120 * ptHRuder.y, -zBoom-40] ) sphere(d=dPoly); 
            translate( [-420 - 2, yoff+tailz0-3 + 120 * ptHRuder.y, +zBoom+40] ) sphere(d=dPoly); 
            } // poly for full length
            
        // mount on tube    
        tubeFlansh2(r=0.2);
        mirror([0,0,1])tubeFlansh2(r=0.2);

        // boom bars cutout in HR
        translate([-40, tailz0, +zBoom]) rotate([0,-90,0]) cylinder(d=8+0.2,h=450); // offset as tubeFlansh2()
        translate([-40, tailz0 ,-zBoom]) rotate([0,-90,0]) cylinder(d=8+0.2,h=450);
        
        //servo kable
        hull(){
            translate([-420-53+6,yoff+6,-25]) cube([12,6,10], center=true ); // servo cable
            translate([-420-65,yoff+8,-zBoom+12]) cube([12,6,10], center=true ); // servo cable too near to the tube, but elese in conflic to the ruder
            }
		translate([-420-65,yoff+3,-zBoom+12]) cube([12,6+10,10], center=true );
        }
        



    *hull(){ 
            translate([+20-ptHRuder.x*120, -3+ptHRuder.y*120, -4-dPoly]) sphere(d=dPoly); 
            translate([+20-ptHRuder.x*120, -3+ptHRuder.y*120, +3+dPoly]) sphere(d=dPoly); 
            }
    *hull(){ 
            translate([+20-2, -3, -4-dPoly]) sphere(d=dPoly); 
            translate([+20-2, -3, +3+dPoly]) sphere(d=dPoly); 
            }
    *translate([-420, tailz0-3, 0])
        RuderHorn( dh1, pos = [-ptHRuder.x*120, +ptHRuder.y*120, 12.5],diff=0.2  ); // manual adjusted to servo

}


module heigtSolid(r=0)
{
    br = zBoom+10;
    hull(){
        translate([0,0,-br]) spant3d( d=0.3, offset=[0,0,0], size=120, r=r, p=pNaca0012 );
        translate([0,0,+br-0.3]) spant3d( d=0.3, offset=[0,0,0], size=120, r=r, p=pNaca0012 );  // 0.3 is the spantsize, has to considderd on positive side
        }
	wingBowDraw( vbase = [0, 0, 0], p=pNaca0012, baseSize=120, z0=20, offset=[38, 0, 0], pos=[0,0,br] ); 
	mirror([0,0,1]) wingBowDraw( vbase = [0, 0, 0], p=pNaca0012, baseSize=120, z0=20, offset=[38, 0, 0], pos=[0,0,br] ); 
		
}







