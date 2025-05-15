
// Angle at the lower back side needs some improvement
module wingBowDraw_old_version( vbase = [2 * sf, 0, 0], p=pSD6060, baseSize=170, z0=25, offset=[55,0,0], pos=o[3]) 
{
    steps =z0/0.2;
    for (cnt=[0:steps]){
        zsize = sqrt(1-cnt/steps);
        z = z0 * sqrt(cnt/steps);
        zstep = z0 * sqrt((cnt+1)/steps) - z;
		translate(v = vbase * z ) 
        translate(v = [0,0,z]+pos-offset)
            scale( [zsize,zsize,1] ) 
                spant3d( d=zstep, offset=offset, size=baseSize, r=0, p=p ); //check hull()
                }
                
}

module wingBowDraw( vbase = [2 * sf, 0, 0], p=pSD6060, baseSize=170, z0=25, offset=[55,0,0], pos=o[3]) 
{
	N=len(p)+1; // one additional point will be appended
	steps = z0/0.5;
	echo( N, steps, N * steps);

	function xysize(cnt) = baseSize * sqrt(1-cnt/steps);
	function zsize(cnt) = z0 * sqrt(cnt/steps);
	function xoff(cnt) = (-offset[0]+vbase[0])/baseSize;;
	function yoff(cnt) = 0;

	// fails if p is not closed, so append the first point.
	p2 = [for(n=[0:len(p)-1]) p[n], p[0]];

	points=[ for(cnt=[0:steps]) for(n=p2)  [( n.x + xoff(cnt)) * xysize(cnt) , (n.y + yoff(cnt)) * xysize(cnt), zsize(cnt)] ];
	faces=[
		[for(n=[N-1:-1:0]) n],	// bottom, CCW
		[for(n=[0:1:N-1]) n+N*(steps-1)],  // top, CW
		for(cnt=[0:steps-2]) for(n=[0:N-2]) [n+cnt*N, (n+1)+cnt*N, (n+1)+(cnt+1)*N, n+(cnt+1)*N], // side, CCW 
	];

	translate(v = -offset + pos ) 
	mirror([1,0,0])
	polyhedron( points, faces, convexity=5 );
}
 
module wingBowImport()
{
	translate( [ 0.4, 0, -0.6 ] )
		rotate([0,-90,0])
			mirror([1,0,0])
				scale( 110/133 + 0.02 )
					import("Randbogen.stl");
}

module wingBow( draw = true )
{
    difference(){
		if( draw ){
			wingBowDraw(/*p=pSimpl*/);
		}else{ 
			wingBowImport();
		}

		wingPolyLine( d=dPoly, pt=ptWingNose, off=[+2,+0.5] );
        wingPolyLine( d=dPoly, pt=ptQRuder, off=[+0,+0] );
        }
}

