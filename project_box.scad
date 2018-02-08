use <heatset_insert.scad>
use <3d_print/helper_disk.scad>
use <layout/layout.scad>
use <soften/fillets.scad>
use <soften/cylinder.scad>
use <soften/cube.scad>
include <constants/all.scad>

function _box_hole_inset(face_screw_size, wall) =
  heatset_hole_diameter(face_screw_size)[0]/2 + 1.5 * wall;

module _project_box_bolt_pattern(size, wall, face_screw_size) {
  inset = _box_hole_inset(face_screw_size, wall);

  x_posts = ceil((size.x - 2 * inset)/max_span);
  x_offset = (size.x - 2*inset)/(x_posts);
  echo("x_posts: ", x_posts, " at ", x_offset);
  for(i = [0:x_posts-1]) {
    mirror_xy() {
      offset = (size.x/2 - inset) - i * x_offset;
      translate([offset, -(size.y/2)+inset, 0])
        children();//_project_box_post(size.z, wall, face_screw_size);
    }
  }

  y_posts = ceil((size.y - 2 * inset)/max_span);
  y_offset = (size.y - 2*inset)/(y_posts);
  echo("y_posts: ", y_posts, " at ", y_offset);
  for(i = [0:y_posts-1]) {
    mirror_xy() {
      offset = (size.y/2 - inset) - i * y_offset;
      translate([ -(size.x/2)+inset, offset , 0])
        rotate([0,0,-90])
          children();//_project_box_post(size.z, wall, face_screw_size);
    }
  }
}

module project_box(size, wall=1.5, face_screw_size=false, helper_disks=false, max_span=100, outside_r=0, fillet_r=3) {
  box_height = size[2];

  module outside_shell() {
    translate([0,0,box_height/2])
      soft_cube(size, r=outside_r, center=true);
  }

  module blank_shell() {
    difference() {
      outside_shell();
      translate([0,0,wall+box_height/2])
        soft_cube(size - [wall*2, wall*2, 0], center=true,r=fillet_r, sidesonly=$simplify ? true : false);
    }
  }

  // generate the basic shell
  union() {
    render() blank_shell();

    intersection() {
      outside_shell();
      _project_box_bolt_pattern(size, wall, face_screw_size) {
        _project_box_post(size.z, wall, face_screw_size, fillet_r);
      }
    }
  }
  if(helper_disks) {
    helper_disks_for_rectangle(size, center=true);
  }
}

module _project_box_post(height, wall, screw_size, fillet_r) {
  _fudge_hole_size = 0.35;
  inset_hole_diameter = heatset_hole_diameter(screw_size)[0];
  inset = _box_hole_inset(screw_size, wall);
  box_height = height;

  translate([0,-inset,0])
    difference() {
      union() {
        translate([0,inset,wall])
          soft_cylinder(d=inset_hole_diameter+2*wall, h=box_height-wall, fillet_r=$simplify ? 0 : fillet_r, fillet_angle=180);
        translate([-inset_hole_diameter/2-wall,0,0]) cube([inset_hole_diameter+2*wall, inset, box_height]);
          if(!$simplify) mirror_x() translate([inset_hole_diameter/2+wall,wall,0]) {
            fillet(size[2],fillet_r, axis=z_axis, $fn=fn(fillet_r*2));
          }
          if(!$simplify) mirror_x() translate([inset_hole_diameter/2+wall,wall, wall]) fillet(inset-wall,fillet_r, axis=y_axis,$fn=fn(fillet_r*2));


       if(!$simplify) mirror_x() difference() {
          $fn = fillet_fn($fn, fillet_r);

          translate([inset_hole_diameter/2+wall,wall,wall]) cube([fillet_r,fillet_r,fillet_r]);
          translate([inset_hole_diameter/2+wall+fillet_r,wall+fillet_r,wall+fillet_r]) sphere(r=fillet_r, $fn=fn(fillet_r*2));
       }

      }
      translate([0, inset,box_height])
        heatset_insert_hole(screw_size);
    }
}

module project_box_face(size, thickness = 2.5, wall=1.5, face_screw_size=false, helper_disks = false, outside_r=0) {
  face_hole_d = face_screw_size * 1.1;
  inset = _box_hole_inset(face_screw_size, wall); //inset_hole_d/2+0.75*wall+0.4;

  difference() {
    //cube([size[0], size[1], thickness]);
    translate([0,0,thickness/2])
      soft_cube([size.x,size.y, thickness], r=outside_r, center=true);
    if(face_screw_size) {
      _project_box_bolt_pattern(size, wall, face_screw_size) {
        translate([0,0,-epsilon]) cylinder(d=face_hole_d, h=thickness+2*epsilon);
      }
    }
  }
  if(helper_disks) {
    helper_disks_for_rectangle(size, center=true);
  }
}

//$simplify=true;
//$fn=20;
size = [50,50,20];
wall=3;
screw_size=3;
max_span=100;
*project_box(size,
            face_screw_size=screw_size,
            helper_disks=true,
            wall=wall,
            max_span=max_span,
            outside_r=5);
*translate([size[0]+20,0,0])
    project_box_face(size,
                     face_screw_size=screw_size,
                     wall=wall,
                     max_span=max_span,
                     thickness=2.5,
                     outside_r=3, helper_disks=true);

*translate([0,0,size.z+1])
    project_box_face(size,
                     face_screw_size=screw_size,
                     wall=wall,
                     max_span=max_span,
                     thickness=2.5,
                     outside_r=3, helper_disks=true);
*_project_box_post(size.z, wall, screw_size);
