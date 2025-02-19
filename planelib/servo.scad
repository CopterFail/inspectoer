


servo_size_1 = [25.5,12,37];  // mg90s
servo_size_2 = [33.5,12,3];

*servo_sg90($fn=50);

module servo_sg90()
{
        cube( servo_size_1, center=true );
        translate([0,0,3.5]) 
            cube( servo_size_2, center=true );
        // servoarm...
        translate([-5,6,17])
        resize([60,12,6])
        sphere( d=1 );
}
    

module ServoDiff( i=ruderseg, sx=100, sy=7, sz=348, rot=0 )
{ 
    //sx = s[i]*(tubeOffset1+tubeOffset2)/2;  // between the tubes
    //sz = (o[i+1].z-o[i].z)/2;   // in the middle of the segment
    //sz = -2;
    translate( [-sx, sy, sz])
            rotate([0,rot, 2])
                servo_sg90();
                
    
    // kabelkanal
    *translate( o[i] + [-sx+10, +11-2-2, hz/2-13])
            rotate([0,90,4])
                cube([12,5,10]);
}

