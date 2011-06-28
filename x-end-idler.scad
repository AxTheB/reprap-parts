// PRUSA Mendel  
// X-end with idler mount
// GNU GPL v2
// Josef Průša
// josefprusa@me.com
// prusadjs.cz
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel

include <configuration.scad>
corection = 1.17; 

/**
 * @name X end idler
 * @category Printed
 * @using 1 m8spring
 * @using 3 m8nut
 * @using 3 m8washer
 * @using 3 m8washer-big
 * @using 2 m8x30
 */ 
use <x-end.scad>

module xendidler(){
    xend();
    translate(v = [0, 0, 12.5]){
        mirror(){
            translate(v = [17.5,20,-12.5]) { 
                difference(){
                    union(){
                        difference(){
                            translate(v = [0, 0, 15.8/2]) cube(size = [4,40,15.8], center = true);
                            translate(v = [-2.1, 20.1, -5]) rotate(a=[0,0,-90]) roundcorner(4.2);
                        }
                        difference(){
                            translate(v = [15.5, 0, 15.8/2]) cube(size = [4,40,15.8], center = true);
                            translate(v = [2.1+15.5, 20.1, -5]) rotate(a=[0,0,180]) roundcorner(4.2);
                        }
                    }
                    //idler wheel hole
                    translate([8, 11, 8]) rotate(a=[90,0,90]) cylinder(h = 25, r=m8_diameter/2, $fn=6, center=true);
                }
            }
        }
    }
}
difference(){
xendidler();
xendcorners(5,5,5,0,0);
}

