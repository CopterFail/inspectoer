



module RuderAdd3() // elements to ruder
{
   p0 = [-ptRuder.x * s[ruderseg] + o[ruderseg].x, o[ruderseg].z];
   p1 = [-ptRuder.x * s[ruderseg+1] + o[ruderseg+1].x, o[ruderseg+1].z];
   p2 = [-s[ruderseg+1] + o[ruderseg+1].x, o[ruderseg+1].z];
   p3 = [-s[ruderseg] + o[ruderseg].x, o[ruderseg].z];
   d0 = hRuder * s[ruderseg];
   d1 = hRuder * s[ruderseg+1];

   intersection(){
       union(){
           hull(){ // drehachse
                translate([p0.x, ptRuder.y*s[ruderseg] ,p0.y])
                cylinder(d=d0,h=0.01);
               translate([p1.x, ptRuder.y*s[ruderseg+1] ,p1.y])
                cylinder(d=d1,h=0.01);
                }

            // schnitt an der achse
           translate([0, 50/2, 0])
           rotate([90,0,0])
           linear_extrude(height=50)
           polygon([p0,p1,p2,p3]);
           }
       difference(){
           segment([s[ruderseg],s[ruderseg+1]], [o[ruderseg],o[ruderseg+1]], r=0);
           wingPolyLine( d=dPoly, pt=ptRuder, off=[+0,+0] );
           translate([0, 50/2, 0])
           rotate([90,0,0])
           linear_extrude(height=50)
           polygon([p1+[(d1+1)/2,-1],p1+[(d1+1)/2,0], p2, p2+[0,-1]]);
           }
       RuderDiff2Mask();
       }
}

module RuderAdd2() // add elements to sement
{
   p0 = [-ptRuder.x * s[ruderseg] + o[ruderseg].x, o[ruderseg].z];
   p1 = [-ptRuder.x * s[ruderseg+1] + o[ruderseg+1].x, o[ruderseg+1].z];
   p2 = [-s[ruderseg+1] + o[ruderseg+1].x, o[ruderseg+1].z];
   p3 = [-s[ruderseg] + o[ruderseg].x, o[ruderseg].z];
   p4 = [+ o[ruderseg+1].x, o[ruderseg+1].z];
   p5 = [+ o[ruderseg].x, o[ruderseg].z];
   d0 = hRuder * s[ruderseg];
   d1 = hRuder * s[ruderseg+1];

   intersection(){
       union(){
           hull(){ // drehachse
                translate([p0.x, ptRuder.y*s[ruderseg] ,p0.y])
                cylinder(d=d0,h=0.01);
               translate([p1.x, ptRuder.y*s[ruderseg+1] ,p1.y])
                cylinder(d=d1,h=0.01);
                }

            // schnitt an der achse
           translate([0, 50/2, 0])
           rotate([90,0,0])
           linear_extrude(height=50)
           polygon([p0,p1,p4,p5]);
           }
       difference(){
           segment([s[ruderseg],s[ruderseg+1]], [o[ruderseg],o[ruderseg+1]], r=0);
           wingPolyLine( d=dPoly, pt=ptRuder, off=[+0,+0] );
           translate([0, 50/2, 0])
           rotate([90,0,0])
           linear_extrude(height=50)
           *polygon([p1+[(d1+1)/2,-1],p1+[(d1+1)/2,0], p2, p2+[0,-1]]);
           }
       RuderDiff2MaskInv();
       }
}

module RuderCut2() // cut the ruder from segmen
{
   p0 = [-ptRuder.x * s[ruderseg] + o[ruderseg].x, o[ruderseg].z];
   p1 = [-ptRuder.x * s[ruderseg+1] + o[ruderseg+1].x, o[ruderseg+1].z];
   p2 = [-s[ruderseg+1] + o[ruderseg+1].x, o[ruderseg+1].z];
   p3 = [-s[ruderseg] + o[ruderseg].x, o[ruderseg].z];
   d0 = hRuder * s[ruderseg];
   d1 = hRuder * s[ruderseg+1];

    // schnitt an der achse
   translate([0, 50/2, 0])
    rotate([90,0,0])
     linear_extrude(height=50)
      polygon([p0,p1,p2,p3]);
   RuderDiff2Axis( rot = 400, doff=-0.5 );
}

module RuderCut3() // cut the segment from the ruder
{
   p0 = [-ptRuder.x * s[ruderseg] + o[ruderseg].x, o[ruderseg].z];
   p1 = [-ptRuder.x * s[ruderseg+1] + o[ruderseg+1].x, o[ruderseg+1].z];
   p2 = [-s[ruderseg+1] + o[ruderseg+1].x, o[ruderseg+1].z];
   p3 = [-s[ruderseg] + o[ruderseg].x, o[ruderseg].z];
   p4 = [+ o[ruderseg+1].x, o[ruderseg+1].z];
   p5 = [+ o[ruderseg].x, o[ruderseg].z];
   d0 = hRuder * s[ruderseg];
   d1 = hRuder * s[ruderseg+1];

    // schnitt an der achse
   translate([0, 50/2, 0])
    rotate([90,0,0])
     linear_extrude(height=50)
      polygon([p0,p1,p4,p5]);
   RuderDiff2Axis( rot = 400, doff=-0.5 );
}

module RuderDiff2( doff = 0.5 ) // cut element from segment
{
   intersection(){
        RuderDiff2Axis( rot = 0, doff=0 );
        RuderDiff2Mask( doff=0 );
        }
   RuderDiff2Axis( rot = 0, doff = -doff );
}

module RuderDiff3( doff = 0.5 ) // cut elements from ruder
{
    difference(){
        RuderDiff2Axis( rot = 180, doff=0 );
        RuderDiff2Mask( doff = +doff );
        }
    RuderDiff2Axis( rot = 180, doff = -doff );
    translate([-s[ruderseg],-50,0]+o[ruderseg]) cube( [100,100,doff], center=false );
    translate([-s[ruderseg+1],-50,-doff]+o[ruderseg+1]) cube( [100,100,doff], center=false );
    
   
}


module RuderDiff2Mask( doff = 0.5 )
{   //todo: this has to depend on o,s...
    translate([-150,0,50]+o[ruderseg]) cube( [100,50,50-doff], center=true );
    translate([-150,0,150]+o[ruderseg]) cube( [100,50,50-doff], center=true );
}
module RuderDiff2MaskInv( doff = 0.5 )
{   //todo: this has to depend on o,s...
    translate([-170,0,0]+o[ruderseg]) cube( [100,50,50-doff], center=true );
    translate([-160,0,100]+o[ruderseg]) cube( [100,50,50-doff], center=true );
    translate([-150,0,200]+o[ruderseg]) cube( [100,50,50-doff], center=true );
}

// axis with rotation limits used as mask
module RuderDiff2Axis( rot=0, doff=0 )
{
   p0 = [-ptRuder.x * s[ruderseg] + o[ruderseg].x, o[ruderseg].z];
   p1 = [-ptRuder.x * s[ruderseg+1] + o[ruderseg+1].x, o[ruderseg+1].z];
   d0 = hRuder * s[ruderseg] - doff;
   d1 = hRuder * s[ruderseg+1] - doff;
   w = 40; // max ruder angle

   
  hull(){ 
    translate([p0.x, ptRuder.y*s[ruderseg] ,p0.y]) {
        cylinder( d=d0, h=0.01, center=false );
        if( rot < 360 ){
            rotate([0,0,rot+w]) translate([-2*d0,-d0/2,0]) cube([2*d0, d0, 0.01], center=false );
            rotate([0,0,rot-w]) translate([-2*d0,-d0/2,0]) cube([2*d0, d0, 0.01], center=false );
            }
        }
    translate([p1.x, ptRuder.y*s[ruderseg+1] ,p1.y]) {
        cylinder( d=d1, h=0.01, center=false );
        if( rot < 360 ){
            rotate([0,0,rot+w]) translate([-2*d1,-d1/2,0]) cube([2*d1, d1, 0.01], center=false );
            rotate([0,0,rot-w]) translate([-2*d1,-d1/2,0]) cube([2*d1, d1, 0.01], center=false );
            }
        }
    }
}

module RuderHorn()
{

    p0 = [-ptRuder.x * s[ruderseg] + o[ruderseg].x, o[ruderseg].z];
    p1 = [-ptRuder.x * s[ruderseg+1] + o[ruderseg+1].x, o[ruderseg+1].z];
    pm = (p0 + p1)/2;
    sm = (s[ruderseg]+s[ruderseg+1])/2;

    translate([pm.x,ptRuder.y*sm ,pm.y + 24 ])
    rotate([0,ruderrot, 2])
    difference()
    {
        hull()
        {
            translate([-5,2,0]) cylinder(d=2,h=4);
            translate([2,12,0]) cylinder(d=6,h=2);
            translate([-20,0,0]) cylinder(d=2,h=4);
        }
        translate([2,12,0]) cylinder(d=1.5,h=2);
   }
}


