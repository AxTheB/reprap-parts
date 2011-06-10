include <configuration.scad>
use <bushing.scad>

// height of the plate
plate_height = 6;
//size of end cluster
platform_r = 12;
//distance of mounting holes along Y axis
y_distance = 140-2*8;
// distance of mounting holes across the printer (X axis)
x_distance = 225-2*8;

//offset between holes for top plate and center of Y rods
x_offset = 15;

//how much enlarge 'nose' with X axis screw
x_screw_delta = platform_r/2;

small_r = (x_offset-platform_r)/2;

//utility modules

module top_plate_mountpoint(angle = -45){
  //top plate mountpoint
  rotate([0,0,angle]){
    translate([0,0,-0.5]){
      translate([0,m4_diameter*0.8,0]) 
        rotate([0,0,90]) cylinder(h = plate_height+1, r = m4_diameter/2, $fn=6);
      translate([0,-m4_diameter*0.8,0]) 
        rotate([0,0,90]) cylinder(h = plate_height+1, r = m4_diameter/2, $fn=6);
      translate([-m4_diameter/2,-m4_diameter*0.8,0])
        cube([m4_diameter,m4_diameter*1.6,plate_height+1]);
    }
  }
}


module c_bushing(){
  //bushing moved so it has base at [0,0,0] pointing to sky.
  rotate(a = [90,0,0])
    translate(v = [0,8,-5.5]) 
      bushing(lenght = 11);
}
module hole_with_nuttrap(){
  rotate([0,0,90]){
  cylinder(h = plate_height+1, r = m4_diameter/2, $fn=6);
  translate([0,0,plate_height-3]) 
    cylinder(h = 5, r = m4_nut_diameter/2, $fn=6);
  }
}

module cluster_link_shell(len=100,belt=false){
  translate([0,0,plate_height/2]) cube(size = [len,platform_r,plate_height], center = true);
  translate([-len/2,0,0]) cylinder(h=plate_height*1.5, r=platform_r);
  translate([len/2,0,0]) cylinder(h=plate_height*1.5, r=platform_r);
  if (belt){
    translate([0,platform_r/2,0]) cylinder(r=platform_r/2,h=plate_height);
  }
}


module cluster_link(len=100, belt=false){
  difference(){
    cluster_link_shell(len, belt);

    translate([-len/2,0,-1]) cylinder(h=plate_height*1.5+2, r=m4_diameter/2);
    translate([len/2,0,-1]) cylinder(h=plate_height*1.5+2, r=m4_diameter/2);

    if (belt){
      translate([0,platform_r/2,0]) cylinder(r=m4_diameter/2,h=plate_height+2);
    }
  }
}


module end_cluster_shell(with_bushing=true){
  //bushing platform
  translate([0,x_offset,0])  cylinder(h = plate_height, r = platform_r);
  //top plate mount platform
  cylinder(h = plate_height, r = platform_r);
  //mass between platforms
  translate([-platform_r,0,0]) cube([platform_r*2,x_offset, plate_height]);
  if (with_bushing) {
    //bushing
    translate([-2,x_offset,0])  rotate([0,0,90]) translate([0,0,plate_height]) c_bushing();
    translate([7,x_offset,plate_height+1.9])  rotate([0,0,90]) cube(size = [5,3,4], center=true);
  }

  // mountpoint for link along the X axis
  translate([-platform_r/2,x_offset,0]) cube([platform_r, platform_r+m4_diameter/2+x_screw_delta, plate_height]);
  translate([0,x_offset+x_screw_delta+platform_r+m4_diameter/2,0]) cylinder(r=platform_r/2, h=plate_height);

  // mountpoint for link along the Y axis
  translate([platform_r+small_r,small_r,0]) cube([platform_r, platform_r, plate_height]);
  translate([2*platform_r+small_r,small_r+platform_r/2,0]) cylinder(r=platform_r/2, h=plate_height);

  //rounded corners
  difference(){
    translate([platform_r,0,0]) cube([small_r,platform_r+2*small_r,plate_height]);

    translate([platform_r+small_r, 0,-1]) cylinder(r = small_r, h = plate_height+2, $fn=10);
    translate([platform_r+small_r, platform_r+2*small_r,-1]) cylinder(r = small_r, h = plate_height+2, $fn=10);
  }

}

module end_cluster(){
  // this part is edge of carriage frame, hosting bushing and hole for top plate
  difference(){
    end_cluster_shell();

    top_plate_mountpoint();
    //hole for link along X axis
    translate([0,x_offset+x_screw_delta+platform_r+m4_diameter/2,-0.5]) hole_with_nuttrap();
    //and along Y axis
    translate([2*platform_r+small_r, small_r+platform_r/2,-0.5]) hole_with_nuttrap();

  }
}

module x_link(){
  cluster_x_delta = x_offset+x_screw_delta+platform_r+m4_diameter/2;
  x_link_len = x_distance - cluster_x_delta *2;
  difference(){
    cluster_link(len = x_link_len, belt=true);
    translate([x_link_len/2+cluster_x_delta,0,plate_height*.75])
      rotate([0,0,90])
        end_cluster_shell(false);
    mirror([1,0,0])
      translate([x_link_len/2+cluster_x_delta,0,plate_height*.75])
        rotate([0,0,90])
          end_cluster_shell(false);
  }
}

module y_link(){

  //distance from top plate mountpoint to screw hole along the main axis
  cluster_y_delta = small_r+platform_r*2;
  //length of link part, from screw to screw
  y_link_len = y_distance - cluster_y_delta *2;
  echo(y_link_len);
  difference(){
    cluster_link(len = y_link_len, belt=false);
    translate([(y_link_len/2+cluster_y_delta),small_r+platform_r/2,plate_height*.75])
      rotate([0,0,180])
        end_cluster_shell(false);
    mirror([1,0,0])
    translate([(y_link_len/2+cluster_y_delta),small_r+platform_r/2,plate_height*.75])
      rotate([0,0,180])
        end_cluster_shell(false);
  }
}

translate([60,0,0]) rotate([0,0,90]) y_link();
translate([0,66,0]) x_link();
translate([platform_r+3,platform_r+3,0]) end_cluster();
translate([2.5*platform_r+4,-2.5*platform_r,0]) 
  mirror([1,0,0])
    end_cluster();

rotate([0,0,180]){
  translate([60,0,0]) rotate([0,0,90]) y_link();
  translate([0,66,0]) x_link();
  translate([platform_r+3,platform_r+3,0]) end_cluster();
  translate([2.5*platform_r+4,-2.5*platform_r,0]) 
    mirror([1,0,0])
      end_cluster();
}

%cube(size = [180,190,1], center = true);
