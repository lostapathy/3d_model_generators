include <soften/hole.scad>

heatset_hole_top_diameters = [[2, 3.6], [2.5, 4.2], [3, 5.3], [5, 8]];
heatset_hole_bottom_diameters = [[2, 3.1], [2.5, 3.9], [3, 5.1], [5, 7.7]];

heatset_hole_depths = [[2, 2.9], [2.5, 3.4], [3, 3.8], [5, 6.7]];

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

  hole(h=h, d1=d[0], d2=d[1], top_chamfer=0.25);
}
//heatset_insert_hole(4);
