// TODO:
// * Slot for ESP32 antenna
// * Mounting of Nixie HV PSU
// * Power input = some kind of USB socket?

$fn=40;
tubeSpacing  = 10.5;
groupSpacing = 50.0;
teethShrink = 0.94;
fpThickness = 10;
pcbDist = 12;

include <8422.scad>
include <crystal.scad>
include <helpers.scad>
include <top.scad>
include <front.scad>
include <lower.scad>

// ----------------------
//  Mockups (don't print!)
// ----------------------
// Crystal tube mockup
color("white") translate([0,fpThickness/2,0]) translate([150/2,42,22]) crystal();

// PCBs in the base (PSU and crystal holder)
translate([150/2,50,-15]) color("darkgreen") cube(size=[60,30,1], center=true);
translate([4,80,-37]) rotate([0,0,-90]) psu();

//  the pcb stack mockup behind the frontpanel
translate([3,fpThickness/2+12.5,-45/2-39/2]) rotate([90,0,0]) {
  color("darkgreen") cube(size=[144,39,1]);
  color("darkgreen") translate([0,0,-12]) cube(size=[144,39,1]);
  color("darkgreen") translate([-4.5,39/2-18.5/2,-11]) cube(size=[4.5,18.5,1]);
}

// the nixie tube mockup
color("white") translate([150/2,fpThickness/2,-45/2]) rotate([90,0,0]) nixies( 1.0 );

// ----------------------
//  3 3D printable parts
// ----------------------
lid();          // Lid with drop shape
lower();        // Sidewalls
frontPanel();   // Frontpanel with Nixie cut-outs
