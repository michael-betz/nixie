module pin() {
  translate([11.1/2, 0,        0]) cylinder(h=6, r=0.5);
  translate([11.1/2, 4.3,      0]) cylinder(h=6, r=0.5);
  translate([0,      17.1/2,   0]) cylinder(h=6, r=0.5);
  translate([sin(26)*17.1/2, cos(26)*17.1/2, 0]) cylinder(h=6, r=0.5);
}

module nixie8422(){
  smoothRad = 6;
  union(){
    minkowski(){
      cube(size=[18.85-smoothRad*2, 25.1-smoothRad*2, 20-smoothRad*2], center=true);
      sphere(r=smoothRad);
    }
    translate([0,0,-15]) union(){
      pin();
      mirror([0,1,0]) pin();
      mirror([1,0,0]) pin();
      mirror([0,1,0]) mirror([1,0,0]) pin();
    }
  }
}

// nixie8422();
