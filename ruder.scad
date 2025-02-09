

module RuderDiff(i=ruderseg, size = 45, d=0.3 )
{
 // dreicksleiste, cut ruder, 3mm hole   
    db = 10; // abstand vom rand
 
    module triangle( a=20,h=100 ){
        b=a/3;
        pt = [[ 0, 0], [+b,+a], [-b,+a]];
        rotate([0,ruderrot,0])
            linear_extrude( height=h, center=false ) 
                polygon( pt );
    }
    sx = s[i];
    hz = o[i+1].z-o[i].z - 2 * db;
    union(){
        translate( o[i] + [-s[i]+size + db ,0,db]) // dreiecksleiste oben
            triangle( a=20,h=hz ); // dreiecksleiste unten
        translate( o[i] + [-s[i]+size +db, 0, db])
            mirror([0,1,0]) triangle( a=20,h=hz );
            *translate( o[i] + [-s[i]+size,0,hz*1/5])
                cube([6,0.5,hz/8],center=true);   // verbinder unten
            *translate( o[i] + [-s[i]+size,0,hz*4/5])
                cube([6,0.5,hz/8],center=true);   // verbinder oben
            translate( o[i] + [-s[i]+size + db + hz*sin(ruderrot), -size/2, db + hz*cos(ruderrot) ])
                rotate([0,ruderrot+180,0])
                    cube([size+2,40,1],center=false);   // 1mm trenner oben, 
            translate( o[i] + [-s[i]+size + db , -size/2, db] )
                rotate([0,ruderrot+180,0])
                    cube([size+2,40,1],center=false);   // 1mm trenner unten, 
            translate( o[i] + [-s[i]+size + db, -size/2, db])
                rotate([0,ruderrot,0])
                    cube([0.1,40,hz],center=false);   // 0.1mm trenner gesammtes ruder
            
    }
}


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
                cylinder(d=d0,h=0.1);
               translate([p1.x, ptRuder.y*s[ruderseg+1] ,p1.y])
                cylinder(d=d1,h=0.1);
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
                cylinder(d=d0,h=0.1);
               translate([p1.x, ptRuder.y*s[ruderseg+1] ,p1.y])
                cylinder(d=d1,h=0.1);
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
           polygon([p1+[(d1+1)/2,-1],p1+[(d1+1)/2,0], p2, p2+[0,-1]]);
           }
       RuderDiff2MaskInv();
       }
}

module RuderDiffx()
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
      polygon([p0+[(d0+1)/2,0],p1+[(d1+1)/2,0],p2,p3]);
      
   *polygon([p0,p1,p2,p3]);
}

module RuderCut2() // cut the segment
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
}

module RuderCut3() // cut the ruder
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
}

module RuderDiff2() // cut element from segment
{
    intersection(){
        RuderDiff2Axis( 0 );
        RuderDiff2Mask();
        }
    
}

module RuderDiff3() // cut elements from ruder
{
    difference(){
        RuderDiff2Axis( 180 );
        RuderDiff2Mask();
        }
}


module RuderDiff2Mask()
{   //todo: this has to depend on o,s...
    translate([-150,0,50]+o[ruderseg]) cube( [100,50,50], center=true );
    translate([-150,0,150]+o[ruderseg]) cube( [100,50,50], center=true );
}
module RuderDiff2MaskInv()
{   //todo: this has to depend on o,s...
    translate([-150,0,0]+o[ruderseg]) cube( [100,50,50], center=true );
    translate([-150,0,100]+o[ruderseg]) cube( [100,50,50], center=true );
    translate([-150,0,200]+o[ruderseg]) cube( [100,50,50], center=true );
}

// axis with rotation limits used as mask
module RuderDiff2Axis( rot=0, doff=0.5 )
{
   p0 = [-ptRuder.x * s[ruderseg] + o[ruderseg].x, o[ruderseg].z];
   p1 = [-ptRuder.x * s[ruderseg+1] + o[ruderseg+1].x, o[ruderseg+1].z];
   d0 = hRuder * s[ruderseg];
   d1 = hRuder * s[ruderseg+1];
   w = 40; // max ruder angle

   
  hull(){ 
    translate([p0.x, ptRuder.y*s[ruderseg] ,p0.y]) {
        cylinder( d=d0 + doff, h=0.1, center=false );
        rotate([0,0,rot+w]) translate([-2*d0,-d0/2,0]) cube([2*d0, d0, 0.1], center=false );
        rotate([0,0,rot-w]) translate([-2*d0,-d0/2,0]) cube([2*d0, d0, 0.1], center=false );
        }
    translate([p1.x, ptRuder.y*s[ruderseg+1] ,p1.y]) {
        cylinder( d=d1 + doff, h=0.1, center=false );
        rotate([0,0,rot+w]) translate([-2*d1,-d1/2,0]) cube([2*d1, d1, 0.1], center=false );
        rotate([0,0,rot-w]) translate([-2*d1,-d1/2,0]) cube([2*d1, d1, 0.1], center=false );
        }
    }
  *RuderMountClip( x = 50 );
}






/*
module RuderMountClip( x = 50, r=0.2 )
{
    // calculate the x point between ruderseg and ruderseg+1
    sx = ( ( s[ruderseg]*(100-x) ) + ( s[ruderseg+1]*x ) ) / 100;
    ox = ((100-x)*o[ruderseg] + x * o[ruderseg+1]) / 100;
    px = [-ptRuder.x * sx + ox.x, ox.z];
    dx = hRuder * sx;
    
    *echo( sx, ox, px, dx );
    // schleift wg schraege!!!!
    difference(){
        hull(){
            translate([px.x, ptRuder.y*sx ,px.y]) {
                cylinder( d=dx + r, h=2, center=false );
                }
            translate([px.x+dx, ptRuder.y*sx ,px.y]) {
                cylinder( d=dx + r, h=2, center=false );
                }
            }
        translate([px.x, ptRuder.y*sx ,px.y]) {
                cylinder( d=dPoly + 0.0, h=2+1, center=false );
                }
        }
}
*/
