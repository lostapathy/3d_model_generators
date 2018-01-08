use <heatset_insert.scad>
use <helper_disk.scad>

function _box_hole_inset(face_screw_size, wall) =
  heatset_hole_diameter(face_screw_size)/2 + 1.5 * wall;

module project_box(size, wall=1.5, face_screw_size=false, helper_disks=false) {
  box_height = size[2];

  difference() {
    cube(size);
    translate([wall, wall ,wall])
      cube(size - [wall*2, wall*2, 0]);
  }

  if(face_screw_size) {
    _project_box_face_hole_post(size, wall, face_screw_size); // bottom left
    translate([0, size[1], 0]) mirror([0,1,0]) _project_box_face_hole_post(size, wall, face_screw_size); // top left
    translate([size[0], 0, 0]) mirror([1,0,0]) _project_box_face_hole_post(size, wall, face_screw_size); // bottom_right
    translate([size[0], size[1], 0]) mirror([1,1,0]) _project_box_face_hole_post(size, wall, face_screw_size); // top right
  }
  if(helper_disks) {
    helper_disks_for_rectangle(size, center=false);
  }
}

module project_box_face(size, thickness = 2.5, wall=1.5, face_screw_size=false, draft=false, helper_disks = false) {
  face_hole_d = heatset_hole_clearance_diameter(face_screw_size);
  inset = _box_hole_inset(face_screw_size, wall); //inset_hole_d/2+0.75*wall+0.4;
echo ("inset is: ", inset);

  difference() {
    cube([size[0], size[1], wall]);

    if(face_screw_size) {
      $fn =  draft? 5 : 20;
      translate([inset, inset, -1]) cylinder(d=face_hole_d, h=wall+2); // bottom left
      translate([inset, size[1]-inset, -1]) mirror([0,1,0]) cylinder(d=face_hole_d, h=wall+2); // top left
      translate([size[0] - inset, inset, -1]) mirror([1,0,0]) cylinder(d=face_hole_d, h=wall+2); // bottom_right
      translate([size[0] - inset, size[1] - inset, -1]) mirror([1,1,0]) cylinder(d=face_hole_d, h=wall+2); // top right
    }
  }
  if(helper_disks) {
    helper_disks_for_rectangle(size, center=false);
  }
}

module _project_box_face_hole_post(size, wall, screw_size) {
  _fudge_hole_size = 0.35;
  inset_hole_diameter = heatset_hole_diameter(screw_size) + _fudge_hole_size;
  inset_hole_depth = heatset_hole_depth(screw_size) + 0.5;
  inset = _box_hole_inset(screw_size, wall);
  box_height = size[2];

  difference() {
    union() {
      translate([inset,inset,0])
        cylinder(d=inset_hole_diameter+2*wall, h=box_height, $fn=50);
      cube([inset+inset_hole_diameter/2+wall, inset, box_height]);
      cube([inset, inset+inset_hole_diameter/2+wall, box_height]);
    }
    translate([inset, inset,box_height-inset_hole_depth])
      cylinder(d=inset_hole_diameter,h=inset_hole_depth+1, $fn=20);
  }
}

//project_box([100,50,50], face_screw_size=5, helper_disks=true);
//translate([0,0,46]) project_box_face([100,50], face_screw_size=5, wall=1.5);
