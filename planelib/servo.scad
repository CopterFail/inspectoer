


servo_size_1 = [25.5,12,37];  // mg90s
servo_size_2 = [33.5,12,3];

*servo_sg90($fn=50);
*ServoDiff();

module servo_sg90_arm( center=[0-5,0+1.5,3.5+3.5+12-2], rot=55 ) // mod during HR work: arm is not x centered in servo -5mm, arm touch cutout z-2, cutout too deep y+1.5, default rot 65->55
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
        translate([0, 0, 3.5]) 
            cube( servo_size_2 + [0,yadd,0], center=true );
		servo_sg90_arm( );
}


module ServoDiff( pos=[-100, 7, 348], rot=[0,0,0], yadd=0 )
{ 
    translate( pos)
            rotate(rot)
                servo_sg90( yadd );
}

