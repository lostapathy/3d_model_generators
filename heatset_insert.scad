heatset_hole_diameters = [[3, 5.3], [5, 7.7]];

heatset_hole_depths = [[3, 3.8], [5, 6.7]];

// returns the diameter
function heatset_hole_diameter(size) = lookup(size, heatset_hole_diameters);
function heatset_hole_depth(size) = lookup(size, heatset_hole_depths);
function heatset_hole_clearance_diameter(size) = size + 0.5;
