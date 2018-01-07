module helper_disk(diameter=15,height=1) {
  cylinder(d=diameter,h=height);
}

module helper_disks_for_rectangle(size, diameter=15, center=true) {
  x_size = size[0];
  y_size = size[1];
  outset = diameter*0.1; // amount to move disk off-center
  disc_offsets = [[-outset, -outset, 0],
               [-outset, y_size + outset, 0],
               [x_size + outset, y_size + outset, 0],
               [x_size + outset, -outset, 0]];

  centering_offset = center ? [-x_size/2, -y_size/2, 0] : [0, 0, 0];
  translate(centering_offset)
    for(offset = disc_offsets) {
      translate(offset) helper_disk();
    }
}
