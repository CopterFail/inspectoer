// profiles2.scad, a collection of ideas that were still not used..

// SD6060-104-88 Airfoil Coordinates, source: https://m-selig.ae.illinois.edu/ads/coord/sd6060.dat
sd6060_coords = [
    [1.00000, 0.0],
    [0.99661, 0.00023],
    [0.98660, 0.00108],
    [0.97033, 0.00283],
    [0.94829, 0.00559],
    [0.92100, 0.00941],
    [0.88905, 0.01419],
    [0.85301, 0.01977],
    [0.81346, 0.02595],
    [0.77096, 0.03248],
    [0.72602, 0.03912],
    [0.67917, 0.04563],
    [0.63091, 0.05177],
    [0.58174, 0.05738],
    [0.53222, 0.06225],
    [0.48283, 0.06606],
    [0.43386, 0.06866],
    [0.38566, 0.07003],
    [0.33862, 0.07020],
    [0.29316, 0.06922],
    [0.24976, 0.06715],
    [0.20883, 0.06402],
    [0.17076, 0.05988],
    [0.13589, 0.05480],
    [0.10456, 0.04887],
    [0.07700, 0.04218],
    [0.05344, 0.03486],
    [0.03399, 0.02710],
    [0.01879, 0.01913],
    [0.00790, 0.01132],
    [0.00148, 0.00411],
    [0.00025, -0.00159], 
    [0.00495, -0.00647],
    [0.01525, -0.01148],
    [0.03068, -0.01612],
    [0.05114, -0.02025],
    [0.07648, -0.02381],
    [0.10645, -0.02678],
    [0.14078, -0.02919],
    [0.17909, -0.03105],
    [0.22096, -0.03238],
    [0.26592, -0.03321],
    [0.31347, -0.03354],
    [0.36306, -0.03338],
    [0.41413, -0.03273],
    [0.46614, -0.03159],
    [0.51852, -0.02995],
    [0.57073, -0.02784],
    [0.62223, -0.02527], 
    [0.67254, -0.02231],
    [0.72116, -0.01906],
    [0.76761, -0.01568],
    [0.81133, -0.01236],
    [0.85176, -0.00922],
    [0.88838, -0.00638],
    [0.92070, -0.00399],
    [0.94818, -0.00214],
    [0.97032, -0.00090],
    [0.98661, -0.00024],
    [0.99662, -0.00002],
    [1.00000, -0.00000]
];


function positive(a) = [for (i = a ) if( i.y >= 0 )i ];     
function negative(a) = [for (i = a ) if( i.y < 0 )i ];
function p(x,c=sd6060_coords) = lookup( x, positive(c) );
function n(x,c=sd6060_coords) = lookup( x, negative(c) );
function h(x,c=sd6060_coords) = p(x,c) - n(x,c);
function find_xmin( xmin=1, hmin, c=sd6060_coords ) = ( h( xmin, c ) > hmin ) ? xmin : find_xmin( xmin-0.001, hmin, c ); 
function find_nose( c=sd6060_coords ) = negative(c)[0]; // find the nose of the airfoil, this could also be the last negative, ToDo: use a real search
  
// cut the SD6060 at hmin and rescale to the original size:
hmin = 0.8 / 170; // 2 layer, 170mm 
xmin = find_xmin( 1, hmin, sd6060_coords );
*echo(  h(xmin, sd6060_coords), xmin, p(xmin, sd6060_coords), n(xmin, sd6060_coords) );

pSD6060 = (1/xmin) * [ [xmin,p(xmin, sd6060_coords)], for (pt=sd6060_coords) if (pt.x<xmin) pt, [xmin,n(xmin, sd6060_coords)] ];
*echo( pSD6060 );

// 2D polygon compared to the original:
*polygon(points = 170 * pSD6060);	// new polygon
*translate([0,0,10]) polygon(points = 170 * sd6060_coords); // original polygon