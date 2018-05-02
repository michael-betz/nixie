use <8422.scad>

module nixies( scaling ) {
  module tubeGroup() {
    translate([-tubeSpacing,0,0]) scale([scaling, scaling, scaling]) nixie8422();
    translate([ tubeSpacing,0,0]) scale([scaling, scaling, scaling]) nixie8422();
  }
  translate([0,0,0])              tubeGroup();
  translate([groupSpacing,0,0])   tubeGroup();
  translate([-groupSpacing,0,0])  tubeGroup();
}

module frontPanel() {
  panel();
  // the pcb
  translate([0,0,-pcbDist]) color("darkgreen") cube(size=[144,39,1], center=true);
  color("white") nixies( 1.0 );
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
