
// Angle at the lower back side needs some improvement
module wingBowDraw()
{
    z0 = 25;
    off = 55;
    steps =z0/0.2;
    for (cnt=[0:steps]){
        zsize = sqrt(1-cnt/steps);
        z = z0 * sqrt(cnt/steps);
        zstep = z0 * sqrt((cnt+1)/steps) - z;
        translate(v = [-off,0,z]+o[3])
            scale( [zsize,zsize,1] ) 
                spant3d( d=zstep, offset=[+off,0,0], size=170, r=0, p=pSD6060 );
                }
                
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
		if( draw ) wingBowDraw();
		else wingBowImport();
		wingPolyLine( d=dPoly, pt=ptWingNose, off=[+2,+0.5] );
        wingPolyLine( d=dPoly, pt=ptQRuder, off=[+0,+0] );
        }
}

