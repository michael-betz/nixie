module crystal() {
  smoothRad = 8;
  minkowski(){
    cylinder(h=55.8-smoothRad*2, r=28.5/2-smoothRad, center=true);
    sphere(r=smoothRad);
  }
}
