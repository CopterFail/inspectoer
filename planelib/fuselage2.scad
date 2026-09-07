
include <BOSL2/std.scad>;

///////////////////////////////////////////////////////////////////////////////////////////////
// main
///////////////////////////////////////////////////////////////////////////////////////////////

#fuse();
//partition(size=[500,200,200],spread=25, cutpath="flat") fuse();
//slide_cut();
//ymove(0) slide_cut2();
boom();
zflip() boom();

tubes(height=fuse_height, width=fuse_width, offset=fuse_offset,path=fuse_path);
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
            mkbez( [140,110], [fl-20,90], [35,0], [30,0]),    
            mkbez( [fl-20,90], [fl,3], [20,0], [0,-20])],
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
boom_path = star(n=5,r=1,ir=0.7);
boom_height = bezier_join( [   // segmente y(x) , hoehe
        mkbez( [0,bd1], [150,bd2], [0,27], [100,0]),   // point1 -> point2 with dir1 and dir2
        mkbez( [150,bd2], [bl-20,bd2], [100,0], [30,0]),
        mkbez( [bl-20,bd2], [bl,3], [20,0], [0,-20])],
        steps);
boom_width = bezier_resample(
        bezier_join([ 
            mkbez( [0,bd1], [150,bd3], [0,27], [100,0]),   // point1 -> point2 with dir1 and dir2
            mkbez( [150,bd3], [bl-20,bd3], [100,0], [30,0]),
            mkbez( [bl-20,bd3], [bl,3], [20,0], [0,-20])],
            steps),
        boom_height);
boom_offset = bezier_resample( 
        bezier_join([ 
            mkbez( [0,3], [bl,bh1], [80,0], [60,0]) ], 
            steps), 
        boom_height);

bvnf_0 = vnf_drop_unused_points(fuse_vnf( boom_height, boom_width, boom_offset, wall=0, path=boom_path ));


///////////////////////////////////////////////////////////////////////////////////////////////
// functions
///////////////////////////////////////////////////////////////////////////////////////////////

// calculate a path for a tube in the fuse, w is the angle of the ellipse and d is the distance in the outer wall
function epath2(height,width,offset,w=0,d=3,start=1,end=1,path=ellipse(d=1)) = [
    let(pt = polygon_line_intersection(path,[[0,0],[cos(w),sin(w)]]))
    // using d is complicate because of x
    //if(start<0)[start*10,offset[0].y,0], 
    for( i=[start:1:end]) [
        height[i].x, 
        (height[i].y - d) * pt[0][0].x + offset[i].y, 
        (width[i].y - d) * pt[0][0].y
        ], 
    ];
// polygon_line_intersection( scale( [z[i].y+wall,y[i].y+wall], p=path ), [sin(w),cos(w)] ) see also seg_vnf() below.

// draw 3 tube with fix 2mm under the skin    
module tubes(height=fuse_height, width=fuse_width, offset=fuse_offset, start=0, path=ellipse(d=1)){
    end = len( height ) - 1;
    d = 3.5;
    xmove( fl-260 ) 
	xflip()
    color("Blue") 
    {
        stroke( width=2, epath2( height, width, offset, w=90, d, start, end, path ) );
        stroke( width=2, epath2( height, width, offset, w=0, d, start, end, path ) );
        stroke( width=2, epath2( height, width, offset, w=180, d, start, end, path ) );
    }
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

module fuse(){
	fvnf_10 = vnf_small_offset( fvnf_0, -10 ); // alternative calculation for fvnf_5
  	xmove(fl-260) 
	xflip() 
	//difference() {
	vnf_polyhedron( fvnf_0 );
	//vnf_polyhedron( fvnf_10 );
	//}
  }
module slide_mask(){
	d=5;
	a=75;
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

module innerfuse()
{
	move([-120,-25, -45/2])cube([210,45,45]);

}

module slide_cut(){
	difference() {
		difference() {
			fuse();
			innerfuse();
			}
		slide_mask();
	}
}

module slide_cut2(){
	intersection() {
		difference() {
			fuse();
			innerfuse();
			}
		slide_mask();
	}
}

module boom(){
	bvnf_10 = vnf_small_offset( bvnf_0, -10 ); 
	move([20,0,150])
	xflip()
	vnf_polyhedron( bvnf_0 );
  }
