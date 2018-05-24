
// Single standoff of specific inner diameter and heigfht
module standOff( innerDia=2.7/2, height=10 ){
  difference(){
    cylinder(h=height, r=innerDia*1.48);
    translate([0,0,-0.1]) cylinder(h=height+0.2, r=innerDia/2);
  }
}

// Group of 4 standoffs spaced by dx and dy
module standOffSquare( dx, dy, id, h ){
  union(){
    translate([-dx/2,-dy/2,0]) standOff(id,h);
    translate([ dx/2,-dy/2,0]) standOff(id,h);
    translate([-dx/2, dy/2,0]) standOff(id,h);
    translate([ dx/2, dy/2,0]) standOff(id,h);
  }
}

// Model of a screw head to make chamfered holes
module screw(){
  union(){
    cylinder(h=2.6, r1=7.7/2, r2=3.5/2);
    cylinder(h=10,  r=3.5/2 );
  }
}

// Mockup of Nixie PSU board
module psu(){
  color("darkgreen") difference(){
    cube(size=[45,37,1]);
    translate([45-2,37-14,-1]) cylinder(h=3, r=1.1, center=false);
    translate([2,37-14,-1]) cylinder(h=3, r=1.1, center=false);
  }
}

// 4 alignment cylinders for the frontpanel
module bumpers( rad=1, length=10 ){
  translate([0.1, ,-10, 0]) cylinder(h=length, r=rad, center=false);
  translate([149.8,-10, 0]) cylinder(h=length, r=rad, center=false);
  translate([0.1, ,-34, 0]) cylinder(h=length, r=rad, center=false);
  translate([149.8,-34, 0]) cylinder(h=length, r=rad, center=false);
}

// Mockup of the 6 nixie tubes + 2 colons
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
    translate([0,0,0])               tubeGroup();
    translate([groupSpacing/2,0,0])  colonGroup();
    translate([groupSpacing,0,0])    tubeGroup();
    translate([-groupSpacing/2,0,0]) colonGroup();
    translate([-groupSpacing,0,0])   tubeGroup();
  }
}
