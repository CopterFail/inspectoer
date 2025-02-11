

module outerSkin( d=1, h=0, center=true )
{
    hgt = (h<=0) ? h : 2*d;
    difference(){
        minkowski(){
            children();
            cylinder(r=d,h=hgt,center=center ); 
        }
        children();
    }
}

module outerSkin2( d=1, h=0, center=true )
{
    hgt = (h<=0) ? h : 2*d;
    difference(){
        minkowski(){
            children(0);
            cylinder(r=d,h=hgt,center=center ); 
        }
        children(1);
    }
}

module innerSkin( )
{
    difference(){
        children(0);
        children(1);    
        }
}

module skin2()
{
    difference()
    {
        minkowski()
        {
            children(0);
            children(1);    
        }
        children(0);
    }
}

module Slice( )
{
    intersection()
    {
        children(0);
        children(1);
    }
}

module gridSlice( dy=30, angy=30, grid=2, dim=1000 )
{
    Slice(){
        children();
        for(z=[-dim:dy:dim], angy=[-angy,+angy])  
            translate([0,0,z])  
                rotate([0,angy,0])
                    cube([dim,dim,grid], center=true );
    }

}

module linearSlice( sh=100, sx=100, org=[0,0,0], rot=[0,0,0], center=true )
{
    Slice()
    {
        children();
        translate( org + [0,0,+sh/2] )
            rotate( rot )
                cube( [4*sx,2*sx,sh], center=center );
    }
}

module radialSlice( sh=100, sx=100, org=[0,0,0], rot=[0,0,0], mode=0, center=true )
{
    Steps = 120;
    Slice()
    {
        children();
        translate( org + [0,0,0] )
            rotate( rot )
                #radialSliceHelper( d=2*sx, sh=sh, mode, center );
    }
}

module radialSliceHelper( d, sh, mode=0, center=true )
{
    gap = 0.5;
    
    if( mode==0 ){
        cylinder( d=d, h=sh, center=center );
        }
            
    if( mode==1 ){
        difference(){
            union(){
                cylinder( d=d, h=sh, center=center );
                for( r=[0:120:360] )
                    translate([0,0,0]) rotate([0,90,r]) cylinder( d=10, h=d, center=center );
                }
            union(){
                for( r=[0:120:360] )
                    translate([0,0,sh]) rotate([0,90,r]) cylinder( d=10+0.2, h=d, center=center );
                }
            }
        }
 //hier war der marker..       
    if( mode==2 ){
        cx=5;
        cy=d/10;
        difference(){
            union(){
                cylinder( d=d, h=sh, center=center );
                for( r=[0:90:360] )
                    translate([0,0,0]) rotate([0,90,r]) cube([cx,cy,d],center=false); // d is diameter, cx,cy is size
                }
            union(){
                for( r=[0:90:360] )
                    translate([0,0,sh]) 
                        rotate([0,90,r]) 
                            translate([-gap,-gap/2,0])
                                cube([cx+gap*2,cy+gap,d],center=false);
                }
            }
        }
}

module show( d = [10,10,10] )
{
    for( i=[0:$children-1] )
    {
    translate( i * d )
        children(i);
    }
}
