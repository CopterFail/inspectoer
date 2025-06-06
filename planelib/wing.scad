

module segment( size=[1,1], pos=[[0,0,0],[0,0,100]], r=0, p=pSD6060 )
{
    factor = ( size[1] ) / ( size[0] );
    height = ( pos[1].z - pos[0].z );
    sx = ( pos[1].x - pos[0].x ) / height;
    sy = ( pos[1].y - pos[0].y ) / height;
    
    m=[ [ 1, 0,  sx, 0],
        [ 0, 1,  sy, 0],
        [ 0, 0,  1,  0],
        [ 0, 0,  0,  1] ];
    
    translate(pos[0])
        multmatrix(m)
            linear_extrude( height=height, scale=factor, convexity=10 ) 
                spant2d( s=size[0], r=r, p=p );
				
	// is skin() from bosl2 an alternative?
}


module spant3d( d=0.3, offset=[0,0,0], size=100, r=0, p=pSD6060 )
{
    translate(offset) linear_extrude( d, convexity=10 ) spant2d(size,r,p);
}

module spant3dDiff( d=0.3, offset=[0,0,0], size=100, rot=[0,0,0], ra=0, ri=-2.5, p=pSD6060 )
{
    translate(offset) rotate(rot) translate([0,0,-d/2]) linear_extrude( height=d, convexity=10 )
    difference()
    {
        spant2d( s=size, r=ra, p=p );
        spant2d( s=size, r=ri, p=p );
    }
}

module spant2d(s=1, r=0, p=pSD6060 )
{
    offset(delta=r)
    //alternative: offset(r=r)
    scale(s)
    mirror([1,0])  // sollte das weg?
    polygon(p);
}
