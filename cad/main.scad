use <8422.scad>
use <crystal.scad>

// $fn=30;

tubeSpacing  = 10.5;
groupSpacing = 50.0;

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
    nixies(1.06);
  }
  sOffs();
}

module drop() {
  difference(){
    union(){
      cube(size=[150, 83, 0.5], center=false);
      translate([0,0,0.5])
        scale([1.0,1.0,0.15])
          surface( file="./drop.png", center=false, convexity=0 );
    }
    translate([150/2,42,0]) cylinder(h=30, r=15, center=true);
  }
}

module frontPanel() {
  panel();
  // the pcb
  translate([0,0,-pcbDist]) color("darkgreen") cube(size=[144,39,1], center=true);
  color("white") nixies( 1.0 );
}


translate([0,0,20]) difference(){
  union(){
    translate([0,fpThickness/2,0]) drop();
    scale([1,1,0.5]) translate([75,fpThickness/2,0]) rotate([0,90,0]) cylinder(r=fpThickness/2, h=150, center=true);
  }
  union(){
    translate([-5,-1,-5]) cube(size=[160,12,5], center=false);
    translate([0,3,0]) teeth(1.0);
    translate([0,85.5,0]) teeth(1.0);
  }
}
color("white") translate([0,fpThickness/2,0]) translate([150/2,42,22]) crystal();


// Frontpanel
// sidewalls
union(){
  translate([150/2,fpThickness/2,-45/2]) rotate([90,0,0]) frontPanel();
  translate([0,3,0]) teeth(0.98);
  translate([0,fpThickness,-45]) cube(size=[2.5,78,45], center=false);
  translate([150-2.5,fpThickness,-45]) cube(size=[2.5,78,45], center=false);
  translate([0,0,-45]) cube(size=[150,88,2.5], center=false);
  translate([150/2,88-fpThickness/4,-45/2]) rotate([90,0,0]) cube(size=[150,45,fpThickness/2], center=true);
  translate([0,85.5,0]) teeth(0.98);
}
module teeth( scaleF ){
  for ( xTooth = [0:10:140] ){
    translate([5+xTooth,0,0]) scale(scaleF) cube(size=[6,3,3], center=true);
  }
}

