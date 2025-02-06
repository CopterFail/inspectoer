

module segment( s, o, r=0, p=pSD6060, begin=0, end=1 )
{
    factor = ( s[1] ) / ( s[0] );
    height = ( o[1].z - o[0].z );
    sx = ( o[1].x - o[0].x ) / height;
    sy = ( o[1].y - o[0].y ) / height;
    
    m=[ [ 1, 0,  sx, 0],
        [ 0, 1,  sy, 0],
        [ 0, 0,  1,  0],
        [ 0, 0,  0,  1] ];
    
    translate(o[0])
        multmatrix(m)
            linear_extrude( height=height, scale=factor, convexity=10 ) 
                intersection()
                {
                    spant2d( s=s[0], r=r, p=p );
                    scale(s) 
                        mirror([1,0]) // vgl spant2d()
                            translate( [begin,-0.5] ) 
                                square( [(end-begin), 1] );
                }
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
