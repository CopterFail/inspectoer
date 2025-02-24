// 3 pin dupont for tube connect

$fn=50;

dupont3Pin();

module dupont3Pin()
{
    dp = 2.6+0.2;
    hp = 14;
    m = 1/5;
    difference(){
    cylinder(d=8, h=14 );
    union(){
        translate([-dp*m,-dp,0])         cube( [dp, 2*dp, 14] );
        translate([-dp*(m+1),-dp/2,0])   cube( [dp, dp, 14] );    
        }
    }
}