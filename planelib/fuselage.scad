
include <BOSL2/std.scad>


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
	p2 = offset( pSD6060 * s[0], delta=r ); 
	//bool1 = is_path( p1 );
	//bool2 = is_region([p1, p2]);
	//echo( bool1, bool2 );

	zpos1 = fuseWidth/2+r;
	zpos2 = o[0].z+3+r;

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
			spant3d( d=5, offset=+(o[0]+[0,0,r]), size=s[0], r=0.5-r, p=pSD6060 );
			spant3d( d=5, offset=-(o[0]+[0,0,r+5]), size=s[0], r=0.5-r, p=pSD6060 ); // spant3d is not centered, so we need to substract 5mm to the offset
			translate([-308-r,0,0]) cube([fuseWidth*2,fuseWidth*2,fuseWidth*2], center=true); // cutout for the tail of the fuselage
        }
     }
    
}

module fuseCoverMask( x=0, r=45, h=100 )
{
	translate([x-h/2,30,0]){   // cutout for classic cover, height is fix 60mm
		cube([h,60,r], center=true);
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
		#fuseCamera();
			
		translate([260-50,-2,+23+6]) rotate([8,0,0 ]) scale(7) fuseNaca(w=-10);
		translate([260-50,-2,-23-6]) rotate([180-8,0,0 ]) scale(7) fuseNaca(w=-10);
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
				fuseSolid( seg, r=-fuseWall );	// 5mm reduced solid for 5 mm walls
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
        cube([5,3.5,20], center=false);
        
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
}

module fuseCoverMid()
{
	fuseCover(){
		fuseSolid( 10, r=0 );	// regular solid
		fuseSolid( 10, r=-1.5 ); // reduced by the cover skin	
		fuseCoverMask(x=CoverPositionMid, r=CoverWidth, h=CoverLenthMid);
		}
}

module fuseCoverBak()
{
	fuseCover(){
		fuseSolid( 10, r=0 );	// regular solid
		fuseSolid( 10, r=-1.5 ); // reduced by the cover skin	
		fuseCoverMask(x=CoverPositionBack, r=CoverWidth, h=CoverLenthBack);
		}
}

module fuseGps()
{
    translate([-160,13,0]) rotate([0,0,7]) cube( [26,8,26], center=true ); // BZ 251
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
    translate([fuseLength0-20-4,3+fuseY0,0])
        rotate([0,90,0])
            union(){
                cylinder(d=15, h=30);
                cube([21,21,15], center=true);
                }
}
module fuseCamera2()
{
	O=6;
	//translate([fuseLength0-20-4,3+fuseY0,0])
		rotate([0,90,0])
			union(){
				translate([0,0,12+12+O]) 
					cylinder(d1=15, d2=100,h=20);
				translate([0,0,12+O]) 
					cylinder(d=15, h=12);
				translate([0,0,6+O]) 				
					cube([21,21,12], center=true);
                }
}
module fuseCamera()
{
	translate([fuseLength0-40,1.5+fuseY0,0])
	for( w=[-90:1:90] ) 
	{
		rotate([0,w,0])
			fuseCamera2();
	}
	*translate([fuseLength0-40,1.5+fuseY0,0]){
		fuseCamera2();
		rotate([0,90,0]) fuseCamera2();
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