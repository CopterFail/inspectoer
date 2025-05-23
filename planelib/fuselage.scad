

module fuseSolid( r=0 )
{
    difference(){
        union(){
            hull()
            {
                *translate([-(fuseLength1 + r),0,0]) rotate([0,90,0]) cylinder(d=fuseMotorDia+2*r,h=5,center=true); //motor
                translate([0,0,-0.15])  spant3d( d=0.3, offset=(o[0]+[0,0,r]),  size=s[0],  r=r, p=pSD6060 );
                translate([fuseLength0,fuseY0,-0.15]) 
                    spant3d( d=0.3, offset=[0,0,fuseWidth/2+r],    size=fuseInnerSpant,   r=r, p=pClarkY /* pClarkFuse */ );
                translate([fuseLength0,fuseY0,-0.15]) 
                    spant3d( d=0.3, offset=[0,0,-(fuseWidth/2+r)], size=fuseInnerSpant,   r=r, p=pClarkY /* pClarkFuse */ );
                translate([0,0,-0.15])  spant3d( d=0.3, offset=-(o[0]+[0,0,r]), size=s[0],  r=r, p=pSD6060 );
            }
        }
        union(){
            fuseFinger( df=25-r );  // here r has only the half effect 
            mirror([0,0,1]) fuseFinger(  df=25-r  );
        }
     }
    
}

module fuseCoverMask( x=0, y=100, r=90, h=400 )
{
	translate([x,y,0]){   // cutout for classic cover
		hull(){
			translate([x,+r/2,0]) cube([h+2*r,0.1,r], center=true);
			translate([x,-r/2,0]) cube([h,0.1,r], center=true);
			}
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

module fuseSkin( fuseSkin = 5 )
{
    innerSkin(){
        union(){
            fuseSolid( r=0 );
            }
        union(){
            fuseSolid( r=-fuseSkin );
            
            fuseCoverMask(x=120, y=63-20+fuseY0, r=fuseWidth-10, h=80);
            fuseCoverFront(d=0.3);
            translate([161,35+10,0]) rotate([90,90,0]) cylinder(d=2.5, h=20);//fuseCoverHookKnop();

            #fuseCoverMask(x=35, y=60-20+fuseY0, r=fuseWidth-10+2, h=90);	//ToDo: fix the opening by 2, r will influence the x size ?
            fuseCoverMid(d=0.3);
            translate([-10,40,0]) rotate([90,90,0]) cylinder(d=2.5, h=20);//fuseCoverHookKnop();

            fuseCoverMask(x=-43, y=60-20+fuseY0, r=fuseWidth-10, h=45);
            fuseCoverBak(d=0.3);
            translate([-128,35-10,0]) rotate([90,90,0]) cylinder(d=2.5, h=20);//fuseCoverHookKnop();

            *translate([-80,35-10,0]) cube([60,80,36], center=true); // FC           
            *fuseMotor(d=0, holes=false);
            
            fuseGps();
            fuseElrs();
                
            xTube( diameter=dBar1+2, length=100, tubeoffset=tubeOffset1, $fn=50 );
            mirror([0,0,1]) xTube( diameter=dBar1+2, length=100, tubeoffset=tubeOffset1, $fn=50 );
            xTube( diameter=dBar2+2, length=100, tubeoffset=tubeOffset2, $fn=50 );
            mirror([0,0,1]) xTube( diameter=dBar2+2, length=100, tubeoffset=tubeOffset2, $fn=50 );
            
            translate([-210,-10,+30])
                rotate([0,-90,20])
                    cylinder(d=10,h=40,center=true);
            translate([-210,-10,-30])
                rotate([00,-90,20])
                    cylinder(d=10,h=40,center=true);
            *translate([-258,+20,0])
                rotate([00,-90,-20])
                    cylinder(d=10,h=80,center=true);

             fuseSkid();
             fusePoly();
             wingElectric();
             fuseCamera();
             
             
             translate([260,-2,+23]) rotate([8,0,0 ]) scale(7) fuseNaca(w=-10);
             translate([260,-2,-23]) rotate([180-8,0,0 ]) scale(7) fuseNaca(w=-10);
             
             fuseWingMount(dx=0.2);
             mirror([0,0,1])fuseWingMount(dx=0.2);
             
             *fuseFinger();

            }
        }
       
       *fuseMotor(d=0.5, holes=true);
       *wingSegment( [s[0],s[1]], [o[0],o[1]], do = 2 );
       *mirror( [0,0,1] ) wingSegment( [s[0],s[1]], [o[0],o[1]], do = 2 );
}

module fuseSegment( seg=0 )
{
    length = 170;
    start = -140+seg*length;
    radialSlice( sh=length, sx=100, org=[-length+start,0,0], rot=[0,90,0], mode=2, center=false )
    {
        fuseSkin( fuseSkin = 5 );
    }
}

module fuseWingMount( pos=0, dx=0 )
{
    h1 = 5+dx;
    w1 = 8+dx;
    translate([0,tubeOffsety,-o[0].z-h1/2]) rotate([0,0,180])
        difference()
            {
            union()
                {
                translate([tubeOffset1,0,0]) cylinder( d = dBar1+2+2+dx, h = o[0].z+h1/2 );
                hull()
                    {
                    translate([tubeOffset1,0,0]) cylinder( d = 19+dx, h = h1 );
                    translate([tubeOffset1+0,-w1/2-4,0]) cube( [19,w1,h1]);
                    }

                translate([tubeOffset2,0,0]) cylinder( d = dBar2+2+2+dx, h = o[0].z+h1/2 );
                hull()
                    {
                    translate([tubeOffset2,0,0]) cylinder( d = 16+dx, h = h1 );
                    translate([tubeOffset2-16,-w1/2-4,0]) cube( [16,w1,h1]);
                    }
                translate([tubeOffset1,-w1/2-4,0]) cube( [tubeOffset2-tubeOffset1,w1,h1]);
                }
            union()
                {
                if ( dx<=0.0 )
                {
                    translate([tubeOffset1,0,-1]) cylinder( d = dBar1, h = o[0].z+h1/2+2 );
                    translate([tubeOffset2,0,-1]) cylinder( d = dBar2, h = o[0].z+h1/2+2 );
                    }
                }
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

module fuseCoverFront(d=0.1)
{
    coverSkin = 1.5;
    hx1 = 296-4;
    hy1 = 37;
    hx2 = 172.5;
    hy2 = 52.5;

    Slice(){
        innerSkin(){
            fuseSolid( r=+d );
            union(){
                fuseSolid( r=-coverSkin-d );
                translate([ hx1, hy1, 0])
                    rotate([90,0,-12])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                translate([hx2, hy2, 0])
                    rotate([90,180,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                }
            }
        fuseCoverMask(x=120, y=63-3-d-20+fuseY0, r=fuseWidth-4, h=80);
        fusePoly();

        }
    *translate([hx1,hy1,0])
        rotate([90,0,-12])
            fuseCoverHook();

    *translate([hx2,hy2,0])
        rotate([90,180,0])
            fuseCoverHook( true );
}

module fuseCoverMid(d=0.1)
{
    coverSkin = 2;
    hx1 = 122;
    hy1 = 52.5;
    hx2 = 22.5;
    hy2 = 47;

    Slice(){
        innerSkin(){
            fuseSolid( r=+d );
            union(){
                fuseSolid( r=-coverSkin-d );
                translate([ hx1, hy1, 0])
                    rotate([90,0,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                translate([hx2, hy2, 0])
                    rotate([90,180,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                }
            }
        fuseCoverMask(x=35, y=60-3-d-20+fuseY0, r=fuseWidth-4, h=90);
        }
    *translate([hx1,hy1,0])
        rotate([90,0,0])
            fuseCoverHook();

    *translate([hx2,hy2,0])
        rotate([90,180,0])
            fuseCoverHook( true );
}

module fuseCoverBak(d=0.1)
{
    coverSkin = 2;
    hx1 = 122;
    hy1 = 52.5;
    hx2 = 22.5;
    hy2 = 47;

    Slice(){
        innerSkin(){
            fuseSolid( r=+d );
            union(){
                fuseSolid( r=-coverSkin-d );
                translate([ hx1, hy1, 0])
                    rotate([90,0,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                translate([hx2, hy2, 0])
                    rotate([90,180,0])
                        translate([0,0,-10])cylinder(d=6.4,h=10);
                }
            }
        fuseCoverMask(x=-43, y=60-3-d-20+fuseY0, r=fuseWidth-4, h=45 );
        }
    *translate([hx1,hy1,0])
        rotate([90,0,0])
            fuseCoverHook();

    *translate([hx2,hy2,0])
        rotate([90,180,0])
            fuseCoverHook( true );
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
    // fehlt die Schraegung und der Luftkanal...
}

module fuseSkid( r=0 )
{
    // wechselbare Platte für den Boden... 25x5cm, 2 Layer?
    // Rand ???
    d = 40;
    l = 220-d;
    Slice(){
        innerSkin(){
            fuseSolid( r=0 );
            fuseSolid( r=-0.5 );
            }
        translate([180,-15,0]) 
            rotate([90,0,0]) 
                hull(){
                    translate([-l/2,0,0]) cylinder(d=d-r,h=50);
                    translate([+l/2,0,0]) cylinder(d=d-r,h=50);
                    }
        }
}

module fuseSkid2( r=0 )
{
    // wechselbare Platte für den Boden... 25x5cm, 2 Layer?
    // Rand ???
    d = 40;
    l = 220-d;
    translate([180,-15,0]) 
        rotate([90,0,0]) 
            hull(){
                translate([-l/2,0,0]) cylinder(d=d-2*r,h=0.6);
                translate([+l/2,0,0]) cylinder(d=d-2*r,h=0.6);
                }
}

module fuseCamera()
{
    translate([fuseLength0-20,3+fuseY0,0])
        rotate([0,90,0])
            union(){
                cylinder(d=15, h=30);
                cube([21,21,15], center=true);
                }
}

module fusePoly()
{
    //translate([fuseLength0-3,0,0])
    translate([fuseLength0-2.5,fuseY0,-0.15]) 
        mirror([1,0,0])
        {
            //fusePolyLine( d=dPoly, off=[-2.7+fuseWidth/2,-4], size=fuseInnerSpant, p=pClarkFusePolyUp ); 
            //fusePolyLine( d=dPoly, off=[-2.5+fuseWidth/2,+5], size=fuseInnerSpant, p=pClarkFusePolyDown ); 
            fusePolyLine(  d=dPoly, off=[-2.7+fuseWidth/2,+2.7], size=fuseInnerSpant, p=pClarkY2 );
            fusePolyLine(  d=dPoly, off=[-2.5+fuseWidth/2,-2.5], size=fuseInnerSpant, p=pClarkY2 );

            //fusePolyLine( d=dPoly, off=[+2.7-fuseWidth/2,-4], size=fuseInnerSpant, p=pClarkFusePolyUp ); 
            //fusePolyLine( d=dPoly, off=[+2.5-fuseWidth/2,+5], size=fuseInnerSpant, p=pClarkFusePolyDown ); 
            fusePolyLine(  d=dPoly, off=[+2.7-fuseWidth/2,+2.7], size=fuseInnerSpant, p=pClarkY2 );
            fusePolyLine(  d=dPoly, off=[+2.5-fuseWidth/2,-2.5], size=fuseInnerSpant, p=pClarkY2 );
            
            //offsetPolyLine(  d=dPoly, size=605, off=0, p=pClarkY );
            //offsetPolyLine(  d=dPoly, size=605, off=-10, p=pClarkY );
            
            }
    fusePolyLineQ( d=dPoly, pt=ptWingNose, off=[+2,+0.5] );
    fusePolyLineQ( d=dPoly, pt=ptQRuder, off=[+0,+0] );

}

module tubeFlansh( d=8, a=0, h=60, w=3, r=0 )
{
    offh = +(d+w)/2+1;
    translate([-420, tailz0, +zBoom])
    translate([-20,0,0])
    difference(){
        union(){
            hull()
                {
                translate([0,-a,0]) rotate([0,-90,0]) cylinder(d=d+w, h=h, center = false );   
                translate([20,+offh,3]) rotate([90,0,0]) 
                    mirror([0,1,0])
                        spant3d( d=0.3, offset=[0,0,0], size=120, r=0, p=pSD6060 );
                translate([20,-3,-offh]) 
                    spant3d( d=0.3, offset=[0,0,0], size=120, r=0, p=pNaca0012 );
                }
            hull() // to sruder
                {
                translate([-2,offh,1]) rotate([-90,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                translate([-42,offh,1]) rotate([-90,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                }
            hull() // to hruder
                {
                translate([+5,-3,-1.5]) rotate([180,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                translate([-30,-3,-1.5]) rotate([180,0,0]) cylinder(d1=d+r, d2=1+r, h=20, center = false );
                }
            hull()
                {
                translate([-15,-5,-1.5]) rotate([180,0,0]) cylinder(d=20, h=2, center = false );
                translate([-50,-5,-1.5]) rotate([180,0,0]) cylinder(d=20, h=2, center = false );
                }
            
            }
        translate([-2*h,-a,0]) rotate([0,90,0]) cylinder(d=d+0.2, h=h*3, center = false );
        translate([8,-a,0]) rotate([0,90,0]) cylinder(d1=d+0.2,d2=d+1, h=12, center = false );
        
        translate([0-2*h,-a, 0] )
            rotate( [45+90,0,0] )
                cube([h*3,h*3,1], center = false );    // cut a 1mm gap

        hull(){ 
            translate([+20-ptHRuder.x*120, -3+ptHRuder.y*120, -4-dPoly]) sphere(d=dPoly); 
            translate([+20-ptHRuder.x*120, -3+ptHRuder.y*120, +3+dPoly]) sphere(d=dPoly); 
            }
        hull(){ 
            translate([+20-2, -3, -4-dPoly]) sphere(d=dPoly); 
            translate([+20-2, -3, +3+dPoly]) sphere(d=dPoly); 
            }
        translate([-45,-2,-8]) cube([12,6,10], center=true ); // servo cable - bad

        }
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
