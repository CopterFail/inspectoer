
// the following shold be also the base for a complete wing solid, in combination with the algorithm for free 2D polynom placement in 3D
module wingBowDraw( vbase = [2 * sf, 0, 0], p=pSD6060, baseSize=s(zBow), z0=25, res=30, offset=[55,0,0], pos=o(zBow)) 
{
	N=len(p)+1; // one additional point will be appended
	steps = (res == 0) ? floor(z0/2) : res;
	//echo( N, steps, N * steps);

	function xysize(cnt) = baseSize * sqrt(1-cnt/steps);
	function zsize(cnt) = z0 * sqrt(cnt/steps);
	function xoff(cnt) = (-offset[0]+vbase[0])/baseSize;;
	function yoff(cnt) = 0;

	// fails if p is not closed, so append the first point.
	p2 = [for(n=[0:len(p)-1]) p[n], p[0]];

	points=[ for(cnt=[0:steps]) for(n=p2)  [( n.x + xoff(cnt)) * xysize(cnt) , (n.y + yoff(cnt)) * xysize(cnt), zsize(cnt)], [0,0,z0] ];
	faces=[
		//[for(n=[N-1:-1:0]) n],	// bottom, CCW
		[for(n=[0:1:N-1]) n],	// bottom, CW
		//[for(n=[0:1:N-1]) n+N*(steps-1)],  // top, CW, flat area
		//for(n=[0:N-2]) [n+N*(steps-1), (n+1)+N*(steps-1), N*steps], // top, CCW, not longer flat, use triangles to the single top point
		for(n=[0:N-2]) [n+N*(steps-1), N*steps, (n+1)+N*(steps-1)], // top, CW, not longer flat, use triangles to the single top point
		//for(cnt=[0:steps-2]) for(n=[0:N-2]) [n+cnt*N, (n+1)+cnt*N, (n+1)+(cnt+1)*N, n+(cnt+1)*N], // side, CCW 
		for(cnt=[0:steps-2]) for(n=[0:N-2]) [n+cnt*N, n+(cnt+1)*N, (n+1)+(cnt+1)*N, (n+1)+cnt*N], // side, CW 
	];

	translate(v = -offset + pos ) 
	mirror([1,0,0])
	polyhedron( points, faces, convexity=5 );
}
 
module wingBow( draw = true )
{
    difference(){
		wingBowDraw();
		wingPolyLine( d=dPoly, pt=ptWingNose, off=[+2,+0.5] );
        wingPolyLine( d=dPoly, pt=ptQRuder, off=[+0,+0] );
        }
}


/* the next ideas to implement are:

// test for ploy3D
off = [-0.4,0];
sc = 10;
pos = [[0,0,10],[0,0,20],[0,10,30],[0,40,40], [0,50,35], [0,60,20], [0,50,15]];

// polyin is a 2D polygon, p1 and p2 are the start and end points of the line, s is the scale factor
function Poly3( polyin, p1=[0,0,0], p2=[0,0,1], s=1 ) =
    let( n = (p1-p2) / norm(p1-p2) )
    let( bf1 = cross( n, [1,0,0] ) )    // bf1 and bf2 are the new base vectors of the object in 3D, any vector not parallel to n, this will influence the rotation
    let( bf2 = cross( n, bf1 ) )
    s * [for (p=polyin) (p.x+off.x)*bf1 + (p.y+off.y)*bf2 ];


for(i=[0:len(pos)-2])
{
    hull(){
        translate(pos[i]) sphere(0.2);
        translate(pos[i+1]) sphere(0.2);
        }
    translate(pos[i])
        hull()
        for (p= Poly3(polyin=pSD6060, p1=pos[i], p2=pos[i+1], s=sc ))
            translate(p)
                cube(0.1, center=true);
}

more: move the polygons along a bezier curve
*/