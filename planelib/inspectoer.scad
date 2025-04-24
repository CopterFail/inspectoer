// Inspectoer

$fn=50;

include <profiles.scad> // wing profile polygon definition
//include <profiles2.scad> // wing profile polygon definition, use this later
include <skin.scad> // skin funktionen
include <wing.scad> // spant , segment funktionen, brauchen o[] und s[]
include <polyline.scad> 
include <servo.scad>
include <screw.scad>
include <ruder2.scad> 
include <motor.scad>  
include <vista.scad>

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


// Ruder calculations:
iSD6060_32up    = 9;    // SD6060 profile index 32% upper side
iSD6060_Nose    = 29;   // SD6060 profile index nose
iSD6060_32down  = 47;   // SD6060 profile index 32% lower side

iN0012_35up     = 7;    // Naca0012 profile index 32% upper side
iN0012_Nose     = 31;   // Naca0012 profile index nose
iN0012_35down   = 55;   // Naca0012 profile index 32% lower side

ptQRuder = [ pSD6060[iSD6060_32up].x, 
            (pSD6060[iSD6060_32up].y+pSD6060[iSD6060_32down].y)/2 ];    
            //note: 9/51(25%) -> 12/48(37%) -> 11/49(32%)
hQRuder = pSD6060[iSD6060_32up].y - pSD6060[iSD6060_32down].y;

ptHRuder = [ pNaca0012[iN0012_35up].x, 
            (pNaca0012[iN0012_35up].y+pNaca0012[iN0012_35down].y)/2]; 
            //note: 5/57(25%) -> 7/55(35%)
hHRuder = pNaca0012[iN0012_35up].y - pNaca0012[iN0012_35down].y;

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


//solid:
*wingSolid();

*difference(){
    Ruder2( ptStart=[-p1.x+o1,+p1.y,z1], dStart=d1, ptStop=[-p2.x+o2,+p2.y,z2], dStop=d2, dSpace=0.8, steps=5 )
        union(){
            *wingSegment( [s[3],s[4]], [o[3],o[4]] ); // was last segment, replace with wingBow()
            wingSegment( [s[2],s[3]], [o[2],o[3]] );
            *wingSegment( [s[1],s[2]], [o[1],o[2]] );
            *wingSegment( [s[0],s[1]], [o[0],o[1]] );
            }
    RuderHorn( dbase=d1, pos = o[2] + [-ptQRuder.x*s[2], +ptQRuder.y*s[2], 0], diff=0.2  ); /*dSpace is 0.8*/         
}
*RuderHorn( dbase=d1, pos = o[2] + [-ptQRuder.x*s[2], +ptQRuder.y*s[2], 0]  ); /*dSpace is 0.8*/         
*wingBow();


*fuseSolid();  
*fuseSkin(); 
*fusePoly();
*translate([335,0,50]) spant3d( d=0.3, offset=[0,0,0],    size=605,   r=0, p=pClarkFuse );
*fuseCoverFront(d=0);
*fuseCoverHook( true );
*fuseCoverHook( false );
*translate([20,35,0]) rotate([90,90,0]) fuseCoverHookKnop();
*fuseSegment(0);
*fuseSegment(1);
*fuseSegment(2);
*fuseSegment(3);
*translate([10,0,0])  color("Red") cube([75,45,45],center=true); // akku
*fuseCoverFront();
*fuseCoverMid();
*fuseCoverBak();
*fuseSkid2( r=0.1 );
*fuseCoverMount_1()


*fuseWingMount(dx=0);
*mirror([0,0,1])fuseWingMount(dx=0);

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

            wingPolyLine( d=dPoly, pt=pSD6060[iSD6060_Nose], off=[+2,+0.5] );
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

module wingBow()
{
    difference(){
        //translate( o[3] + [ 0, -5.6, 24.85 ] )
        translate( [ 0.4, 0, -0.6 ] )
            rotate([0,-90,0])
                mirror([1,0,0])
                    scale( 110/133 + 0.02 )
                        import("Randbogen.stl");
        wingPolyLine( d=dPoly, pt=pSD6060[iSD6060_Nose], off=[+2,+0.5] );
        wingPolyLine( d=dPoly, pt=ptQRuder, off=[+0,+0] );
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
    mirror([0,0,1])tubeFlansh2();

    
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
        hull(){
            translate([0,0,0]) rotate([90,0,0]) spant3d( d=0.3, offset=[0,0,0], size=120, r=r, p=pSD6060 );
            translate([0,zBoom,0]) rotate([90,0,0]) spant3d( d=0.3, offset=[10,0,0], size=58, r=r, p=pSD6060 );
            }
        heigtSolid();        
        mirror( [0,0,1] )tubeFlansh2(r=0.2);
		translate([-420, yoff+tailz0-3, 0])
			heigtSolid(r=0);
    }
}

module HRuder()
{
    yoff = 15-2;
    difference()
    {
        // HR wind profile
        translate([-420, yoff+tailz0-3, 0])
        Ruder2( ptStart=[-ph1.x+oh1,+ph1.y,zh1], dStart=dh1, 
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
}









fuseWidth = 52;    // Rumpfbreite war 50
fuseLength0 = 325; // Spitze vor dem nullpunkt bei r=0 , war 355
fuseLength1 = 270; // hinterster Punkt - 5, die Länge in Dirks plan war 605mm,355+270=635,gemessen 640
fuseY0 = -10; // y offset of inner fuse
fuseMotorDia = 40;    // Durchmesser am Motor
fuseInnerSpant = 570;

module fuseSolid( r=0 )
{
    difference(){
        union(){
            hull()
            {
                *translate([-(fuseLength1 + r),0,0]) rotate([0,90,0]) cylinder(d=fuseMotorDia+2*r,h=5,center=true); //motor
                translate([0,0,-0.15])  spant3d( d=0.3, offset=(o[0]+[0,0,r]),  size=s[0],  r=r, p=pSD6060 );
                translate([fuseLength0,fuseY0,-0.15]) 
                    spant3d( d=0.3, offset=[0,0,fuseWidth/2+r],    size=fuseInnerSpant,   r=r, p=pClarkY /* pClarkFuse */ );
                translate([fuseLength0,fuseY0,-0.15]) 
                    spant3d( d=0.3, offset=[0,0,-(fuseWidth/2+r)], size=fuseInnerSpant,   r=r, p=pClarkY /* pClarkFuse */ );
                translate([0,0,-0.15])  spant3d( d=0.3, offset=-(o[0]+[0,0,r]), size=s[0],  r=r, p=pSD6060 );
            }
        }
        union(){
            fuseFinger( df=25-r );  // here r has only the half effect 
            mirror([0,0,1]) fuseFinger(  df=25-r  );
        }
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
module fuseFinger( df=25 )
{
    translate([-30,-58,-45-1])
    rotate([0,0,-30])
    rotate([-80,0,0])
    union(){
    cylinder(d=df,h=50);
    translate([0,0,50]) sphere( d=df );
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
            
            //fuseCoverMask(x=120, y=63-20+fuseY0, r=fuseWidth-10, h=100, type=3);
            //fuseCoverFront(d=0.3);

            fuseCoverMask(x=120, y=63-20+fuseY0, r=fuseWidth-10, h=80, type=3);
            fuseCoverFront(d=0.3);
            translate([161,35+10,0]) rotate([90,90,0]) cylinder(d=2.5, h=20);//fuseCoverHookKnop();

            fuseCoverMask(x=35, y=60-20+fuseY0, r=fuseWidth-10, h=90, type=3);
            fuseCoverMid(d=0.3);
            translate([-10,40,0]) rotate([90,90,0]) cylinder(d=2.5, h=20);//fuseCoverHookKnop();

            fuseCoverMask(x=-43, y=60-20+fuseY0, r=fuseWidth-10, h=45, type=3);
            fuseCoverBak(d=0.3);
            translate([-128,35-10,0]) rotate([90,90,0]) cylinder(d=2.5, h=20);//fuseCoverHookKnop();

            *translate([-80,35-10,0]) cube([60,80,36], center=true); // FC           
            *fuseMotor(d=0, holes=false);
            
            fuseGps();
            fuseElrs();
                
            xTube( diameter=dBar1+2, length=100, tubeoffset=tubeOffset1, $fn=50 );
            mirror([0,0,1]) xTube( diameter=dBar1+2, length=100, tubeoffset=tubeOffset1, $fn=50 );
            xTube( diameter=dBar2+2, length=100, tubeoffset=tubeOffset2, $fn=50 );
            mirror([0,0,1]) xTube( diameter=dBar2+2, length=100, tubeoffset=tubeOffset2, $fn=50 );
            
            translate([-210,-10,+30])
                rotate([0,-90,20])
                    cylinder(d=10,h=40,center=true);
            translate([-210,-10,-30])
                rotate([00,-90,20])
                    cylinder(d=10,h=40,center=true);
            *translate([-258,+20,0])
                rotate([00,-90,-20])
                    cylinder(d=10,h=80,center=true);

             fuseSkid();
             fusePoly();
             wingElectric();
             fuseCamera();
             
             
             translate([260,-2,+23]) rotate([8,0,0 ]) scale(7) fuseNaca(w=-10);
             translate([260,-2,-23]) rotate([180-8,0,0 ]) scale(7) fuseNaca(w=-10);
             
             fuseWingMount(dx=0.2);
             mirror([0,0,1])fuseWingMount(dx=0.2);
             
             *fuseFinger();

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

module fuseWingMount( pos=0, dx=0 )
{
    h1 = 5+dx;
    w1 = 8+dx;
    translate([0,tubeOffsety,-o[0].z-h1/2]) rotate([0,0,180])
        difference()
            {
            union()
                {
                translate([tubeOffset1,0,0]) cylinder( d = dBar1+2+2+dx, h = o[0].z+h1/2 );
                hull()
                    {
                    translate([tubeOffset1,0,0]) cylinder( d = 19+dx, h = h1 );
                    translate([tubeOffset1+0,-w1/2-4,0]) cube( [19,w1,h1]);
                    }

                translate([tubeOffset2,0,0]) cylinder( d = dBar2+2+2+dx, h = o[0].z+h1/2 );
                hull()
                    {
                    translate([tubeOffset2,0,0]) cylinder( d = 16+dx, h = h1 );
                    translate([tubeOffset2-16,-w1/2-4,0]) cube( [16,w1,h1]);
                    }
                translate([tubeOffset1,-w1/2-4,0]) cube( [tubeOffset2-tubeOffset1,w1,h1]);
                }
            union()
                {
                if ( dx<=0.0 )
                {
                    translate([tubeOffset1,0,-1]) cylinder( d = dBar1, h = o[0].z+h1/2+2 );
                    translate([tubeOffset2,0,-1]) cylinder( d = dBar2, h = o[0].z+h1/2+2 );
                    }
                }
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
module fuseCoverHookKnop2( a=10, ha=0.3 )
{
    difference(){
        hull(){
            translate([-a,0,ha])cylinder(d=1,h=5);
            translate([0,0, 0])cylinder(d=8,h=8.3);
            translate([+a,0,ha])cylinder(d=1,h=5);
            }
        *translate([0,0,-1])cylinder(d=2.5,h=10);
        translate([0,0,2])
			ScrewAndHexNut( m=2,dist=5 ); 
    }
}

module fuseCoverHookBase2( a=10, ha=0.3 )
{
    difference(){
		translate([0,0, 0])cylinder(d=12,h=4);
		translate([0,0,4.5])
			ScrewAndHexNut( m=2,dist=5 ); 
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

module fuseCoverMount_1()
{
    difference(){
        cube( [10,7,20], center=false );
        cube([5,3.5,20], center=false);
        
    }
}

module fuseCoverFront(d=0.1)
{
    coverSkin = 1.5;
    hx1 = 296-4;
    hy1 = 37;
    hx2 = 172.5;
    hy2 = 52.5;

    Slice(){
        innerSkin(){
            fuseSolid( r=+d );
            union(){
                fuseSolid( r=-coverSkin-d );
                translate([ hx1, hy1, 0])
                    rotate([90,0,-12])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                translate([hx2, hy2, 0])
                    rotate([90,180,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                }
            }
        //fuseCoverMask(x=120, y=63-3-d, r=fuseWidth+20, h=100, type=3);
        //fuseCoverMask(x=120, y=63-3-d-16+fuseY0, r=fuseWidth-4, h=100, type=3);
        //fuseCoverMask(x=80, y=63-3-d-20+fuseY0, r=fuseWidth-4, h=100+110, type=3);
        fuseCoverMask(x=120, y=63-3-d-20+fuseY0, r=fuseWidth-4, h=80, type=3);
        fusePoly();

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
                translate([ hx1, hy1, 0])
                    rotate([90,0,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                translate([hx2, hy2, 0])
                    rotate([90,180,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                }
            }
        //fuseCoverMask(x=35, y=80-3-d, r=fuseWidth+40, h=80, type=3);
        //fuseCoverMask(x=35, y=80-3-d-17+fuseY0, r=fuseWidth-4, h=100, type=3);
        //fuseCoverMask(x=-43, y=60-3-d-20+fuseY0, r=fuseWidth-4, h=45, type=3);
        fuseCoverMask(x=35, y=60-3-d-20+fuseY0, r=fuseWidth-4, h=90, type=3);
        }
    *translate([hx1,hy1,0])
        rotate([90,0,0])
            fuseCoverHook();

    *translate([hx2,hy2,0])
        rotate([90,180,0])
            fuseCoverHook( true );
}

module fuseCoverBak(d=0.1)
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
                translate([ hx1, hy1, 0])
                    rotate([90,0,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                translate([hx2, hy2, 0])
                    rotate([90,180,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                }
            }
        //fuseCoverMask(x=35, y=80-3-d, r=fuseWidth+40, h=80, type=3);
        //fuseCoverMask(x=35, y=80-3-d-17+fuseY0, r=fuseWidth-4, h=100, type=3);
        fuseCoverMask(x=-43, y=60-3-d-20+fuseY0, r=fuseWidth-4, h=45, type=3);
        }
    *translate([hx1,hy1,0])
        rotate([90,0,0])
            fuseCoverHook();

    *translate([hx2,hy2,0])
        rotate([90,180,0])
            fuseCoverHook( true );
}

module fuseGps()
{
    translate([-160,13,0]) rotate([0,0,7]) cube( [26,8,26], center=true ); // BZ 251
    translate([-150,13,0]) rotate([0,0,7]) cube( [6,30,10], center=true );
}

module fuseElrs()
{
    translate([-100,13,35]) rotate([90,0,7]) cylinder(d=5,h=30,center=true );

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
    l = 220-d;
    Slice(){
        innerSkin(){
            fuseSolid( r=0 );
            fuseSolid( r=-0.5 );
            }
        translate([180,-15,0]) 
            rotate([90,0,0]) 
                hull(){
                    translate([-l/2,0,0]) cylinder(d=d-r,h=50);
                    translate([+l/2,0,0]) cylinder(d=d-r,h=50);
                    }
        }
}

module fuseSkid2( r=0 )
{
    // wechselbare Platte für den Boden... 25x5cm, 2 Layer?
    // Rand ???
    d = 40;
    l = 220-d;
    translate([180,-15,0]) 
        rotate([90,0,0]) 
            hull(){
                translate([-l/2,0,0]) cylinder(d=d-2*r,h=0.6);
                translate([+l/2,0,0]) cylinder(d=d-2*r,h=0.6);
                }
}

module fuseCamera()
{
    translate([fuseLength0-20,3+fuseY0,0])
        rotate([0,90,0])
            union(){
                cylinder(d=15, h=30);
                cube([21,21,15], center=true);
                }
}

module fusePoly()
{
    //translate([fuseLength0-3,0,0])
    translate([fuseLength0-2.5,fuseY0,-0.15]) 
        mirror([1,0,0])
        {
            //fusePolyLine( d=dPoly, off=[-2.7+fuseWidth/2,-4], size=fuseInnerSpant, p=pClarkFusePolyUp ); 
            //fusePolyLine( d=dPoly, off=[-2.5+fuseWidth/2,+5], size=fuseInnerSpant, p=pClarkFusePolyDown ); 
            fusePolyLine(  d=dPoly, off=[-2.7+fuseWidth/2,+2.7], size=fuseInnerSpant, p=pClarkY2 );
            fusePolyLine(  d=dPoly, off=[-2.5+fuseWidth/2,-2.5], size=fuseInnerSpant, p=pClarkY2 );

            //fusePolyLine( d=dPoly, off=[+2.7-fuseWidth/2,-4], size=fuseInnerSpant, p=pClarkFusePolyUp ); 
            //fusePolyLine( d=dPoly, off=[+2.5-fuseWidth/2,+5], size=fuseInnerSpant, p=pClarkFusePolyDown ); 
            fusePolyLine(  d=dPoly, off=[+2.7-fuseWidth/2,+2.7], size=fuseInnerSpant, p=pClarkY2 );
            fusePolyLine(  d=dPoly, off=[+2.5-fuseWidth/2,-2.5], size=fuseInnerSpant, p=pClarkY2 );
            
            //offsetPolyLine(  d=dPoly, size=605, off=0, p=pClarkY );
            //offsetPolyLine(  d=dPoly, size=605, off=-10, p=pClarkY );
            
            }
    fusePolyLineQ( d=dPoly, pt=pSD6060[iSD6060_Nose], off=[+2,+0.5] );
    fusePolyLineQ( d=dPoly, pt=ptQRuder, off=[+0,+0] );

}

module tubeFlansh( d=8, a=0, h=60, w=3, r=0 )
{
    offh = +(d+w)/2+1;
    translate([-420, tailz0, +zBoom])
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
            hull() // to sruder
                {
                translate([-2,offh,1]) rotate([-90,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                translate([-42,offh,1]) rotate([-90,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                }
            hull() // to hruder
                {
                translate([+5,-3,-1.5]) rotate([180,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                translate([-30,-3,-1.5]) rotate([180,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                }
            hull()
                {
                translate([-15,-5,-1.5]) rotate([180,0,0]) cylinder(d=20, h=2, center = false );
                translate([-50,-5,-1.5]) rotate([180,0,0]) cylinder(d=20, h=2, center = false );
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
        translate([-45,-2,-8]) cube([12,6,10], center=true ); // servo cable - bad

        }
}

module tubeFlansh2( d=8, a=0, h=60, w=3, r=0 )
{
    offh = +(d+w)/2+1;
    translate([-420, tailz0, +zBoom])
    translate([-20,0,0])
    difference(){
        union(){
            //hull()
                translate([0,-a,0]) rotate([0,-90,0]) cylinder(d=d+w, h=h, center = false );   
            hull() // to sruder
                {
                //translate([-2,offh,1]) rotate([-90,0,0]) cylinder(d1=d+r, d2=1+r, h=40, center = false );
                //translate([-42,offh,1]) rotate([-90,0,0]) cylinder(d1=d+r, d2=1+r, h=40, center = false );
                translate([-20,0+40,0]) cube([40+r,1,3+r],center=true);
                translate([-20,0,0]) cube([40+r,1,d+w-2+r],center=true);
                }
            hull()
                {
                translate([-10,-5,-1]) rotate([180,0,0]) cylinder(d=20, h=3, center = false );
                translate([-20,-5,-1]) rotate([180,0,0]) cylinder(d=20, h=3, center = false );
                }
            hull()
                {
                translate([-10,-5,+3]) rotate([180,0,0]) cylinder(d=20, h=3, center = false );
                translate([-20,-5,+3]) rotate([180,0,0]) cylinder(d=20, h=3, center = false );
                }
            }
            
        translate([-2*h,-a,0]) rotate([0,90,0]) cylinder(d=d+0.2, h=h*3, center = false );
        translate([8,-a,0]) rotate([0,90,0]) cylinder(d1=d+0.2,d2=d+1, h=12, center = false );
        
        translate([0-2*h,-a, 0] )
            rotate( [90+90,0,0] )
                cube([h*3,h*3,1], center = false );    // cut a 1mm gap
        translate([ -10, -8, -0.5] )                    
            ScrewAndHexNut( m=2,dist=5 );            
        }
}
