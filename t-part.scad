//Push-fit T part (rod clamp replacement)
//should allow for straight timing belt


include <configuration.scad>

use <teardrop.scad>
axis_diameter_larger = 4.5;
axis_diameter_real = 4;
thread_diameter = 4;
part_z=m8_diameter+6.6;
thread_len = part_z;


difference(){
    translate([-axis_diameter_larger-0.8,-6,-part_z/2]){
        difference(){
            union(){
                cube([20,thread_len,part_z]);
                translate([0,0,part_z/2]) rotate([90,0,180]) {
                    teardrop(r=part_z/2, h=thread_len);
                    mirror([0,1,0])
                        teardrop(r=part_z/2, h=thread_len);
                }
                translate([-5,0,0]) cube([2,part_z,5] );
            }
            translate([-3, 0.6, -0.1]) cube([6, part_z-1.2, 7] );
            translate([-3, -1, 2]) cube([6, part_z+2, 7] );

        }
    }



    //smooth rod goes here
    translate([1,0,0]) rotate([90,180,90]) padded_teardrop(h=11, r=4, pressure_pad_height_ratio=0.28, cut_width=2, internal_offset=2.5);

    //hole thru / threaded rod goes here
    translate([-axis_diameter_larger-0.8,-thread_len/2,0]) {
        rotate([90,0,180]) {
            teardrop(r=thread_diameter, h=thread_len+4);
            mirror([0,0,1]) 
                teardrop(r=thread_diameter, h=thread_len+4);
        }
    }
}
