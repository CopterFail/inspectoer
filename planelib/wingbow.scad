*wingBow();
*color("Blue")wingBow2();


module wingBow()
{
    difference(){
        //translate( o[3] + [ 0, -5.6, 24.85 ] )
        translate( [ 0.4, 0, -0.6 ] )
            rotate([0,-90,0])
                mirror([1,0,0])
                    scale( 110/133 + 0.02 )
                        import("Randbogen.stl");
        wingPolyLine( d=dPoly, pt=pSD6060[iSD6060_Nose], off=[+2,+0.5] );
        wingPolyLine( d=dPoly, pt=ptQRuder, off=[+0,+0] );
        }
}

module wingBow2()
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
