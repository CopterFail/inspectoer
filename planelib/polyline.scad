


module wingPolyLine( d=3, pt=[0,0], off=[0,0]  )
{
    *echo(pt);
    l = len(s)-1; 
    poly = [         [o[0].x - s[0]*pt.x - off.x , o[0].y + s[0]*pt.y + off.y,  o[0].z - 20 ],
        for(i=[0:l]) [o[i].x - s[i]*pt.x - off.x , o[i].y + s[i]*pt.y + off.y,  o[i].z ],
                     [o[l].x - s[l]*pt.x - off.x , o[l].y + s[l]*pt.y + off.y,  o[l].z + 20 ] ];
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

module fusePolyLine( d=3, size=605, off=[0,0], p=pClarkFusePolyUp )
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

module fusePolyLineQ( d=3, size=605, pt=[0,0], off=[0,0] )
{
    poly = [        
                    [o[1].x - s[1]*pt.x - off.x , o[1].y + s[1]*pt.y + off.y,  +o[1].z ],
                    [o[0].x - s[0]*pt.x - off.x , o[0].y + s[0]*pt.y + off.y,  +o[0].z ],
                    [o[0].x - s[0]*pt.x - off.x , o[0].y + s[0]*pt.y + off.y,  -o[0].z ], 
                    [o[1].x - s[1]*pt.x - off.x , o[1].y + s[1]*pt.y + off.y,  -o[1].z ]
                    ];
                    
        for( i=[0:(len(poly)-2)] ){
                hull(){
                    translate(poly[i]) 
                        sphere( d=d );
                    translate(poly[i+1]) 
                        sphere( d=d );
                    }
        }
}

module offsetPolyLine(  d=3, size=605, off=10, p=pClarkY )  // this does not yet work, just a test.
{
    for( i=[0:(len(p)-1)] ){
        po = size * p[i];
        pv = size * ((i>0) ? p[i-1] : p[len(p)-1]);
        pn = size * ((i>(len(p)-2)) ? p[0] : p[i+1]);

        pop = (pv + pn)/2 + po;
        p02 = pn - po;
        z = p02.x * pop.y + p02.y * pop.x;
        
        pt = sign( z ) * pop * (off/norm(pop));
       

        
        hull(){
            translate([po.x+pt.x, po.y+pt.y, 0]) 
                sphere( d=d );
            translate([pn.x+pt.x, pn.y+pt.y, 0]) 
                sphere( d=d );
            }
        echo( po, pop, z );
    }
}