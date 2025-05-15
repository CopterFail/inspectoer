// Ruder new version, test with small cut, printable? no very nice, so try a 3rd version

//Ruder3() is called in inspector.scad

*cutterObjectAll( ptStart=[0,0,0], dStart=20, ptStop=[-20,0,100], dStop=10, dSpace=1.0, rot=45, steps=3, inverse=false );
*cutterObjectSingle( ptStart=[0,0,0], dStart=20, ptStop=[-20,0,100], dStop=10, dSpace=1.0, dir=false, rot=45 );
*cutterMask( ptStart=[0,0,0], dStart=20+2*1, ptStop=[-20,0,100], dStop=10+2*1 );
*cutterEnds( pt=[0,0,0], d=20+2*1, dSpace=1.0, axis=false );

function RuderGetSize( z, zStart, zStop, sStart, sStop ) = ( ( sStart + (sStop-sStart)/(zStop-zStart)*(z-zStart) ) );
function RuderGetHeight( z, zStart, zStop, sStart, sStop, hBase ) = ( RuderGetSize( z, zStart, zStop, sStart, sStop) * hBase );
function RuderGetPoint( z, zStart, zStop, sStart, sStop, ptBase ) = ( RuderGetSize( z, zStart, zStop, sStart, sStop) * ptBase );
function RuderGetXOffset( z, zStart, zStop, oStart, oStop ) = ( ( oStart + (oStop-oStart)/(zStop-zStart)*(z-zStart) ) );

module Ruder3( ptStart=[0,0,0], dStart=20, ptStop=[0,0,100], dStop=10, dSpace=1.0, rot=22, steps=5, inverse=false, horn=false )
{
	vGap = (ptStop - ptStart) / norm(ptStop - ptStart) * 0.25;

	// wing part
	difference() {
		children();
		RuderMask(ptStart = ptStart, dStart = dStart, ptStop = ptStop, dStop = dStop, dSpace = dSpace, rot=-rot, dir=-1 );
		
		*cutterCylinder( ptStart, dStart+2*dSpace, ptStop, dStop+2*dSpace );
		cutterObjectAll(  ptStart, dStart, ptStop, dStop, dSpace, rot, steps, inverse );
		cutterInnerAxis( ptStart, ptStop );
        *cutterEnds( ptStart, dStart, dSpace, axis=false );
        *cutterEnds( ptStop, dStop, dSpace, axis=false );
        }
		adderObjectAll(  ptStart, dStart, ptStop, dStop, dSpace, rot, steps, !inverse ); // too long
	

	// ruder part
	translate( [0,0,0]){
		difference(){
			intersection() {
					children();
					RuderMask( ptStart = ptStart+vGap, dStart = dStart, ptStop = ptStop-vGap, dStop = dStop, dSpace = dSpace, rot=rot, dir=1 );
					}
			cutterObjectAll(  ptStart, dStart, ptStop, dStop, dSpace, rot, steps, !inverse );
			cutterInnerAxis( ptStart, ptStop );
					//cutterCylinder( ptStart, dStart+0*dSpace, ptStop, dStop+0*dSpace );
					//cutterObjectAll
			}
		difference(){	
			adderObjectAll(  ptStart, dStart, ptStop, dStop, dSpace, rot, steps, inverse ); // too long
			cutterInnerAxis( ptStart, ptStop );
			}
	}

	if( horn ) 
        RuderHorn( dbase=dStart, pos = ptStart + [0,0,dSpace/2] );
}

module RuderMask( ptStart, dStart, ptStop, dStop, dSpace, rot=45, dir=1 )
{
	function pMask(r) = [[0,0], [-100*sin(r),-100*cos(r)], [-400,-50], [-400,0], [0,0]];

	union(){
	hull()
	{
		translate( ptStart ) 
			linear_extrude(height=0.001 ) polygon(points = pMask(rot)); 
		translate( ptStop ) 
			linear_extrude(height=0.001 ) polygon(points = pMask(rot)); 
	}
	hull() 
	{
		translate( ptStart ) 
			linear_extrude(height=0.001 ) polygon(points = pMask(180-rot)); 
		translate( ptStop ) 
			linear_extrude(height=0.001 ) polygon(points = pMask(180-rot)); 
	}
	}
}	

module RuderHornCut(dbase, daxsis=2.2, dwire=2, pos=[0,0,0], h=2, a=18, diff=0)
{
    //scale([1,1,2])
    cutterEnds( pos, d=dbase, dSpace=0.2, axis=true );
}

module RuderHorn( dbase, daxsis=2.2, dwire=2, pos=[0,0,0], h=2, a=18, diff=0 )
{
    b=a;
    translate( pos ) 
        difference(){
            union(){
                hull(){
                    translate([0,0,0])  cylinder( d=dbase-2+diff, h=h, center=false );
                    translate([-a,0,0]) cylinder( d=2+diff, h=h, center=false );
                    }
                hull(){
                    translate([-a,0,0]) cube( [10,1,h], center=false );
                    translate([0,b,0])  cylinder( d=6+diff, h=h, center=false );
                    }
                }
            union(){
                translate([0,0,0])  cylinder( d=daxsis, h=h, center=false );
                translate([0,b,0])  cylinder( d=dwire, h=h, center=false ); 
                //translate([-a,0,0])  cylinder( d=dwire, h=h, center=false ); 
                c = b-6/2-dbase/2; 
                *translate([-c,c,0])  cylinder( d=c, h=h, center=false ); 
            }
    }
}





module cutterObjectAll( ptStart, dStart, ptStop, dStop, dSpace, rot=45, steps=5, inverse=false )
{
    vDelta = (ptStop - ptStart) / steps; 
    dDelta = (dStop - dStart) / steps; 
	vGap = vDelta / norm(vDelta) * 0.25;
    
    for( i=[0:steps-1] )
    {
        dir = inverse ? !((i%2)==0) : ((i%2)==0) ;
		vGapA = (i==0) ? [0,0,0] : vGap;
		vGapB = (i==steps-1) ? [0,0,0] : vGap;
        cutterObjectSingle(  
            ptStart+i*vDelta+vGapA, dStart+i*dDelta, 
            ptStart+(i+1)*vDelta-vGapB, dStart+(i+1)*dDelta, 
            dSpace, dir, steps );
    }
}
module adderObjectAll( ptStart, dStart, ptStop, dStop, dSpace, rot=45, steps=5, inverse=false )
{
    vDelta = (ptStop - ptStart) / steps; 
    dDelta = (dStop - dStart) / steps; 
	vGap = vDelta / norm(vDelta) * 0.25;
	
    
    for( i=[0:steps-1] )
    {
        dir = inverse ? !((i%2)==0) : ((i%2)==0) ;
		vGapA = (i==0) ? [0,0,0] : vGap;
		vGapB = (i==steps-1) ? [0,0,0] : vGap;
        cutterObjectSingle(  
            ptStart+i*vDelta+vGapA, dStart+i*dDelta, 
            ptStart+(i+1)*vDelta-vGapB, dStart+(i+1)*dDelta, 
            dSpace=0, dir, steps );
    }
}

module cutterObjectSingle( ptStart, dStart, ptStop, dStop, dSpace, dir=false, rot=45 )
{
	if( dir == true )
	{
		// Ausschnitt
		cutterCylinder( ptStart, dStart+2*dSpace, ptStop, dStop+2*dSpace );
	}
}

module cutterCylinder( ptStart, dStart, ptStop, dStop )
{
    hull()
    {
        translate( ptStart ) cylinder( d=dStart, h=0.001, center=true );
        translate( ptStop )  cylinder( d=dStop, h=0.001, center=true  );
    }
}

module cutterMask( ptStart, dStart, ptStop, dStop, dir=true, rot=40 )
{
    oxStart = dir ? 0 : -dStart;
    oxStop = dir ? 0 : -dStop;
    
    hull(){
        translate( ptStart ) 
            rotate( [0,0,rot] )
                translate( [oxStart,-dStart/2,0] )
                    cube([dStart/2,dStart, 0.001], center=false );
        translate( ptStop ) 
            rotate( [0,0,rot] )
                translate( [oxStop,-dStop/2,0] )
                    cube([dStop/2,dStop, 0.001], center=false );
        }
}

module cutterHalf( ptStart, dStart, ptStop, dStop, dir=true )
{
    oxStart = dir ? 0 : -dStart;
    oxStop = dir ? 0 : -dStop;
    hull(){
        translate( ptStart ) 
                translate( [oxStart,-dStart,0] )
                    cube([dStart,2*dStart, 0.001], center=false );
        translate( ptStop ) 
                translate( [oxStop,-dStop,0] )
                    cube([dStop,2*dStop, 0.001], center=false );
        }
}

module cutterSpacer( ptStart, dStart, dSpace )
{
    translate( ptStart )
        cylinder( d=dStart, h=dSpace, center=true );
}

module cutterInnerAxis( ptStart, ptStop, dAxis=2.2 )    // set the correct parameter dAxis
{
    hull()
    {
        translate( ptStart ) sphere( d=dAxis );
        translate( ptStop ) sphere( d=dAxis );
    }
}

module cutterEnds( pt, d, dSpace, axis=false )
{
    translate( pt ) 
        difference()
        {
            union()
            {
                cylinder( d=d+2*dSpace, h=dSpace, center=true );
                translate( [-100,-20,-dSpace/2] ) cube( [100,40,dSpace], center=false );
            }
            if ( axis==false ) cylinder( d=d+2*dSpace, h=dSpace, center=true );
        }
}