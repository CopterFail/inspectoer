// screw and nut helper


//ScrewAndHexNut( m=2, $fn=50 );

module ScrewAndHexNut( m=2, dist=10 )
{
    
    dscrew  = (m==2) ? 2.3 : ((m==3) ? 3.2 : 4.1 );   // screw, loose
    dnut    = (m==2) ? 4.6 : ((m==3) ? 6.2 : 8.0 );   // hex nut, measured
    dhead   = (m==2) ? 4.2 : ((m==3) ? 5.8 : 7.0 );   //hex head
    
    translate( [ 0, 0, -dist/2-10/2 ] ) 
        cylinder(d=4.6, h=10, center=true, $fn=6 ); //m2 nut, 6 edge hole
    translate( [ 0, 0, 0 ] ) 
        cylinder(d=2.3, h=dist+20, center=true ); //m2 screw
    translate( [ 0, 0, +dist/2+10/2 ] ) 
        cylinder(d=4.2, h=10, center=true ); //m2 head
}

module ScrewServo( dist=10 )
{
    cylinder(d=1.5, h=dist ); // servo screw, does not realy fit
}

module ScrewMotorPlate( dscrew=3.5, distmin=15.5, distmax=19.5, dcenter=8, rotoffset=0, screwlen=6, plate=6 )
{
    for( a=[45:90:360]) 
        rotate([0,0,a+rotoffset]) 
            hull(){
                translate( [0, distmax/2, -plate-0.1] ) // max plate is fixed 6
                    cylinder( d=dscrew, h=screwlen, center=false ); // motor screws
                translate( [0, distmin/2, -plate-0.1] ) 
                    cylinder( d=dscrew, h=screwlen, center=false ); // motor screws
                }
    translate( [0, 0, -plate-0.1] ) 
        cylinder( d=dcenter, h=plate+1, center=false ); // motor center

}