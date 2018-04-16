use <8422.scad>
use <crystal.scad>

tubeSpacing  = 10.0;
groupSpacing = 45;

module nixies( scaling ) {
  module tubeGroup() {
    translate([-tubeSpacing,0,0]) scale([scaling, scaling, scaling]) nixie8422();
    translate([ tubeSpacing,0,0]) scale([scaling, scaling, scaling]) nixie8422();
  }
  translate([0,0,0])              tubeGroup();
  translate([groupSpacing,0,0])   tubeGroup();
  translate([-groupSpacing,0,0])  tubeGroup();
}

// standoffs
module sOffs(){
  soDist = 5;
  translate([ 145/2-soDist, 40/2-soDist,-pcbDist+0.5]) cylinder(h=pcbDist, r=4);
  translate([-145/2+soDist,-40/2+soDist,-pcbDist+0.5]) cylinder(h=pcbDist, r=4);
  translate([-145/2+soDist, 40/2-soDist,-pcbDist+0.5]) cylinder(h=pcbDist, r=4);
  translate([ 145/2-soDist,-40/2+soDist,-pcbDist+0.5]) cylinder(h=pcbDist, r=4);
}

// the frontpanel
fpThickness = 10;
pcbDist = 12;
module panel() {
  difference(){
    cube(size=[150,45,fpThickness], center=true);
    nixies(1.08);
  }
  sOffs();
}

module drop() {
  // the drop
  translate([-150/2,22,fpThickness/2])
    rotate([-90,0,0])
      scale([1.0,1.0,0.1])
        surface( file="./drop.png", center=false, convexity=0 );
}

panel();
difference(){
  drop();
  translate([0,25,-22]) rotate([90,0,0]) cylinder(h=50, r=15, center=true);
}
translate([0,35,-22]) rotate([90,0,0]) crystal();

// the pcb
translate([0,0,-pcbDist]) color("darkgreen") cube(size=[144,39,1], center=true);
nixies( 1.0 );



