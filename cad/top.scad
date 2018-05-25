

module teeth( scaleF, endLength=140 ){
  for ( xTooth = [0:10:endLength] ){
    translate([5+xTooth,0,0]) scale(scaleF) cube(size=[6,3,3], center=true);
  }
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

// Top lid
module lid(){
    difference(){
      union(){
        translate([0,fpThickness/2,0]) drop();
        scale([1,1,0.75]) translate([75,fpThickness/2,0]) rotate([0,90,0]) cylinder(r=fpThickness/2, h=155, center=true);
      }
      union(){
        translate([-5,-1,-5]) cube(size=[160,12,5], center=false);
        translate([0,3,0]) scale([1,1,1.5]) teeth(1.0, 140);
        translate([0,85.5,0]) scale([1,1,1.5]) teeth(1.0, 140);
        translate([151.0,4,0]) scale([0.6,1,1.5]) rotate([0,0,90]) teeth(1, 70);
        translate([-1.0,4,0]) scale([0.6,1,1.5]) rotate([0,0,90]) teeth(1, 70);
      }
    }
}
