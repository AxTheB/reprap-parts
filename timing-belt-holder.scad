$fn=20;
//thickness of the belt
radius=2.5;

module zipholder(){
//cut parts of edges so zipties are firmly in place
translate([3,5,6])
rotate([0,90,0]){
scale([1,0.8,1]){
difference(){
cylinder(r=20, h=3.5);
translate([0,0,-1])cylinder(r=7.1, h=5);
}
}
}
};


module tbholder(){
difference(){
  union(){
    cube([50,5,12]);
    cube([16, 10, 12]);
    translate([16,5,0]) cylinder(r=5,h=12, $fn=20);
  }
  translate([35, 0,6])
    cube(size=[22,30,4], center=true);

  translate([6.5,5,7])
    cube([17,2.2,12], center=true);

  translate([3,5,7])
    cube([radius*1.4, 2*radius, 12] , center=true);
  translate([8,5,7])
    cube([radius*1.4, 2*radius, 12] , center=true);
  translate([13.6,5,7])
    cube([radius*2, 2*radius, 12], center=true);
  translate([15.5,5,1])
    cylinder(r=radius, h=12);

  zipholder();
  translate([6,0,0])
    zipholder();

}
}

mirror([0,1,0]) tbholder();
