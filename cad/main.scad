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
  module colonGroup() {
    translate([0,5,5]) scale([scaling, scaling, scaling]) cylinder(h=20, r=3.2, center=true);
    translate([0,-5,5])scale([scaling, scaling, scaling]) cylinder(h=20, r=3.2, center=true);
  }
  union(){
    translate([0,0,0])              tubeGroup();
    translate([groupSpacing/2,0,0]) colonGroup();
    translate([groupSpacing,0,0])   tubeGroup();
    translate([-groupSpacing/2,0,0]) colonGroup();
    translate([-groupSpacing,0,0])  tubeGroup();
  }
}

// standoffs
module sOffs(){
  soDist = 3;
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
      translate([-2.5,0,0]) cube(size=[155, 83, 0.5], center=false);
      translate([-2.5,0,0.5])
        scale([1.03333333,1.0,0.15])
          surface( file="./drop.png", center=false, convexity=0 );
    }
    translate([150/2,42,0]) cylinder(h=30, r=15, center=true);
  }
}

module frontPanel() {
  panel();
  // the pcb
  translate([0,0,-pcbDist]) color("darkgreen") cube(size=[144,39,1], center=true);
  // color("white") nixies( 1.0 );
}


!translate([0,0,10]) difference(){
  union(){
    translate([0,fpThickness/2,0]) drop();
    scale([1,1,0.5]) translate([75,fpThickness/2,0]) rotate([0,90,0]) cylinder(r=fpThickness/2, h=155, center=true);
  }
  union(){
    translate([-5,-1,-5]) cube(size=[160,12,5], center=false);
    translate([0,3,0]) teeth(1.0, 140);
    translate([0,85.5,0]) teeth(1.0, 140);
    translate([151.0,4,0]) scale([0.6,1,1]) rotate([0,0,90]) teeth(1, 70);
    translate([-1.0,4,0]) scale([0.6,1,1]) rotate([0,0,90]) teeth(1, 70);
  }
}
color("white") translate([0,fpThickness/2,0]) translate([150/2,42,22]) crystal();


// Frontpanel
// sidewalls
union(){
  translate([150/2,fpThickness/2,-45/2]) rotate([90,0,0]) frontPanel();
  translate([0,3,0]) teeth(0.98, 140);
  translate([-2.5,0,-45]) cube(size=[2.5,88,45], center=false);
  translate([150,0,-45]) cube(size=[2.5,88,45], center=false);
  translate([151.0,4,0]) scale([0.6,1,1]) rotate([0,0,90]) teeth(0.98, 70);
  translate([-2.5,0,-45-2.5]) cube(size=[155,88,2.5], center=false);
  translate([-1.0,4,0]) scale([0.6,1,1]) rotate([0,0,90]) teeth(0.98, 70);
  translate([150/2,88-fpThickness/4,-45/2]) rotate([90,0,0]) cube(size=[150,45,fpThickness/2], center=true);
  translate([0,85.5,0]) teeth(0.98, 140);
}
module teeth( scaleF, endLength=140 ){
  for ( xTooth = [0:10:endLength] ){
    translate([5+xTooth,0,0]) scale(scaleF) cube(size=[6,3,3], center=true);
  }
}

