use <soften/hole.scad>
include <constants/all.scad>

heatset_hole_top_diameters = [[2, 3.6], [2.5, 4.2], [3, 5.3], [5, 8], [0.25*inch,0.363*inch]];
heatset_hole_bottom_diameters = [[2, 3.1], [2.5, 3.9], [3, 5.1], [5, 7.7], [0.25*inch,0.349*inch]];

heatset_hole_depths = [[2, 2.9], [2.5, 3.4], [3, 3.8], [5, 6.7], [0.25*inch, 0.3*inch]];

// returns the diameter
function heatset_hole_diameter(size) = [
    lookup(size, heatset_hole_top_diameters),
    lookup(size, heatset_hole_bottom_diameters)
  ];

function heatset_hole_depth(size) = lookup(size, heatset_hole_depths);
function heatset_hole_clearance_diameter(size) = size + 0.5;

module heatset_insert_hole(size) {
  h = heatset_hole_depth(size);
  d = heatset_hole_diameter(size);

  stretch_length=0.15; // how much free space in bottom of hole to make
  hole(h=h*(1+stretch_length),
       d1=d[0],
       d2=d[1]+(d[0]-d[1])*stretch_length,
       top_chamfer=d[0]*0.1);
}
//heatset_insert_hole(0.25*inch);
