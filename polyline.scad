


module wingPolyLine( d=3, pt=[0,0], off=[0,0]  )
{
    *echo(pt);
    poly = [ for(i=[0:len(o)-1]) [o[i].x - s[i]*pt.x - off.x , o[i].y + s[i]*pt.y + off.y,  o[i].z ] ];
    *echo( poly);
    for( i=[0:(len(poly)-2)] ){
        
        hull(){
            translate(poly[i]) 
                sphere( d=d );
            translate(poly[i+1]) 
                sphere( d=d );
            }
        }
}

module fusePolyline( d=3, size=605, p=pClarkFuse )
{
    for( i=[0:(len(p)-2)] ){
        hull(){
            translate([p[i].x*size, p[i].y*size,0]) 
                sphere( d=d );
            translate([p[i+1].x*size, p[i+1].y*size,0]) 
                sphere( d=d );
            }
        *echo( p[i] );
        }
}
