
function RuderGetSize( z, zStart, zStop, sStart, sStop ) = ( ( sStart + (sStop-sStart)/(zStop-zStart)*(z-zStart) ) );
function RuderGetHeight( z, zStart, zStop, sStart, sStop, hBase ) = ( RuderGetSize( z, zStart, zStop, sStart, sStop) * hBase );
function RuderGetPoint( z, zStart, zStop, sStart, sStop, ptBase ) = ( RuderGetSize( z, zStart, zStop, sStart, sStop) * ptBase );
function RuderGetXOffset( z, zStart, zStop, oStart, oStop ) = ( ( oStart + (oStop-oStart)/(zStop-zStart)*(z-zStart) ) );

function rpos2d(s = 1, ang = 30 ) =
  (
    let (y = 5 * cos(ang), x = 5 * sin(ang))
    s * union(
		[[0, 0], [x, y], [100, y], [100, -y], [x, -y]],
		circle(d=1)
    )
  );

function rneg2d(s = 1, ang = 30 ) =
  (
    let (y = 5 * cos(ang), x = 5 * sin(ang))
    s * difference(
		[[0, 0], [x, y], [10, y], [10, -y], [x, -y]],
		circle(d=1.03)
    )
  );

*stroke(rpos2d(), 0.2);
*mirror([1, 0, 0]) stroke(rneg2d(), 0.2);

// positive tube part, begins at p1 with h1 and ends at p2 with h2, the z gap is negative d.
module rpos(p1, h1, p2, h2, d=0.4, dir=false)
{
  skin(
    [
      move([p1.x, p1.y], dir ? xflip(rpos2d(h1)) : rpos2d(h1)),
      move([p2.x, p2.y], dir ? xflip(rpos2d(h2)) : rpos2d(h2)),
    ],
    z=[p1.z + d, p2.z - d],
    slices=0
  );
}

// negativ tube part, begins at p1 with h1 and ends at p2 with h2, the z gap is positive d.
module rneg(p1, h1, p2, h2, d=0.4, dir=false )
{
  skin(
    [
      move([p1.x, p1.y], dir ? xflip(rneg2d(h1)) : rneg2d(h1)),
      move([p2.x, p2.y], dir ? xflip(rneg2d(h2)) : rneg2d(h2)),
    ],
    z=[p1.z - d, p2.z + d],
    slices=0
  );
}

//ruder
module RuderCut(
	pts,	// points of the ruder begins with start and ends with stop 
	hgt,	// height of the ruder for each point
	dSpace=0.4,	// z gap
	positiv=true	// orientation at start
)
{
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

//wing
module RuderWingCut(
	pts,	// points of the ruder begins with start and ends with stop 
	hgt,	// height of the ruder for each point
	dSpace=0.4,	// z gap
	positiv=true	// orientation at start
)
{
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

	difference(){
		children();
		translate(pts[0]+[-300,-30,0]) cube([600,60,pts[len(pts)-1].z- pts[0].z], center=false); 
	}
}
