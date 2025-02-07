

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


module RuderAdd2()
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
       }
}

module RuderDiff2()
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
