






yoff=10+2;
xoff=5;//10+17;
xlen=200;

module wingBoom( bd=8, diff=0.1, len=500 )
{
    translate([xoff,yoff,zBoom])
    translate([ -200,0,0]) rotate([0,90,0])cylinder(d=bd+diff,h=len,center=true);  //8mm version

}



module wingMotorPlate( diff=0, holes=true )
{
    h0=12;
    module mcylinder( diff=0 )
    {
        rotate([0,-90,0]) 
            translate([ 0,0,-3-diff ]) 
                cylinder(d=33+diff, h=55+diff,center=false);   // body cylinder
    }
    
    module mholes()
    {
        rotate([0,-90,0]) 
            ScrewMotorPlate(screwlen=60);
    }
    
    module cable_hole()
    {
        translate( [ -3, 15, 0 ] )
        rotate([90,0,0])
        hull(){
            translate([-10,0,0]) cylinder(d=5,h=10,center=true );
            translate([0,-2,0]) cylinder(d=4,h=10,center=true );
            translate([0,+2,0]) cylinder(d=4,h=10,center=true );
        }
    }

    difference(){
        union()
        {
            translate([xoff,yoff,zBoom])
                difference(){
                    mcylinder(0+2*diff);
                    if( holes==true ){
                        mcylinder(-4-2*diff);
                        mholes();
                        cable_hole();
                    }
                }
            translate([xoff,yoff,zBoom])
                intersection(){
                    mcylinder(0);
                    translate([-tubeOffset1-xoff ,tubeOffsety-yoff, 0]) 
                        cylinder(d=dBar1+8, h=33,center=true ); // bar mount
                    }
        }
        union()
        {
            if( holes==true ){
                translate([-tubeOffset1 ,tubeOffsety, zBoom]) 
                            cube([dBar1+10,dBar1+10,12+0.2], center=true );
                translate([ xoff-120/2-tubeOffset1, yoff, zBoom]) 
                    rotate([0,90,0])
                        cylinder(d=8+0.3+4+0.5,h=140,center=true);  // mount for boom 8mm version
                            
                wingPolyLine( d=dPoly, pt=ptWingNose, off=[+2,+0.5] );
                wingElectric();
                xTube( diameter=8+0.1, length=1000, tubeoffset=tubeOffset1 );
                translate( [-xoff+0, yoff-11.2, zBoom ] ) 
                    rotate([90,0,0])
                        ScrewAndHexNut( m=2,dist=10 );
                }
            
        }
    }


}

module wingMotor(diff=0, holes=true) //use diff!!!!!
{
    h0=12; //10;    
    {
        difference(){
            union(){
                Slice(){
                    wingSolid(r=-1/*diff*/);
                    translate([ xoff-130/2-3-10, yoff-15+1, zBoom]) cube([150,25+2,h0], center=true );
                    }
                
                translate([-tubeOffset1 ,tubeOffsety, zBoom]) cylinder(d=dBar1+10, h=h0,center=true );
                translate([-tubeOffset2 ,tubeOffsety, zBoom]) cylinder(d=dBar2+10, h=h0,center=true );
                
                translate([ xoff-120/2-tubeOffset1, yoff, zBoom]) rotate([0,90,0])cylinder(d=8+4,h=120,center=true);  //8mm version
                
                }
            union(){
                translate([xoff-153,yoff-21,zBoom])
                    rotate([0,0,-45])
                        cube([20,20,20], center=true );

                if( holes==true ){
                    color("Black") wingBoom();
                    color("Black") xTube( diameter=8+0.2, length=1000, tubeoffset=tubeOffset1 );
                    color("Black") xTube( diameter=6+0.2, length=400, tubeoffset=tubeOffset2 );   
                    wingMotorPlate(diff=0.1); 
                    wingPolyLine( d=dPoly, pt=ptWingNose, off=[+2,+0.5] );
                    *wingPolyLine( d=dPoly, pt=ptQRuder, off=[+0,+0] );
                    wingElectric();
                    translate( [-xoff+0, yoff-11.2, zBoom ] ) 
                        rotate([90,0,0])
                            ScrewAndHexNut( m=2,dist=10 );
                    translate([xoff,yoff,zBoom])
                        translate([-83,-8,0]) rcube([54,4,20], round=3);
                    translate([xoff-35,yoff-15,zBoom]){
                        translate([-113,2,0]) cube([30,20,1.2], center=true );
                        translate([-113,8,0]) ScrewAndHexNut( m=2,dist=8 );
                        }
                        
                    }
                }
        }
       
    }
    
    *translate([xoff,yoff,zBoom]){
        color("Red") translate([15+12,0,0]) rotate([0,90,0]) cylinder(d=7*25.4,h=8,center=true);   // propeller     
        color("Red") translate([12,0,0]) rotate([0,90,0]) cylinder(d=33,h=17,center=true);   // motor
        *%translate([0,-60,0]) cube( [300,1,500], center=true );
        }
    *color("Black") xTube( diameter=8, length=1000, tubeoffset=tubeOffset1 );
    *color("Black") xTube( diameter=6, length=400, tubeoffset=tubeOffset2 );    
    *wingMotorPlate(diff=0);

}

module wingMotorCoverSolid()
{
    diff=0;
    hull(){
        translate([xoff-55,yoff,zBoom]) // body cylinder taken from wingMotorPlate()
            rotate([0,-90,0]) 
                translate([ 0,0,-3-diff ]) 
                    cylinder(d=33+diff, h=1,center=false);   
        translate([ xoff-120+0.5-tubeOffset1, yoff, zBoom]) rotate([0,90,0])cylinder(d=8+4+2,h=1,center=true);  // taken from wingMotor
        }
}

module fuseMotor(d=0.5, holes=true) // not needed with two motors at the wings
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
