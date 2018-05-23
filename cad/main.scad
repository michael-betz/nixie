// TODO:
// * Slot for ESP32 antenna
// * Mounting of Nixie HV PSU
// * Power input = some kind of USB socket?

use <8422.scad>
use <crystal.scad>

$fn=70;

tubeSpacing  = 10.5;
groupSpacing = 50.0;
teethShrink = 0.95;
fpThickness = 10;
pcbDist = 12;

module nixies( scaling ) {
  module tubeGroup() {
    translate([-tubeSpacing,0,0]) scale([scaling, scaling, scaling]) nixie8422();
    translate([ tubeSpacing,0,0]) scale([scaling, scaling, scaling]) nixie8422();
  }
  module colonGroup() {
    translate([0,5,5]) scale([scaling, scaling, scaling]) cylinder(h=10, r=3.2, center=true);
    translate([0,-5,5])scale([scaling, scaling, scaling]) cylinder(h=10, r=3.2, center=true);
  }
  union(){
    translate([0,0,0])              tubeGroup();
    translate([groupSpacing/2,0,0]) colonGroup();
    translate([groupSpacing,0,0])   tubeGroup();
    translate([-groupSpacing/2,0,0]) colonGroup();
    translate([-groupSpacing,0,0])  tubeGroup();
  }
}

module standOff( innerDia=2.7/2, height=10 ){
  difference(){
    cylinder(h=height, r=innerDia*1.48);
    translate([0,0,-0.1]) cylinder(h=height+0.2, r=innerDia/2);
  }
}

module standOffSquare( dx, dy, id, h ){
  union(){
    translate([-dx/2,-dy/2,0]) standOff(id,h);
    translate([ dx/2,-dy/2,0]) standOff(id,h);
    translate([-dx/2, dy/2,0]) standOff(id,h);
    translate([ dx/2, dy/2,0]) standOff(id,h);
  }
}

// the frontpanel
module panel() {
  difference(){
    cube(size=[150,45,fpThickness], center=true);
    nixies(1.06);
  }
  // PCB standoffs
  translate([0, 0, -pcbDist+0.5]) standOffSquare(145-6,40-6,2.7,pcbDist);
  // Teeth
  translate([-150/2,45/2,2]) teeth(teethShrink, 140);
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
  translate([-144/2-4.5/2,0,-pcbDist-11]) color("darkgreen") cube(size=[4.5,18.5,1], center=true);
  translate([0,0,-pcbDist-12]) color("darkgreen") cube(size=[144,39,1], center=true);
  // color("white") nixies( 1.0 );
}

module sidewalls(){
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

module teeth( scaleF, endLength=140 ){
  for ( xTooth = [0:10:endLength] ){
    translate([5+xTooth,0,0]) scale(scaleF) cube(size=[6,3,3], center=true);
  }
}

module bumpers( rad=1, length=10 ){
  translate([0.1, ,-10, 0])  cylinder(h=length, r=rad, center=false);
  translate([149.8,-10, 0])  cylinder(h=length, r=rad, center=false);
  translate([0.1, ,-34, 0])  cylinder(h=length, r=rad, center=false);
  translate([149.8,-34, 0])  cylinder(h=length, r=rad, center=false);
}

module screw(){
  union(){
    cylinder(h=2.6, r1=7.7/2, r2=3.5/2);
    cylinder(h=10,  r=3.5/2 );
  }
}

module psu(){
  color("darkgreen") difference(){
    cube(size=[45,37,1]);
    translate([45-2,37-14,-1]) cylinder(h=3, r=1.1, center=false);
    translate([2,37-14,-1]) cylinder(h=3, r=1.1, center=false);
  }
}

// Mockups
// translate([150/2,50,-15]) color("darkgreen") cube(size=[60,30,1], center=true);
// color("white") translate([0,fpThickness/2,0]) translate([150/2,42,22]) crystal();
// translate([4,80,-35]) rotate([0,0,-90]) psu();

// Top lid
*translate([0,0,20]) difference(){
  union(){
    translate([0,fpThickness/2,0]) drop();
    scale([1,1,0.75]) translate([75,fpThickness/2,0]) rotate([0,90,0]) cylinder(r=fpThickness/2, h=155, center=true);
  }
  union(){
    translate([-5,-1,-5]) cube(size=[160,12,5], center=false);
    translate([0,3,0]) teeth(1.0, 140);
    translate([0,85.5,0]) teeth(1.0, 140);
    translate([151.0,4,0]) scale([0.6,1,1]) rotate([0,0,90]) teeth(1, 70);
    translate([-1.0,4,0]) scale([0.6,1,1]) rotate([0,0,90]) teeth(1, 70);
  }
}

// Frontpanel
*difference(){
  translate([150/2,fpThickness/2,-45/2]) rotate([90,0,0]) frontPanel();
  // bumper slots
  translate([0,21,0]) rotate([90,0,0]) bumpers(2.8, 20);
  // screw holes on the sides
  translate([-0.1,fpThickness/2,-4]) rotate([0,90,0]) cylinder(h=14, r=3.5/2);
  translate([-0.1,fpThickness/2,-45+4]) rotate([0,90,0]) cylinder(h=14, r=3.5/2);
  translate([136.1,fpThickness/2,-4]) rotate([0,90,0]) cylinder(h=14, r=3.5/2);
  translate([136.1,fpThickness/2,-45+4]) rotate([0,90,0]) cylinder(h=14, r=3.5/2);
}

// Lower part (sidewalls)
sidewalls();
