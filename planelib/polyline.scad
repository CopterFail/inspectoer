


module wingPolyLine( d=3, pt=[0,0], off=[0,0]  )
{
    *echo(pt);
    l = len(s)-1; 
    poly = [         [o[0].x - s[0]*pt.x - off.x , o[0].y + s[0]*pt.y + off.y,  o[0].z - 20 ],
        for(i=[0:l]) [o[i].x - s[i]*pt.x - off.x , o[i].y + s[i]*pt.y + off.y,  o[i].z ],
                     [o[l].x - s[l]*pt.x - off.x , o[l].y + s[l]*pt.y + off.y,  o[l].z + 20 ] ];
    echo( poly);
    for( i=[0:(len(poly)-2)] ){
        hull(){
            translate(poly[i]) 
                sphere( d=d );
            translate(poly[i+1]) 
                sphere( d=d );
            }
        }
}

module fusePolyline( d=3, size=605, off=[0,0], p=pClarkFusePolyUp )
{
    for( i=[0:(len(p)-2)] ){
        hull(){
            translate([p[i].x*size, p[i].y*size+off.y, +off.x]) 
                sphere( d=d );
            translate([p[i+1].x*size, p[i+1].y*size+off.y, +off.x]) 
                sphere( d=d );
            }
        *echo( p[i] );
        }
}
