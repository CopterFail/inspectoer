
include <BOSL2/std.scad>;

///////////////////////////////////////////////////////////////////////////////////////////////
// main
///////////////////////////////////////////////////////////////////////////////////////////////

//fuse();
//innerfuse();
//fuse2Segment( [0,1,3,4] );
//ymove(100/2) partition(size=[500,200,200],spread=100, cutpath="flat",cutpath_centered=false) fuse();
//slide_cut();
//ymove(30) xmove(30) slide_cut2();
boom();
*boomSolid( seg=2, r=0 );
//zflip() boom();
//color( "Green") stroke( width=0.1, slide_path(e=0) );
//color( "Blue") stroke( width=0.1, slide_path(e=+0.2) );
//color( "Red") stroke( width=0.1, slide_path(e=-0.2) );

function slide_path( a=60, d=5, e=0 ) = (
    let ( y = 5 , x = 5 )
    union(
			//[[0, 0], [x, y], [100, y], [100, -y], [x, -y]],
			move( [0, 1.5*d], rect( [a+2*d-2*e, d-2*e], rounding=d/5, $fn=25 ) ),
            move( [0, d-e/2], rect( [a-2*e, 2*d-e] ) ),
		)
);



//tubes(height=boom_height, width=boom_width, offset=boom_offset,path=boom_path);

///////////////////////////////////////////////////////////////////////////////////////////////
// data
///////////////////////////////////////////////////////////////////////////////////////////////
fl=470;
steps=20;

// define the fuse data
fuse_path = squircle(1,squareness=0.5,$fn=25);
fuse_height = bezier_join([   // segmente y(x) , hoehe
        mkbez( [0,1], [165,80], [0,27], [100,0]),   // point1 -> point2 with dir1 and dir2
        mkbez( [165,80], [fl-20,30], [100,0], [30,0]),
        mkbez( [fl-20,30], [fl,3], [20,0], [0,-20])],
        steps);
fuse_width = bezier_resample( 
        bezier_join([   // segmente z(x) , breite
            mkbez( [0,1], [140,110], [0,35], [100,0]),   // point1 -> point2 with dir1 and dir2
            mkbez( [140,110], [350,110], [35,0], [30,0]),    
            mkbez( [350,110], [fl-20,110], [35,0], [30,0]),    
            mkbez( [fl-20,110], [fl,3], [20,0], [0,-20])],
            steps),
        fuse_height);
fuse_offset = bezier_resample( 
        bezier_join([   // segmente o(x)
            mkbez( [0,3], [165,0], [30,0], [60,0]),    // point1 -> point2 with dir1 and dir2
            mkbez( [165,0], [400,0], [60,0], [60,0]),
            mkbez( [400,0], [600,0], [60,0], [135,0])],
            steps),
        fuse_height);

fvnf_0 = vnf_drop_unused_points(fuse_vnf( fuse_height, fuse_width, fuse_offset, wall=0, path=fuse_path ));

// define the boom data
bl=450;
bd1=40;
bd2=30;
bd3=20;
bh1=15;
//boom_path = squircle(1,squareness=0.5,$fn=25);
boom_path = ellipse(d=1,$fn=25);
boom_height = bezier_join( [   // segmente y(x) , hoehe
        mkbez( [0,bd1], [80,bd1+10], [10,10], [40,0]),   // point1 -> point2 with dir1 and dir2
        mkbez( [80,bd1+10], [250,bd2], [30,0], [30,0]),
        mkbez( [250,bd2], [bl-20,bd2], [100,0], [30,0]),
        mkbez( [bl-20,bd2], [bl,3], [20,0], [0,-20])],
        steps);
boom_width = bezier_resample(
        bezier_join([ 
            mkbez( [0,bd1], [120,bd1+30], [10,10], [40,0]),   // point1 -> point2 with dir1 and dir2
            mkbez( [120,bd1+30], [250,bd2], [30,0], [30,0]),
            mkbez( [250,bd2], [bl-20,bd3], [100,0], [30,0]),
            mkbez( [bl-20,bd3], [bl,3], [20,0], [0,-20])],
            steps),
        boom_height);
boom_offset = bezier_resample( 
        bezier_join([ 
            mkbez( [0,3], [220,3], [80,0], [60,0]), 
            mkbez( [220,3], [bl,bh1], [80,0], [60,0]) ], 
            steps), 
        boom_height);

bvnf_0 = vnf_drop_unused_points(fuse_vnf( boom_height, boom_width, boom_offset, wall=0, path=boom_path ));


///////////////////////////////////////////////////////////////////////////////////////////////
// functions
///////////////////////////////////////////////////////////////////////////////////////////////

// calculate a path for a tube in the fuse, w is the angle of the ellipse and d is the distance in the outer wall
function epath2(height,width,offset,w=0,d=3,start=1,end=1,path=ellipse(d=1)) = 
    let( pt = polygon_line_intersection(path,[[0,0],[cos(w),sin(w)]]) )
    [
    if(start > 1) // add an additional start point, depending on the start value
        [ 
            width[0].x - width[start].x, 
            //0 + offset[0].y, 
            //0 
            (height[start].y - d) * pt[0][0].x + offset[start].y, 
            (width[start].y - d) * pt[0][0].y 
        ], 
    for( i=[start:1:end]) 
        [
            height[i].x, 
            (height[i].y - d) * pt[0][0].x + offset[i].y, 
            (width[i].y - d) * pt[0][0].y
        ], 
    if(end < (len( width )-1) ) // add an additional end point, depending on the end value
        [ 
            width[len( width )-1].x + (width[len( width )-1].x - (width[end].x)), 
            (height[end].y - d) * pt[0][0].x + offset[end].y, 
            (width[end].y - d) * pt[0][0].y 
        ], 
    ];
    
// polygon_line_intersection( scale( [z[i].y+wall,y[i].y+wall], p=path ), [sin(w),cos(w)] ) see also seg_vnf() below.

// draw 3 tube with fix 2mm under the skin    
module tubes(height=fuse_height, width=fuse_width, offset=fuse_offset, angs=[90,5,-90], start=0, path=ellipse(d=1)){
    end = len( height ) - 1;
    d = 3.5;
    color("Blue") 
    for(w=angs)
        stroke( width=2, epath2( height, width, offset, w=w, d, start, end, path ) );
}

// create a bosl2 bezier with 2 point and 2 direction vectors from 4 points
function mkbez(a=[0,0],b=[10,10],da=[1,0],db=[0,1]) = [ a, a+da, b-db, b];  

// join a set of bosl2 beziers, to a single set of 2d points using bezier_curve for each bezier
function bezier_join(bezs,steps=10) = ( [ for( i=bezs ) for( p=bezier_curve(i, splinesteps=steps)) p,] );

// use a union x vector, resample
function bezier_resample( org, ref ) = ([ for( x=ref ) [x.x,lookup( x.x, org )],]);

// creates a solid vnf based on elipses r(x)=height(x),width(x) and height offset(x)
function fuse_vnf( height=[[0,0]], width=[[0,0]], offset=[[0,0]], wall=0, steps=10, res=50, path=ellipse(d=1) ) = (
    let( l = len(height), dx=2*wall/l )
    vnf_vertex_array(
        points=[
            for( i=[0:l-1] ) 
                apply(
                    back(offset[i].y) * right(height[i].x-wall+i*dx) * yrot(90), 
                    path3d( scale( [ width[i].y + wall, height[i].y + wall], p=path ))
                )
        ],
        col_wrap=true, caps=true, reverse=false, style="alt" )
);

///////////////////////////////////////////////////////////////////////////////////////////////
// modules
///////////////////////////////////////////////////////////////////////////////////////////////

// external called fuse modules, to be implemented (see also fuseflage.scad):
//module fuseSolid
module fuse2Solid( seg=0, r=0 )
{
    difference(){
        union(){
			length = (seg<4) ? 170 : 4 * 170;
			start = (seg<4) ? -140+seg*length : -140+3*170;
			radialSlice( sh=length, sx=100, org=[-length+start,0,0], rot=[0,90,0], mode=2, center=false ){
                xmove(fl-260) 
	                xflip() 
                        vnf_polyhedron( vnf_small_offset( fvnf_0, r ));
			}
		}
		union(){
			fuseFinger( df=25-r );  // here r has only the half effect 
			mirror([0,0,1]) fuseFinger(  df=25-r  );
			// 3mm cutout for wind with SD6060 profile, oversize is 0.5mm:
			spant3d( d=5, offset=+(o(zBase)+[0,0,r]), size=s(zBase), r=0.5-r, p=pSD6060 );
			spant3d( d=5, offset=-(o(zBase)+[0,0,r+5]), size=s(zBase), r=0.5-r, p=pSD6060 ); // spant3d is not centered, so we need to substract 5mm to the offset
			*translate([-308-r,0,0]) cube([fuseWidth*2,fuseWidth*2,fuseWidth*2], center=true); // cutout for the tail of the fuselage
        }
     }
}

//module fuseSegment([0,1,2,3]);
module fuse2Skin()
{
    difference(){
		difference(){
			children(0);
			children(1);
			}

		
		fuseGps();
		*fuseElrs();
			
		xTube( diameter=dBar1, length=100, tubeoffset=tubeOffset1, $fn=50 );
		mirror([0,0,1]) xTube( diameter=dBar1, length=100, tubeoffset=tubeOffset1, $fn=50 );
		xTube( diameter=dBar2, length=100, tubeoffset=tubeOffset2, $fn=50 );
		mirror([0,0,1]) xTube( diameter=dBar2, length=100, tubeoffset=tubeOffset2, $fn=50 );
		
		
		//fusePoly();
        xmove(fl-260) xflip() tubes();
		wingElectric();

		*fuseCamera();
		*fuseCamera1();
		*translate([296,4,0]) rotate([-90,180,-12]) servo_sg90( yadd=0 ); // cam on servo with usual arm
			
		translate([260-40,-2,+23+6]) rotate([8,0,0 ]) scale(7) fuseNaca(w=-10);
		translate([260-40,-2,-23-6]) rotate([180-8,0,0 ]) scale(7) fuseNaca(w=-10);
		translate([-210,-10,+30+3]) rotate([0,-90,20]) cylinder(d=10+4,h=70,center=true);  // ToFix: collision with inner tube
		translate([-210,-10,-30-3]) rotate([0,-90,20]) cylinder(d=10+4,h=70,center=true);
	}
}

module fuse2Segment( vseg=[0] )
{
	render(convexity = 2)
		for( seg=vseg )
			fuse2Skin(){
				fuse2Solid( seg, r=0 );	// regular solid
				difference(){ 
					fuse2Solid( seg, r=-fuseWall ); // 5mm reduced solid for 5 mm walls, cut the front to make the fuse solid solid
					;
					}	
				fuse2Solid( seg, r=-SkidWall ); // reduced by the skid thickness
				}
}
module fuse(){
  	xmove(fl-260) 
	xflip() 
	difference() {
	    vnf_polyhedron( fvnf_0 );
        innerfuse();
	}
  }
module innerfuse()
{
	fvnf_5 = vnf_small_offset( fvnf_0, -5 ); // alternative calculation for fvnf_5
    vnf_polyhedron( fvnf_5 );
    tubes(height=fuse_height, width=fuse_width, offset=fuse_offset,path=fuse_path);
}

module slide_mask(){
	d=5;
	a=85;
	l=300;
	o=120;
	ymove(10)
	difference() {
		move([-o, 0, -l/2])cube([l,l,l]);
		move([-o, 0,-(a-d)/2])cube([l,d,a-d]);
		move([-o,d, -a/2])cube([l,d,a]);		
		}
	move([+l-60,0,0])cube([l,l,l],center=true);
}

module slide_cut(){
	difference() {
		fuse();
		slide_mask();
	}
}

module slide_cut2(){
	intersection() {
		fuse();
		slide_mask();
	}
}

module boom(){
	//bvnf_5 = vnf_small_offset( bvnf_0, -5 ); 
    difference() {
        boomSolid( seg=0, r=0 );
        boomSolid( seg=0, r=-5 );
        move([-550,-50,150])cube([600,100,100]);
        //wingSegment( [s(zBase),s(zBoom)], [o(zBase),o(zBoom)] );
        //segment(size=[s(zBase),s(zBoom)], pos=[o(zBase),o(zBoom)], r=0);
    }
  }

module boomSolid( seg=0, r=0 )
{
    difference(){
        union(){
			//length = (seg<4) ? 170 : 4 * 170;
			//start = (seg<4) ? -140+seg*length : -140+3*170;
			//radialSlice( sh=length, sx=100, org=[-length+start,0,0], rot=[0,90,0], mode=2, center=false ){
            move([20,0,zBoom]) xflip() vnf_polyhedron( vnf_small_offset( bvnf_0, r ));
			//}
		}
		union(){
			//cutout for wing with SD6060 profile, oversize is 0.5mm:
			spant3d( d=100, offset=+(o(zBoom)+[0,0,-50+5+r]), size=s(zBoom), r=0.5-r, p=pSD6060 ); //todo: use the real wing
            move([20,0,zBoom]) xflip() #tubes(height=boom_height, width=boom_width, offset=boom_offset, angs=[0,180], start=0, path=ellipse(d=1));
        }
     }
}
