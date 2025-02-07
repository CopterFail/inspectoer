


servo_size_1 = [24,20,36];  // mg90s
servo_size_2 = [32.6,20,3];

*servo_sg90($fn=50);

module servo_sg90()
{
        cube( servo_size_1, center=true );
        translate([0,0,4]) 
            cube( servo_size_2, center=true );
        // servoarm...
        translate([-10,6,(36-4)/2])
        resize([30,20,7])
        sphere( d=1 );
}
    

module ServoDiff( i=ruderseg )
{ 
    sx = s[i]*(tubeOffset1+tubeOffset2)/2;
    hz = o[i+1].z-o[i].z;
    translate( o[i] + [-sx, tubeAng, hz/2])
            rotate([0,ruderrot,4])
                servo_sg90();
                
    
    // kabelkanal
    *translate( o[i] + [-sx+10, +11-2-2, hz/2-13])
            rotate([0,90,4])
                cube([12,5,10]);
}

