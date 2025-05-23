// Ruder new version, test with small cut, printable?

*cutterObjectAll( ptStart=[0,0,0], dStart=20, ptStop=[-20,0,100], dStop=10, dSpace=1.0, rot=45, steps=5, inverse=false );
*cutterMask( ptStart=[0,0,0], dStart=20+2*1, ptStop=[-20,0,100], dStop=10+2*1 );
*cutterEnds( pt=[0,0,0], d=20+2*1, dSpace=1.0, axis=false );

function RuderGetSize( z, zStart, zStop, sStart, sStop ) = ( ( sStart + (sStop-sStart)/(zStop-zStart)*(z-zStart) ) );
function RuderGetHeight( z, zStart, zStop, sStart, sStop, hBase ) = ( RuderGetSize( z, zStart, zStop, sStart, sStop) * hBase );
function RuderGetPoint( z, zStart, zStop, sStart, sStop, ptBase ) = ( RuderGetSize( z, zStart, zStop, sStart, sStop) * ptBase );
function RuderGetXOffset( z, zStart, zStop, oStart, oStop ) = ( ( oStart + (oStop-oStart)/(zStop-zStart)*(z-zStart) ) );

module Ruder2( ptStart=[0,0,0], dStart=20, ptStop=[0,0,100], dStop=10, dSpace=1.0, rot=45, steps=5, inverse=false, horn=false )
{
    difference(){
        children();
        cutterObjectAll(  ptStart, dStart, ptStop, dStop, dSpace, rot, steps, inverse );
        cutterInnerAxis( ptStart, ptStop );
        cutterEnds( ptStart, dStart, dSpace, axis=false );
        cutterEnds( ptStop, dStop, dSpace, axis=false );
        }
        
    if( horn ) 
        RuderHorn( dbase=dStart, pos = ptStart + [0,0,dSpace/2] );
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
    ptDelta = (ptStop - ptStart) / steps; 
    dDelta = (dStop - dStart) / steps; 
    
    for( i=[0:steps-1] )
    {
        dir = inverse ? !((i%2)==0) : ((i%2)==0) ;
        cutterObjectSingle(  
            ptStart+i*ptDelta, dStart+i*dDelta, 
            ptStart+(i+1)*ptDelta, dStart+(i+1)*dDelta, 
            dSpace, dir, steps );
    }
}

module cutterObjectSingle( ptStart, dStart, ptStop, dStop, dSpace, dir=false, rot=45 )
{
    difference()
    {
        union()
        {
            cutterCylinder( ptStart, dStart+2*dSpace, ptStop, dStop+2*dSpace );
            if( dir == true )
            {
                cutterMask( ptStart, dStart+2*dSpace, ptStop, dStop+2*dSpace, dir, rot=+rot );
                cutterMask( ptStart, dStart+2*dSpace, ptStop, dStop+2*dSpace, dir, rot=-rot );
            }
            cutterSpacer( ptStart, dStart+2*dSpace, dSpace ); // find a way to not call cutterSpacer at the ends?
            cutterSpacer( ptStop, dStop+2*dSpace, dSpace ); // this partly dublicate
        }
        union()
        {
            cutterCylinder( ptStart, dStart, ptStop, dStop );
            cutterHalf( ptStart, dStart, ptStop, dStop, dir );
        }
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