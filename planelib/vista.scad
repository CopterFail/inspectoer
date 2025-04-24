
//$fn=50;
//fpvPlate();

fpvAntPos = [16,0,20]; //[21,0,12];
fpvPlateHeight = 4;
fpvDi=2.1;

module fpvPlate()
{
    translate([260,-30,0])
    rotate([0,90,15])
    {
        translate([0,fpvPlateHeight,0]) rotate([-90,0,0]) fpvTubes(da=8,di=fpvDi,h=5);
        translate(fpvAntPos+[0,fpvPlateHeight,0]) rotate([-90,90,0]) fpvAntenna(h1=16);
        fpvBase();
    }
}

module fpvBase()
{
    a = 26/2-2;
    difference(){
        hull(){
            for( x=[-a,+a], y=[-a,+a] ){ 
                translate([x,0,y]) 
                    rotate([-90,0,0])
                        cylinder(d=8, h=fpvPlateHeight );
                }
            translate(fpvAntPos) rotate([-90,90,0]) cylinder(d=8, h=fpvPlateHeight );
            }
        for( x=[-10,10], y=[-10,10] ){
            translate([x,-1,y])
                rotate([-90,0,0])
                    cylinder(d=fpvDi,h=fpvPlateHeight+2);
            }
         }
}

module fpvTubes(a=20, da=6, di=3.5, h=10 )
{
    px = [-a/2,+a/2];
    py = px;
    for( x=px, y=py ){
        translate([x,y,0])
            difference(){
                cylinder(d=da,h=h);
                cylinder(d=di,h=h+2);
        }
    }
}

module fpvAntenna(h1=16)
{
    difference(){
        union(){
            hull(){
            *translate([-7,0,0]) cylinder(d=1, h=5 );  
            translate([ 0,0,0]) cylinder(d=8, h=h1+10 );
            }
        }
        translate([0,0,0]) cylinder(d=4.25, h=h1+10 );
        translate([0,2,0]) cube([2,8,2.5*(h1+10)],center=true);   
    }
}

