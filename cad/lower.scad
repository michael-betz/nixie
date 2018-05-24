// The lower part of the enclosure
// 3 side-walls and bottom

module lower(){
  intersection(){
    difference(){
      union(){
        translate([-2.5,0,-45]) cube(size=[2.5,88,45], center=false);
        translate([150,0,-45]) cube(size=[2.5,88,45], center=false);
        translate([151.0,4,0]) scale([0.6,1,1]) rotate([0,0,90]) teeth(teethShrink, 70);
        translate([-2.5,0,-45-2.5]) cube(size=[155,88,2.5], center=false);
        translate([-1.0,4,0]) scale([0.6,1,1]) rotate([0,0,90]) teeth(teethShrink, 70);
        translate([150/2,88-fpThickness/4,-45/2]) rotate([90,0,0]) cube(size=[150,45,fpThickness/2], center=true);
        translate([0,85.5,0]) teeth(teethShrink, 140);
        // sidewall bumper pins
        translate([0,21,0]) rotate([90,0,0]) bumpers(2.7, 20);
        // Standoffs for crystal PCB (inset 3 mm)
        translate([150/2, 50, -45-2]) standOffSquare(60-6,30-6,2.7,45-15.5+2);
        // Standoff for NIxie PSU
        translate([27, 37,   -45-2]) standOff( 2.2, 10 );
        translate([27, 37+41,-45-2]) standOff( 2.2, 10 );
        // Standoff for power in
        translate([150-8, 75, -45-2]) standOffSquare(10,10,2.7,5);
      }
      // power in
      translate([136,80,-41.99]) cube(size=[12,10,6]);
      // tapered screw holes
      translate([-2.6,fpThickness/2,-4]) rotate([0,90,0]) screw();
      translate([-2.6,fpThickness/2,-45+4]) rotate([0,90,0]) screw();
      translate([152.6,fpThickness/2,-4]) rotate([0,-90,0]) screw();
      translate([152.6,fpThickness/2,-45+4]) rotate([0,-90,0]) screw();
      // antenna slot
      translate([-2.0,26,-33.5]) cube(size=[10,4,22], center=false);
    }
    // clip excess bumper pins sticking out in x direction
    translate([-2.5,-1,-46]) cube(size=[155,90,50], center=false);
  }
}
