
include <BOSL2/std.scad>
include <servo_arm.scad>



pFuseProfile = pSD6060; // use SD6060 profile for the inner fuselage, former alternative was pClarkY

module solidHull( r=0 )
{
	hull()
	{
		// outer fuse with SD6060 profiles to connect the wings with 3mm overlap:
		translate([0,0,-0.15])  spant3d( d=0.3, offset=+(o[0]+[0,0,3+r]), size=s[0],  r=r, p=pSD6060 );
		translate([0,0,-0.15])  spant3d( d=0.3, offset=-(o[0]+[0,0,3+r]), size=s[0],  r=r, p=pSD6060 );
		// inner fuse with ClarkY profiles
		translate([fuseLength0,fuseY0,-0.15]) 
			spant3d( d=0.3, offset=[0,0,fuseWidth/2+r],    size=fuseInnerSpant,   r=r, p=pFuseProfile );
		translate([fuseLength0,fuseY0,-0.15]) 
			spant3d( d=0.3, offset=[0,0,-(fuseWidth/2+r)], size=fuseInnerSpant,   r=r, p=pFuseProfile );
	}
}

module solidPolyhedron( r=0 )
{
	// use BOSL2:
	p1 = offset( move( [-fuseLength0, fuseY0], pFuseProfile * fuseInnerSpant * 1.13 ), delta=r ); 
	p2 = offset( pSD6060 * s(zBase), delta=r ); 
	//bool1 = is_path( p1 );
	//bool2 = is_region([p1, p2]);
	//echo( bool1, bool2 );

	zpos1 = fuseWidth/2+r;
	zpos2 = o(zBase).z+3+r;

	mirror([1,0]) 
	skin( [
		p2,
		p1, 
		p1, 
		p2], 
		z=[-zpos2, -zpos1, +zpos1, +zpos2], 
		slices=0 );
}

module fuseSolid( seg=0, r=0 )
{
    difference(){
        union(){
			length = (seg<4) ? 170 : 4 * 170;
			start = (seg<4) ? -140+seg*length : -140+3*170;
			radialSlice( sh=length, sx=100, org=[-length+start,0,0], rot=[0,90,0], mode=2, center=false ){
				*solidHull(r);
				solidPolyhedron(r);
			}
		}
		union(){
			fuseFinger( df=25-r );  // here r has only the half effect 
			mirror([0,0,1]) fuseFinger(  df=25-r  );
			// 3mm cutout for wind with SD6060 profile, oversize is 0.5mm:
			spant3d( d=5, offset=+(o(zBase)+[0,0,r]), size=s(zBase), r=0.5-r, p=pSD6060 );
			spant3d( d=5, offset=-(o(zBase)+[0,0,r+5]), size=s(zBase), r=0.5-r, p=pSD6060 ); // spant3d is not centered, so we need to substract 5mm to the offset
			translate([-308-r,0,0]) cube([fuseWidth*2,fuseWidth*2,fuseWidth*2], center=true); // cutout for the tail of the fuselage
        }
     }
    
}

module fuseCoverMask( x=0, r=45, h=100 )
{
	translate([x-h/2,30,0]){   // cutout for classic cover, height is fix 60mm
		cuboid([h,60,r], rounding=8 ); // center=true is implicid for cuboid
		}
}

module fuseFinger( df=25 )
{
    translate([-30,-58-2,-45-1-8])
    rotate([0,0,-30])
    rotate([-80,0,0])
    union(){
    cylinder(d=df,h=50);
    translate([0,0,50]) sphere( d=df );
    }
}

module fuseSkin()
{
    difference(){
		difference(){
			children(0);
			children(1);
			}

		fuseCoverMask(x=CoverPositionFront-5, r=CoverWidth-6, h=CoverLenthFront-10);
		fuseCover(){
			children(0);
			children(2);
			fuseCoverMask(x=CoverPositionFront+CoverGap/2, r=CoverWidth+CoverGap, h=CoverLenthFront+CoverGap);
			}

		fuseCoverMask(x=CoverPositionMid-5, r=CoverWidth-6, h=CoverLenthMid-10);	//fuseWith is increased from 50 to 58, so at least 44 do we need for 4s21700 battery
		fuseCover(){
			children(0);
			children(2);
			fuseCoverMask(x=CoverPositionMid+CoverGap/2, r=CoverWidth+CoverGap, h=CoverLenthMid+CoverGap);
			}

		fuseCoverMask(x=CoverPositionBack-5, r=CoverWidth-6, h=CoverLenthBack-10);
		fuseCover(){
			children(0);
			children(2);
			fuseCoverMask(x=CoverPositionBack+CoverGap/2, r=CoverWidth+CoverGap, h=CoverLenthBack+CoverGap);
			}

		translate([CoverPositionFront-CoverLenthFront-6,0,0]) rotate([-90,0,0]) cylinder(d=2.5, h=60);//fuseCoverHookKnop();
		translate([CoverPositionMid-CoverLenthMid-6,0,0]) rotate([-90,0,0]) cylinder(d=2.5, h=60);//fuseCoverHookKnop();
		translate([CoverPositionBack-CoverLenthBack-6,0,0]) rotate([-90,0,0]) cylinder(d=2.5, h=60);//fuseCoverHookKnop();

		*translate([-80,35-10,0]) cube([60,80,36], center=true); // FC           
		
		fuseGps();
		*fuseElrs();
			
		xTube( diameter=dBar1, length=100, tubeoffset=tubeOffset1, $fn=50 );
		mirror([0,0,1]) xTube( diameter=dBar1, length=100, tubeoffset=tubeOffset1, $fn=50 );
		xTube( diameter=dBar2, length=100, tubeoffset=tubeOffset2, $fn=50 );
		mirror([0,0,1]) xTube( diameter=dBar2, length=100, tubeoffset=tubeOffset2, $fn=50 );
		
		fuseSkid(){
			children(0);
			children(3);
		};
		
		fusePoly();
		wingElectric();

		*fuseCamera();
		*fuseCamera1();
		translate([296,4,0]) rotate([-90,180,-12]) servo_sg90( yadd=0 ); // cam on servo with usual arm
			
		translate([260-40,-2,+23+6]) rotate([8,0,0 ]) scale(7) fuseNaca(w=-10);
		translate([260-40,-2,-23-6]) rotate([180-8,0,0 ]) scale(7) fuseNaca(w=-10);
		translate([-210,-10,+30+3]) rotate([0,-90,20]) cylinder(d=10+4,h=50,center=true);  // ToFix: collision with inner tube
		translate([-210,-10,-30-3]) rotate([0,-90,20]) cylinder(d=10+4,h=50,center=true);
	}
}

module fuseSegment( vseg=[0] )
{
	render(convexity = 2)
		for( seg=vseg )
			fuseSkin(){
				fuseSolid( seg, r=0 );	// regular solid
				difference(){ 
					fuseSolid( seg, r=-fuseWall ); // 5mm reduced solid for 5 mm walls, cut the front to make the fuse solid solid
					*translate([300+5,0,0]) cube([40,50,50],center=true); 
					;
					}	
				fuseSolid( seg, r=-CoverWall ); // reduced by the cover skin	
				fuseSolid( seg, r=-SkidWall ); // reduced by the skid thickness
				}
}

module fuseCoverHookKnop()
{
    difference(){
        hull(){
            translate([-10,0,-8])cylinder(d=1,h=5);
            translate([0,0,-10])cylinder(d=8,h=8.3);
            translate([+10,0,-8])cylinder(d=1,h=5);
            }
        translate([0,0,-10])cylinder(d=6.4,h=10);
    }
}
module fuseCoverHookKnop2( a=10, ha=0.3 )
{
    difference(){
        hull(){
            translate([-a,0,ha])cylinder(d=1,h=5);
            translate([0,0, 0])cylinder(d=8,h=8.3);
            translate([+a,0,ha])cylinder(d=1,h=5);
            }
        *translate([0,0,-1])cylinder(d=2.5,h=10);
        translate([0,0,2])
			ScrewAndHexNut( m=2,dist=5 ); 
    }
}

module fuseCoverHookBase2( a=10, ha=0.3 )
{
    difference(){
		translate([0,0, 0])cylinder(d=12,h=4);
		translate([0,0,4.5])
			ScrewAndHexNut( m=2,dist=5 ); 
    }
}

module fuseCoverHook(op=false)
{
    cylinder(d=8,h=7);    
    hull()
    {
        translate([0,0,4]) cylinder(d=8,h=2);
        translate([4,0,4]) cylinder(d=8,h=2);
        }
    if( op == true ){
        translate([0,0,-10])cylinder(d=6,h=10);
        *fuseCoverHookKnop();
    }else{
        translate([0,0,-2])cylinder(d=6,h=2);
    }
}

module fuseCoverMount_1()
{
    difference(){
        cube( [10,7,20], center=false );
        cube([6,3.5+0.7,20], center=false);
        
    }
}

module fuseCover()
{
	intersection() {
		difference() {	// build the skin for the cover
			children(0);
			children(1);
		}
		children(2); // and intersect with the increased cover mask
	}	
}
 
module fuseCoverFront()
{
	fuseCover(){
		fuseSolid( 10, r=0 );	// regular solid
		fuseSolid( 10, r=-1.5 ); // reduced by the cover skin	
		fuseCoverMask(x=CoverPositionFront, r=CoverWidth, h=CoverLenthFront);
		}
	translate([CoverPositionFront,15,-10]) rotate([0,0,160]) fuseCoverMount_1();
}
module fuseCoverFrontVtx()
{
	base = [CoverPositionFront-40,25-5,0];
	rot = [0,0,170];
	dist = 10.0; //12.5;
	off = (12.5-10.0)/2;

	module VtxHole(s=[35,35,35], off=[0,0,0]) {
		translate(base+off) rotate(rot)
			cuboid(size=s, rounding=3, edges=[BACK, BOT+RIGHT, BOT+LEFT, TOP+RIGHT, TOP+LEFT ] );
	}
	module VtxMount(m=true){
		translate(base) rotate(rot)
		mirror([m?1:0,0,0])
		difference(){
			translate([-off,0,0]) cuboid([6+4,10+1,42], rounding=2, edges=[BACK] );
			translate([-off,-1,0]) cuboid([6+4+1,8+1,35]);
			hull(){
				translate([0,0,+dist]) ycyl(d=2.5,h=15);
				translate([-2*off,0,+dist+2*off]) ycyl(d=2.5,h=15);
			}
			hull(){
				translate([0,0,-dist]) ycyl(d=2.5,h=15);
				translate([-2*off,0,-dist-2*off]) ycyl(d=2.5,h=15);
			}
		}
	}
	module AntMount(h1=16)
	{
		translate([25,-2,-15]) 
		translate(base) rotate(rot) rotate([90+15,0,3])
		difference(){
			cylinder(d=8, h=h1+10 );
			translate([0,0,0]) cylinder(d=4.25, h=h1+10 );
			translate([0,2,0]) cube([2,8,2.5*(h1+10)],center=true);   
    	}
	}

	difference() {
		union() {
			fuseCoverFront();
			VtxHole([42,3,42], off=[0,3+0.8,0]);
			}
		VtxHole();
	}
	translate([+dist,-1.8,0]) VtxMount(m=false);
	translate([-dist,+1.8,0]) VtxMount(m=true);
	AntMount();
	mirror([0,0,1]) AntMount();
}


module fuseCoverMid()
{
	fuseCover(){
		fuseSolid( 10, r=0 );	// regular solid
		fuseSolid( 10, r=-1.5 ); // reduced by the cover skin	
		fuseCoverMask(x=CoverPositionMid, r=CoverWidth, h=CoverLenthMid);
		}
	translate([CoverPositionMid,33.5,-10]) rotate([0,0,175]) fuseCoverMount_1();
}

module fuseCoverBak()
{
	fuseCover(){
		fuseSolid( 10, r=0 );	// regular solid
		fuseSolid( 10, r=-1.5 ); // reduced by the cover skin	
		fuseCoverMask(x=CoverPositionBack, r=CoverWidth, h=CoverLenthBack);
		}
	translate([CoverPositionBack,29.5,-10]) rotate([0,0,185]) fuseCoverMount_1();
}

module fuseGps()
{
    translate([-160,13+7-fuseWall/2,0]) rotate([0,0,7]) cube( [26,8,26], center=true ); // BZ 251
    translate([-150,13,0]) rotate([0,0,7]) cube( [6,30,10], center=true );
}

module fuseElrs()
{
    translate([-100,13,35]) rotate([90,0,7]) cylinder(d=5,h=30,center=true );

}

module fuseNaca(w=-12)
{
    module hole(){
    p = [[-5,0], [-5,1.5], [0,1.5], [1,1.25], [2,0.8] ,[3,0.6] ,[4,0.4], [10,0.4], [10,0]];
    linear_extrude(height=1 )polygon(p);
    mirror([0,1,0]) linear_extrude(height=1 )polygon(p);
    }
    
    translate([0,0,0]) rotate([0,w,0]) hole();
}


module fuseSkid( r=0 )
{
	// wechselbare Platte für den Boden... 25x5cm, 2 Layer
	d = fuseWidth-8;
	l = 220-d;
	Slice(){
		innerSkin(){
			children(0);
			children(1);
			}
		translate([180,-15,0]) 
			rotate([90,0,0]) 
			hull(){
				translate([-l/2,0,0]) cylinder(d=d-2*r,h=50);
				translate([+l/2,0,0]) cylinder(d=d-2*r,h=50);
				}
		}
}

module fuseSkid2( r=0 ) // is no replacement for fuseSkid(), simplified for flat printing
{
    // wechselbare Platte für den Boden... 25x5cm, 2 Layer?
    // Rand ???
    d = fuseWidth-8;
    l = 220-d;
    translate([180,-15,0]) 
        rotate([90,0,0]) 
            hull(){
                translate([-l/2,0,0]) cylinder(d=d-2*r,h=0.6);
                translate([+l/2,0,0]) cylinder(d=d-2*r,h=0.6);
                }
}

module fuseCamera1()
{
    translate([fuseLength0-20-4,3+fuseY0+0.5,0]) // add 0.5mm to cam position in smaller fuselage
        rotate([0,90,0])
            union(){
                cylinder(d=15, h=30);
                cube([21,21,15], center=true);
                }
}
module fuseCamera2( ang=0, open=true )
{
	O=6;
	//translate([fuseLength0-20-4,3+fuseY0,0])
		rotate([0,90+ang,0])
			union(){
				if( open == true )
				{
					translate([0,0,12+12+O]) 
						cylinder(d1=15, d2=100,h=20);
				}
				translate([0,0,12+O]) 
					cylinder(d=15, h=12);
				translate([0,0,6+O]) 				
					cube([21,21,12], center=true);
                }
}

module fuseCamera3( ang=0, open=true )
{
//pan cam mount?
	//front_half()
	//bottom_half()
	difference() {
	yrot( -90 ) onion(d=35, ang=35);
	//left(10) xcyl(d=15,h=20);
	up(1) left(14) fuseCamera2();
	down(17) zcyl(d=2,h=15,chamfer2=-0.6);
	// down(19) zcyl(d=4.2,h=15); // servo head will replace this
	down(15) servo_head(MY_FT90M_SPLINE, clear = SERVO_HEAD_CLEAR);
	down(22.5) zcyl(d=6,h=15); // some space to support servo head
	down(23) zcyl(d=15,h=15); // cut for the servo body
	left(20)xcyl(d=4,h=24,chamfer2=-3);// cam cable
	#fwd(8) left(10){
		down(10) zcyl(d=1.8,h=20);
		up(3) zcyl(d=2.6,h=6);
		up(12) zcyl(d=4,h=12);
		}
	#back(8) left(10){
		down(10) zcyl(d=1.8,h=20);
		up(3) zcyl(d=2.6,h=6);
		up(12) zcyl(d=4,h=12);
		}
	}
}

module fuseCamera()
{
	translate([fuseLength0-40,1.5+fuseY0,0]){
		for( w=[-90:1:90] ) 
		{
			rotate([0,w,0])
				fuseCamera2();
		}
		fuseCamera2();
		*rotate([0,90,0]) fuseCamera2();
		rotate([-90,0,0]) cylinder(d=4.5, h=70, center=true); // camera mount
		rotate([-90,0,0]) cylinder(d=20, h=21, center=true); // remove rotation fragments
	}
}
module fusePoly()
{
	mirror([1,0,0])
	{
		pp = offset( move( [-fuseLength0, fuseY0], pFuseProfile * fuseInnerSpant * 1.13 ), delta=-fuseWall/2 ); 
		fusePolyLine(  d=dPoly, off=[+fuseWidth/2-fuseWall/2,0], size=1, p=pp );
		fusePolyLine(  d=dPoly, off=[-fuseWidth/2+fuseWall/2,0], size=1, p=pp );
	}
	fusePolyLineQ( d=dPoly, pt=ptWingNose, off=[+2,+0.5] );
	fusePolyLineQ( d=dPoly, pt=ptQRuder, off=[+0,+0] );

}
module tubeFlansh2( d=8, a=0, h=60, w=3, r=0 )
{
    offh = +(d+w)/2+1;
    translate([-420, tailz0, +zBoom])
    translate([-20,0,0])
    difference(){
        union(){
            //hull()
                translate([0,-a,0]) rotate([0,-90,0]) cylinder(d=d+w, h=h, center = false );   
            hull() // to sruder
                {
                //translate([-2,offh,1]) rotate([-90,0,0]) cylinder(d1=d+r, d2=1+r, h=40, center = false );
                //translate([-42,offh,1]) rotate([-90,0,0]) cylinder(d1=d+r, d2=1+r, h=40, center = false );
                translate([-20,0+40,0]) cube([40+r,1,3+r],center=true);
                translate([-20,0,0]) cube([40+r,1,d+w-2+r],center=true);
                }
            hull()
                {
                translate([-10,-5,-1]) rotate([180,0,0]) cylinder(d=20, h=3, center = false );
                translate([-20,-5,-1]) rotate([180,0,0]) cylinder(d=20, h=3, center = false );
                }
            hull()
                {
                translate([-10,-5,+3]) rotate([180,0,0]) cylinder(d=20, h=3, center = false );
                translate([-20,-5,+3]) rotate([180,0,0]) cylinder(d=20, h=3, center = false );
                }
            }
            
        translate([-2*h,-a,0]) rotate([0,90,0]) cylinder(d=d+0.2, h=h*3, center = false );
        translate([8,-a,0]) rotate([0,90,0]) cylinder(d1=d+0.2,d2=d+1, h=12, center = false );
        
        translate([0-2*h,-a, 0] )
            rotate( [90+90,0,0] )
                cube([h*3,h*3,1], center = false );    // cut a 1mm gap
        translate([ -10, -8, -0.5] )                    
            ScrewAndHexNut( m=2,dist=5 );            
        }
}

module fuseBattery()
{
	// 4s21700 battery, 72x44x44mm, critical with SD6060 profile
	// ToDo: Platte zur Befestigung passt nicht mehr, Schraube bohrt sich in den Akku?
	// ToDo: Cover lock funktioniert nicht mehr
	translate([160,0,0]) 
		rotate([0,0,0])
			cube( [72,46,45], center=true );
}

module CamPan()
{
	// 3d printed camera pan,
	translate([fuseLength0-40,1.5+fuseY0,0])
	rotate([-90,0,0])
		difference() {
			union(){
				cylinder(d=47+6+6, h=14.5, center=true );
				cylinder(d=41, h=20.5, center=true );
			}
			union() {
			cylinder(d=4.5, h=70, center=true); // camera mount
			rotate([0,90,0]) cylinder(d=11, h=70, center=true); // camera mount
			translate([-1,0,0])
			rotate([0,90,0]){
				translate([0,0,12+6]) 
					cylinder(d=15.5, h=12);
				translate([0,0,6+6]) 				
					cube([21.5,21.5,12], center=true);
			}
			translate([22,0,15/2]) cube(15.5, center=true); 
			translate([0,5,15/2]) cube([60,2,15], center=true); 
			}	
		}
}