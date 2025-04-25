


servo_size_1 = [25.5,12,37];  // mg90s
servo_size_2 = [33.5,12,3];

*servo_sg90($fn=50);
*ServoDiff();

module servo_sg90_arm( center=[0,0,3.5+3.5+12], rot=65 )
{
	l=20+2;
	a=7;
	translate(v = center)
	{ 
		hull()
		for( r=[-rot:5:+rot])
		{
			rotate( [0,0,r+180])
			translate([0,a/2-l/2,0])
				cube( [a,l,a], center=true );
		}
	}
}
    

module servo_sg90( yadd=0 )
{
        cube( servo_size_1 + [0,yadd,0], center=true );
        translate([0,0,3.5]) 
            cube( servo_size_2 + [0,yadd,0], center=true );
		servo_sg90_arm( );
}


module ServoDiff( sx=100, sy=7, sz=348, rot=0, yadd=0 )
{ 
    //sx = s[i]*(tubeOffset1+tubeOffset2)/2;  // between the tubes
    //sz = (o[i+1].z-o[i].z)/2;   // in the middle of the segment
    //sz = -2;
    translate( [-sx, sy, sz])
            rotate([0,rot, 0])
                servo_sg90( yadd );
                
    
    // kabelkanal
    *translate( o[i] + [-sx+10, +11-2-2, hz/2-13])
            rotate([0,90,4])
                cube([12,5,10]);
}

