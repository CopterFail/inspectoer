

module segment( i=0, r=0, p=pSD6060 )
{
    factor = ( s[i+1] ) / ( s[i] );
    height = ( o[i+1].z - o[i].z );
    sx = ( o[i+1].x - o[i].x ) / height;
    sy = ( o[i+1].y - o[i].y ) / height;
    
    m=[ [ 1, 0,  sx, 0],
        [ 0, 1,  sy, 0],
        [ 0, 0,  1,  0],
        [ 0, 0,  0,  1] ];
    
    translate(o[i])
        multmatrix(m)
            linear_extrude( height=height, scale=factor, convexity=10 ) 
                spant2d( s=s[i], r=r, p=p );
}

module lastsegment( r=0, h=10, ds=50, p=pSD6060 )
{
    i = len(o) - 1;
    dx = s[i]*(100-ds)/100/2;
    hull()
        {
        spant3d( d=0.3, offset=o[i], s[i], r=r, p=p );  
        spant3d( d=0.3, offset=o[i]+[-dx,0,h], s[i]*ds/100, r=r, p=p );
        }
}

module wingConnect( d=4, r=-0.5, width=1, offset=[0,0,0], size=100 )
{
    spant3dDiff( d=d, offset=offset, size, ra=r, ri=r-width, p=pSD6060 );  
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
