
//function RuderGetSize( z, zStart, zStop, sStart, sStop ) = ( ( sStart + (sStop-sStart)/(zStop-zStart)*(z-zStart) ) ); // calculate size factor at position z
//function RuderGetHeight( z, zStart, zStop, sStart, sStop, hBase ) = ( RuderGetSize( z, zStart, zStop, sStart, sStop) * hBase ); // calculate height at position z
//function RuderGetPoint( z, zStart, zStop, sStart, sStop, ptBase ) = ( RuderGetSize( z, zStart, zStop, sStart, sStop) * ptBase ); // calculate ruder axis point at position z
//function RuderGetXOffset( z, zStart, zStop, oStart, oStop ) = ( ( oStart + (oStop-oStart)/(zStop-zStart)*(z-zStart) ) ); // claculate x offset at position z

// create a 2D mask for positive ruder part
function rpos2d(s = 1, ang = 30 ) =
  (
    let (y = 5 * cos(ang), x = 5 * sin(ang))
    s * union(
			[[0, 0], [x, y], [100, y], [100, -y], [x, -y]],
			circle(d=1)
		)
  );

// create a 2D mask for negative ruder part
function rneg2d(s = 1, ang = 30 ) =
  (
    let (y = 5 * cos(ang), x = 5 * sin(ang))
    s * difference(
			[[0, 0], [x, y], [10, y], [10, -y], [x, -y]],
			circle(d=1.03)
		)
  );

module cylinder_between(p1=[0,0,0], p2=[0,0,10], d1=1, d2=1, hdiff=0.8, center=false ) {
    v = (p2 - p1);
    h = norm(v);
	g = v/norm(v)*hdiff/2; // g is a vector in axis direction with length hdiff/2 to fix the stating point.
    move(p1+g)
        rot(from=UP, to=v)
            cyl(h=h-hdiff, d1=d1, d2=d2, center=center, anchor=BOTTOM );
}



// ================= Example usages =================
// simple: from origin to [30,15,10], radius 1.5
//cylinder_between([0,0,0], [30,15,10], 1.5);

// centered cylinder between points
//cylinder_between([0,0,0], [30,15,10], 1.5, anchor="center");

// top-anchored: so p2 is the top of cylinder
//cylinder_between([0,0,0], [0,0,10], 1.5, anchor="top");

*stroke(rpos2d(), 0.2); // draw the masks for debugging
*mirror([1, 0, 0]) stroke(rneg2d(), 0.2);

//Bug: the axis needs to be cut 90 degree to the axis, to avoid stucking parts
function RuderAngle(x,z) = atan2( x, z );

// create the positive 3D ruder mask  part from the 2D masks above, begins at p1 with h1 and ends at p2 with h2, the z gap is negative d.
module rpos(p1, h1, p2, h2, d=0.4, dir=false)
{
	a = RuderAngle((p2-p1).x, (p2-p1).z );
	p2_help = yrot(a = -a, p = p2-p1);

	poly1_2d = dir ? xflip(rpos2d(h1)) : rpos2d(h1);
	poly2_2d = dir ? xflip(rpos2d(h2)) : rpos2d(h2);

	// here is the problem: poly1_2d and poly2_2d are arrays with one element, need to extract that element
	// why has this happened? was working before...
	//echo(poly1_2d);
	//echo(poly2_2d);

	move(p1)	// move the origin to p1
	yrot(a = a)
  	skin(
    	[
      	move([0,0], poly1_2d[0]),
      	move([p2_help.x, p2_help.y], poly2_2d[0] ),
    	],
    	z=[0 + d, p2_help.z - d],
    	slices=0
  		);

  	//echo( "rpos",p1,p2,p2_help,a );
}

// // create the negative 3D ruder mask  part from the 2D masks above, begins at p1 with h1 and ends at p2 with h2, the z gap is positive d.
module rneg(p1, h1, p2, h2, d=0.4, dir=false )
{
	a = RuderAngle((p2-p1).x, (p2-p1).z );
	p2_help = yrot(a = -a, p = p2-p1);

	poly1_2d = dir ? xflip(rneg2d(h1)) : rneg2d(h1);
	poly2_2d = dir ? xflip(rneg2d(h2)) : rneg2d(h2);

	//echo(poly1_2d);
	//echo(poly2_2d);

	move(p1)	// move the origin to p1
	yrot(a = a)
	skin(
		[
		move([0,0], poly1_2d[0]),
		move([p2_help.x, p2_help.y], poly1_2d[0]),
		],
	z=[0 - d, p2_help.z + d],
	slices=0
	);

  	//echo( "rneg",p1,p2,p2_help,a );
}

// calculate ruder points and heights along z axis. this is done by separate functions for HR and QR
function QRPoints( zs, ptRuder ) = [
    for(z=zs)[ -ptRuder.x * s(z) + o(z).x, +ptRuder.y * s(z) , z],
    ];
    
function QRHeights( zs, hRuder ) = [
    for(z=zs) (hRuder * s(z)),
    ];
    
function HRPoints( zs, ptRuder ) = [
    for(z=zs)[ -ptRuder.x * hs(z) + ho(z).x, +ptRuder.y * hs(z) , z],
    ];
    
function HRHeights( zs, hRuder ) = [
    for(z=zs) (hRuder * hs(z)),
    ];
    
// cut the ruder - part from the children object. 
module RuderCut(
    zList=[],
    ptRuder=ptQRuder,
    hRuder=hQRuder,
    RuderIsH=false,
	dSpace=0.4,	// z gap
	positiv=true	// orientation at start
)
{
  pts = RuderIsH ? HRPoints( zList, ptRuder ) : QRPoints( zList, ptRuder );
  hgt = RuderIsH ? HRHeights( zList, hRuder ) : QRHeights( zList, hRuder );
	intersection() {
		children();
		union() {
			for( idx= [0:1:len(pts)-2]) {
				pos = (idx % 2 == 0) ? positiv : !positiv;
				if (pos) {
					rpos(pts[idx], hgt[idx], pts[idx+1], hgt[idx+1], dSpace, dir=true);
				} else {
					rneg(pts[idx], hgt[idx], pts[idx+1], hgt[idx+1], dSpace, dir=true);
				}
			}
		}
	}
}

// cut the wing - part from the children object
module RuderWingCut(
    zList=[],
    ptRuder=ptQRuder,
    hRuder=hQRuder,
    RuderIsH=false,
	  dSpace=0.4,	// z gap
	  positiv=true	// orientation at start
)
{
  pts = RuderIsH ? HRPoints( zList, ptRuder ) : QRPoints( zList, ptRuder );
  hgt = RuderIsH ? HRHeights( zList, hRuder ) : QRHeights( zList, hRuder );
	intersection() {
		children();
		union() {
			for( idx= [0:1:len(pts)-2]) {
				pos = (idx % 2 == 0) ? !positiv : positiv;
				if (pos) {
					rpos(pts[idx], hgt[idx], pts[idx+1], hgt[idx+1], dSpace, dir=false);
				} else {
					rneg(pts[idx], hgt[idx], pts[idx+1], hgt[idx+1], dSpace, dir=false);
				}
			}
		}
	}

	difference(){	// add the "non ruder" part (to check)
		children();
		RuderCutBox( p1 = pts[0], p2 = pts[len(pts)-1] );
		}
}

module RuderCutBox( p1, p2 )
{
	echo(p1,p2);
	a = RuderAngle((p2-p1).x, (p2-p1).z );
	translate(p1) 
	yrot(a = a)
	translate([-300,-30,0]) 
	cube([600,60,(p2-p1).z]/cos(a), center=false); 
	//cube(1); // to avoid empty module error

}

// draw the ruder horn at position pos with base diameter dbase, axis diameter daxsis, wire diameter dwire, height h, arm a and distance dSpace from the ruder surface
module RuderHorn( dbase, daxsis=2.2, dwire=2, pos=[0,0,0], rot=[0,0,0], h=2, a=18, dSpace=0.4 )
{
    b=a;
    translate( pos+[0,0,dSpace] ) 
	rotate(a = rot) 
        difference(){
            union(){
                hull(){
                    translate([0,0,0])  cylinder( d=dbase-2, h=h, center=false );
                    translate([-a,0,0]) cylinder( d=2, h=h, center=false );
                    }
                hull(){
                    translate([-a,0,0]) cube( [10,1,h], center=false );
                    translate([0,b,0])  cylinder( d=6, h=h, center=false );
                    }
                }
            union(){
                translate([0,0,0])  cylinder( d=daxsis, h=h, center=false );
                translate([0,b,0])  cylinder( d=dwire, h=h, center=false ); 
            }
    }
}

module RuderRepair(da=14, di=dPoly,h=0.6 )
{
	difference() {
		zcyl(d=da,h=h);
		zcyl(d=di,h=h+0.5);
	}
}