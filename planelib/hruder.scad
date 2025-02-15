
// simplified version of qruder
zBoom = 130+13;
ho = zBoom-6; // xy offset is zero, z is -zBoom to zBoom
hs = 120; // size = factor is const for hruder 

module HRuderAdd3() // elements to ruder
{
   p0 = [-ptHRuder.x * hs, -ho];
   p1 = [-ptHRuder.x * hs, +ho];
   p2 = [-hs, +ho];
   p3 = [-hs, -ho];
   p4 = [0, +ho];
   p5 = [0, -ho];
   d0 = hHRuder * hs;

   intersection(){
       union(){
           hull(){ // drehachse
                translate([p0.x, ptHRuder.y*hs ,p0.y])
                cylinder(d=d0,h=0.01);
               translate([p1.x, ptHRuder.y*hs ,p1.y])
                cylinder(d=d0,h=0.01);
                }

            // schnitt an der achse
           translate([0, 50/2, 0])
           rotate([90,0,0])
           linear_extrude(height=50)
           polygon([p0,p1,p2,p3]);
           }
       difference(){
           heigtSolid(r=0);
           hull(){ 
            translate([-ptHRuder.x*hs, ptHRuder.y*hs, -ho-dPoly]) sphere(d=dPoly); 
            translate([-ptHRuder.x*hs, ptHRuder.y*hs, +ho+dPoly]) sphere(d=dPoly); 
            }
           translate([0, 50/2, 0])
           rotate([90,0,0])
           linear_extrude(height=50)
           polygon([p1+[(d0+1)/2,-1],p1+[(d0+1)/2,0], p2, p2+[0,-1]]);
           }
       HRuderDiff2Mask();
       }
}

module HRuderAdd2() // add elements to sement
{
   p0 = [-ptHRuder.x * hs, -ho];
   p1 = [-ptHRuder.x * hs, +ho];
   p2 = [-hs, +ho];
   p3 = [-hs, -ho];
   p4 = [0, +ho];
   p5 = [0, -ho];
   d0 = hHRuder * hs;

   intersection(){
       union(){
           hull(){ // drehachse
                translate([p0.x, ptHRuder.y*hs ,p0.y])
                cylinder(d=d0,h=0.01);
               translate([p1.x, ptHRuder.y*hs ,p1.y])
                cylinder(d=d0,h=0.01);
                }

            // schnitt an der achse
           translate([0, 50/2, 0])
           rotate([90,0,0])
           linear_extrude(height=50)
           polygon([p0,p1,p4,p5]);
           }
       difference(){
           heigtSolid(r=0);
           hull(){ 
            translate([-ptHRuder.x*hs, ptHRuder.y*hs, -ho-dPoly]) sphere(d=dPoly); 
            translate([-ptHRuder.x*hs, ptHRuder.y*hs, +ho+dPoly]) sphere(d=dPoly); 
            }

           translate([0, 50/2, 0])
           rotate([90,0,0])
           linear_extrude(height=50)
           *polygon([p1+[(d0+1)/2,-1],p1+[(d0+1)/2,0], p2, p2+[0,-1]]);
           }
       HRuderDiff2MaskInv();
       }
}

module HRuderCut2() // cut the ruder from segmen
{
   p0 = [-ptHRuder.x * hs, -ho];
   p1 = [-ptHRuder.x * hs, +ho];
   p2 = [-hs, +ho];
   p3 = [-hs, -ho];
   p4 = [0, +ho];
   p5 = [0, -ho];
   d0 = hHRuder * hs;

    // schnitt an der achse
   translate([0, 50/2, 0])
    rotate([90,0,0])
     linear_extrude(height=50)
      polygon([p0,p1,p2,p3]);
   HRuderDiff2Axis( rot = 400, doff=-0.5 );
}

module HRuderCut3() // cut the segment from the ruder
{
   p0 = [-ptHRuder.x * hs, -ho];
   p1 = [-ptHRuder.x * hs, +ho];
   p2 = [-hs, +ho];
   p3 = [-hs, -ho];
   p4 = [0, +ho];
   p5 = [0, -ho];
   d0 = hHRuder * hs;

    // schnitt an der achse
   translate([0, 50/2, 0])
    rotate([90,0,0])
     linear_extrude(height=50)
      polygon([p0,p1,p4,p5]);
   HRuderDiff2Axis( rot = 400, doff=-0.5 );
}

module HRuderDiff2( doff = 0.5 ) // cut element from segment
{
   intersection(){
        HRuderDiff2Axis( rot = 0, doff=0 );
        HRuderDiff2Mask( doff=0 );
        }
   HRuderDiff2Axis( rot = 0, doff = -doff );
}

module HRuderDiff3( doff = 0.5 ) // cut elements from ruder
{
    difference(){
        HRuderDiff2Axis( rot = 180, doff=0 );
        HRuderDiff2Mask( doff = +doff );
        }
    HRuderDiff2Axis( rot = 180, doff = -doff );
    translate([-hs,-50,-ho]) cube( [100,100,doff], center=false );
    translate([-hs,-50,+ho-doff]) cube( [100,100,doff], center=false );
    
   
}


module HRuderDiff2Mask( doff = 0.5 )
{ 
    s = (ho*2)/5;
    translate([-70,0,-s]) cube( [100,50,s-doff], center=true );
    translate([-70,0,+s]) cube( [100,50,s-doff], center=true );
}
module HRuderDiff2MaskInv( doff = 0.5 )
{   
    s = (ho*2)/5;
    translate([-70,0,0])      cube( [100,50,s-doff], center=true );
    translate([-70,0,-2*s]) cube( [100,50,s-doff], center=true );
    translate([-70,0,+2*s]) cube( [100,50,s-doff], center=true );
}

// axis with rotation limits used as mask
module HRuderDiff2Axis( rot=0, doff=0 )
{
   p0 = [-ptHRuder.x * hs, -ho];
   p1 = [-ptHRuder.x * hs, +ho];
   d0 = hHRuder * hs;
   w = 40; // max ruder angle

   
  hull(){ 
    translate([p0.x, ptHRuder.y*hs ,p0.y]) {
        cylinder( d=d0, h=0.01, center=false );
        if( rot < 360 ){
            rotate([0,0,rot+w]) translate([-2*d0,-d0/2,0]) cube([2*d0, d0, 0.01], center=false );
            rotate([0,0,rot-w]) translate([-2*d0,-d0/2,0]) cube([2*d0, d0, 0.01], center=false );
            }
        }
    translate([p1.x, ptHRuder.y*hs ,p1.y]) {
        cylinder( d=d0, h=0.01, center=false );
        if( rot < 360 ){
            rotate([0,0,rot+w]) translate([-2*d0,-d0/2,0]) cube([2*d0, d0, 0.01], center=false );
            rotate([0,0,rot-w]) translate([-2*d0,-d0/2,0]) cube([2*d0, d0, 0.01], center=false );
            }
        }
    }
}

module HRuderHorn()
{

    p0 = [-ptHRuder.x * hs, -ho];
    p1 = [-ptHRuder.x * hs, +ho];
    pm = (p0 + p1)/2;
    sm = (hs+hs)/2;

    translate([pm.x,ptHRuder.y*sm ,pm.y + 15 ])
    difference()
    {
        hull()
        {
            translate([-5,2,0]) cylinder(d=2,h=4);
            translate([0,12,0]) cylinder(d=6,h=2);
            translate([-20,0,0]) cylinder(d=2,h=4);
        }
        translate([0,12,0]) cylinder(d=1.5,h=10,center=true);
   }
}


