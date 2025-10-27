
include <../planelib/inspectoer.scad>


cp=[0,0,-380+50];

difference(){
	yrot(90) fuseSegment([3]);
	translate(cp) cube(100, center=true);
}

left(80)
yrot(180, cp=cp+[0,0,50])
intersection(){
	yrot(90) fuseSegment([3]);
	translate(cp) cube(100, center=true);
}