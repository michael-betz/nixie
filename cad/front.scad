// the complete frontpanel
module frontPanel(){
  difference(){
    translate([150/2,fpThickness/2,-45/2]) rotate([90,0,0]){
      difference(){
        cube(size=[150,45,fpThickness], center=true);
        nixies(1.06);
      }
      // PCB standoffs
      translate([0, 0, -pcbDist+0.5]) standOffSquare(138,33,2.7,pcbDist);
      // Teeth at the top
      translate([-150/2,45/2,2]) teeth(teethShrink, 140);
    }
    // bumper slots
    translate([0,21,0]) rotate([90,0,0]) bumpers(2.8, 20);
    // screw holes on the sides
    translate([ -0.1,fpThickness/2,   -4]) rotate([0,90,0]) cylinder(h=14, r=3.5/2);
    translate([ -0.1,fpThickness/2,-45+4]) rotate([0,90,0]) cylinder(h=14, r=3.5/2);
    translate([136.1,fpThickness/2,   -4]) rotate([0,90,0]) cylinder(h=14, r=3.5/2);
    translate([136.1,fpThickness/2,-45+4]) rotate([0,90,0]) cylinder(h=14, r=3.5/2);
  }
}
