use <heatset_insert.scad>
use <helper_disk.scad>
use <layout.scad>

function _box_hole_inset(face_screw_size, wall) =
  heatset_hole_diameter(face_screw_size)/2 + 1.5 * wall;

module project_box(size, wall=1.5, face_screw_size=false, helper_disks=false, max_span=100) {
  box_height = size[2];

  difference() {
    cube(size);
    translate([wall, wall ,wall])
      cube(size - [wall*2, wall*2, 0]);
  }

  inset = _box_hole_inset(face_screw_size, wall);

  x_divisions = floor((size[0] - 2 * inset)/max_span);
  for(i = [0:x_divisions + 1]) {
    offset = inset + (size[0] - 2*inset)/(x_divisions + 1.0)*i;
    translate([offset, 0, 0])
      _project_box_post(size[2], wall, face_screw_size);

    translate([offset, size[1], 0])
      mirror([0,1,0])
        _project_box_post(size[2], wall, face_screw_size);
  }

  y_divisions = floor((size[1] - 2 * inset)/max_span);
  for(i = [0:y_divisions + 1]) {
    offset = inset + (size[1] - 2*inset)/(y_divisions + 1.0)*i;
    translate([0, offset, 0])
      rotate([0,0,-90]) _project_box_post(size[2], wall, face_screw_size);

    translate([size[0], offset, 0])
      mirror([1,0,0])
        rotate([0,0,-90]) _project_box_post(size[2], wall, face_screw_size);
  }

  if(helper_disks) {
    helper_disks_for_rectangle(size, center=false);
  }
}

module _project_box_post(height, wall, screw_size) {
  _fudge_hole_size = 0.35;
  inset_hole_diameter = heatset_hole_diameter(screw_size) + _fudge_hole_size;
  inset_hole_depth = heatset_hole_depth(screw_size) + 0.5;
  inset = _box_hole_inset(screw_size, wall);
  box_height = height;

  difference() {
    union() {
      translate([0,inset,0])
        cylinder(d=inset_hole_diameter+2*wall, h=box_height, $fn=50);
      translate([-inset_hole_diameter/2-wall,0,0]) cube([inset_hole_diameter+2*wall, inset, box_height]);

    }
    translate([0, inset,box_height-inset_hole_depth])
      cylinder(d=inset_hole_diameter,h=inset_hole_depth+1, $fn=20);
  }
}

module project_box_face(size, thickness = 2.5, wall=1.5, face_screw_size=false, draft=false, helper_disks = false) {
  face_hole_d = heatset_hole_clearance_diameter(face_screw_size);
  inset = _box_hole_inset(face_screw_size, wall); //inset_hole_d/2+0.75*wall+0.4;
echo ("inset is: ", inset);

  difference() {
    cube([size[0], size[1], thickness]);

    if(face_screw_size) {
      $fn =  draft? 5 : 20;
      translate([inset, inset, -1]) cylinder(d=face_hole_d, h=wall+2); // bottom left
      translate([inset, size[1]-inset, -1]) mirror([0,1,0]) cylinder(d=face_hole_d, h=wall+2); // top left
      translate([size[0] - inset, inset, -1]) mirror([1,0,0]) cylinder(d=face_hole_d, h=wall+2); // bottom_right
      translate([size[0] - inset, size[1] - inset, -1]) mirror([1,1,0]) cylinder(d=face_hole_d, h=wall+2); // top right


  x_divisions = floor((size[0] - 2 * inset)/max_span);
  for(i = [0:x_divisions + 1]) {
    offset = inset + (size[0] - 2*inset)/(x_divisions + 1.0)*i;

    translate([0,size[1]/2,-1]) mirror_y()
      translate([offset, size[1]/2-inset, 0]){
        cylinder(d=face_hole_d, h=thickness+2);
          }
  }

  y_divisions = floor((size[1] - 2 * inset)/max_span);
  for(i = [0:y_divisions + 1]) {
    offset = inset + (size[1] - 2*inset)/(y_divisions + 1.0)*i;

  translate([size[0]/2,0,-1]) mirror_x()
      translate([size[0]/2-inset, offset, 0]){
        cylinder(d=face_hole_d, h=thickness+2);
          }
    }

  }

  }
  if(helper_disks) {
    helper_disks_for_rectangle(size, center=false);
  }
}

size = [100,200,20];
wall=1.5;
screw_size=3;
max_span=70;
project_box(size,
            face_screw_size=screw_size,
            helper_disks=true,
            wall=wall,
            max_span=max_span);
translate([size[0]+10,0,0])
    project_box_face(size,
                     face_screw_size=screw_size,
                     wall=wall,
                     max_span=max_span,
                     thickness=2.5);
