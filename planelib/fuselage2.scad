$fn=30;

// 2025/Nov/16 Design ist for the very old Lidl Glider  model
// todo:
// add neuer models
// add front motor mount 16/19 mm holes 3.2mm diameter

include <BOSL2/std.scad>;

///////////////////////////////////////////////////////////////////////////////////////////////
// main
///////////////////////////////////////////////////////////////////////////////////////////////
//fuse();
//partition(size=[500,200,200],spread=25, cutpath="flat") fuse();
slide_cut();
ymove(0) slide_cut2();

///////////////////////////////////////////////////////////////////////////////////////////////
// data
///////////////////////////////////////////////////////////////////////////////////////////////
fl=470;

// define the fuse data
bez_y = [   // segmente y(x) , hoehe
    mkbez( [0,1], [165,80], [0,27], [100,0]),   // point1 -> point2 with dir1 and dir2
    mkbez( [165,80], [fl-20,30], [100,0], [30,0]),
    mkbez( [fl-20,30], [fl,3], [20,0], [0,-20])
    ];
bez_z = [   // segmente z(x) , breite
    mkbez( [0,1], [140,110], [0,35], [100,0]),   // point1 -> point2 with dir1 and dir2
    mkbez( [140,110], [fl-20,90], [35,0], [30,0]),    
    mkbez( [fl-20,90], [fl,3], [20,0], [0,-20]),    
    ];
bez_o = [   // segmente o(x)
    mkbez( [0,3], [165,0], [30,0], [60,0]),    // point1 -> point2 with dir1 and dir2
    mkbez( [165,0], [400,0], [60,0], [60,0]),
    mkbez( [400,0], [600,0], [60,0], [135,0]),
    //mkbez( [0,3], [160,20], [30,0], [60,0]),    // point1 -> point2 with dir1 and dir2
    //mkbez( [200,20], [600,25], [60,0], [135,0]),
    //mkbez( [600,3], [650,3], [35,0], [35,0])
    ];

steps=20;
by0 = bezier_join(bez_y,steps);
bz0 = bezier_join(bez_z,steps);
bo0 = bezier_join(bez_o,steps);
bz1 = bezier_resample( bz0, by0 );
bo1 = bezier_resample( bo0, by0 );
fvnf_0 = vnf_drop_unused_points(fuse_vnf( bez_y, bez_z, bez_o, wall=0 ));


///////////////////////////////////////////////////////////////////////////////////////////////
// functions
///////////////////////////////////////////////////////////////////////////////////////////////

// calculate the ellipse
function my_ellipse( a, b, w ) = [ a * cos(w), b * sin(w) ];

// calculate a path for a tube in the fuse, w is the angle of the ellipse and d is the distance in the wall
function epath(w,d) = [ 
    [-3,bo1[0].y,0], 
    for( i=[1:1:len(bz1)-1]) 
        [bz1[i].x, bo1[i].y + (by0[i].y-d) * sin(w) / 2, (bz1[i].y-d) * cos(w) / 2], 
    ];

function epath2(w,d,start=1,end=len(bz1)-1) = [ 
    if(start<0)[start,bo1[0].y,0], 
    for( i=[start:1:end]) 
    [bz1[i].x, bo1[i].y + (by0[i].y-d) * sin(w) / 2, (bz1[i].y-d) * cos(w) / 2], ];

// draw 3 tube with fix 2mm under the skin    
module tubes(start=1, end=len(bz1)-1){
    stroke( width=2, epath2(-90, 3.5,start,end) );
    stroke( width=2, epath2(-15, 3.5,start,end) );
    stroke( width=2, epath2(195, 3.5,start,end) );
}

// create a bosl2 bezier with 2 point and 2 direction vectors from 4 points
function mkbez(a=[0,0],b=[10,10],da=[1,0],db=[0,1]) = [ a, a+da, b-db, b];  

// calculates the x-resolution - bad!
function mkres(bez) = round((bez[3].x - bez[0].x) * 0.05);

// join a set of bosl2 beziers, to a single set of 2d points using bezier_curve for each bezier
function bezier_join(bezs,steps=10) = ( [ for( i=bezs ) for( p=bezier_curve(i, splinesteps=steps)) p,] );

// use a union x vector, resample
function bezier_resample( org, ref ) = ([ for( x=ref ) [x.x,lookup( x.x, org )],]);

// creates a solid vnf based on elipses r(x)=y(x),z(x) and y offset is o(x)
function seg_vnf( y=[[0,0]], z=[[0,0]], o=[[0,0]], wall=0, res=12 ) = (   
    let( l = len(y), dx=2*wall/l )
    //echo(y) // eg x=200 is doublicate
    vnf_vertex_array(
        points=[
            for( i=[0:l-1] ) 
                apply(
                    back(o[i].y) * right(y[i].x-wall+i*dx) * yrot(90), 
                    path3d( ellipse( d=[z[i].y+wall,y[i].y+wall], $fn=res ) )
                )
        ],
        col_wrap=true, caps=true, reverse=false, style="alt" )
);

function fuse_vnf( y,z,o, wall=0, steps=10, res=50 ) = (
    let( by0 = bezier_join(y,steps), bz0 = bezier_join(z,steps), bo0 = bezier_join(o,steps) )
    let( bz1 = bezier_resample( bz0, by0 ), bo1 = bezier_resample( bo0, by0 ) )
    seg_vnf(    
            by0,
            bz1,
            bo1, 
            wall=wall,
            res=res )
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