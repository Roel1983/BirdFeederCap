$fn =64;

function mm(x) = x;

tube_diameter_inner = mm(56.0);
tube_diameter_outer = mm(59.7);
notch_diameter      = mm( 3.0);
notch_length        = mm( 2.0);
notch_pos           = mm( 4.0);
hook_to_center      = mm(34.6);

tube_thickness = (tube_diameter_outer - tube_diameter_inner) / 2;

color("red") Cap();

*translate([0,0,8.0]) rotate(3) {
    mirror([0,0,1]) cylinder(d=59.5,h=10);
    for(a=[0:90:359]) rotate(a) translate([59.5/2,0, -notch_pos]) {
        rotate(90, [0,1,0]) cylinder(d=3,h=2);
    }
}

module Cap() {
    difference(convexity = 10) {
        render(convexity = 10) ConeShape();
        render(convexity = 10) Tube();
        Hook();
    }

    module Hook() {
        for(x = [-hook_to_center, hook_to_center]) translate([x,0]) {
            cube([2.5, 4.0,  8], true);
            cube([4.0, 2.5, 20], true);
            cube([4.0, 4.0, 9-7.5], true);
        }
    }

    module Tube() {
        linear_extrude(2 * (4.0+notch_pos),center=true) {
            circle(d=tube_diameter_outer);
        }
        for (a=[0:90:359]) rotate(a) {
            render() hull_track() {
                Notch(0, 2.5);
                Notch(0, 4.0);
                Notch(7, 4.0);
                Notch(14, 2);
                Notch(14, 0);
            }
        }

        module Notch(a=0, h=0) {
            $fn=16;
            rotate(a)
            translate([tube_diameter_outer / 2,0, h]) rotate(90, [0,1,0]) {
                hull() translate([0, 0, -tube_thickness / 2]) {
                    cylinder(d = notch_diameter, 
                             h=notch_length + tube_thickness / 2);
                    translate([-notch_length / 2,0]) {
                        cylinder(d = notch_diameter, 
                                 tube_thickness / 2);
                     }
                }
            }
        } 
    }

    module ConeShape() {
        render() {
            n1= 29;
            for (i=[0:n1-1]) rotate(i/n1*360 + rands(0,1,1)[0])
            translate([0, -44 + rands(0,.5,1)[0], 0]) Tile(25 + rands(0,2,1)[0], 16);
            cylinder(d=58, h= 9);
        }

        render() {
            n2= 23;
            for (i=[0:n2-1]) rotate(i/n2*360 + 180 + rands(0,1,1)[0])
            translate([0, -34 + rands(0,.5,1)[0], 6.6 + rands(0,.2,1)[0]]) Tile(15 + rands(0,2,1)[0],15);
            cylinder(d=40, h= 13);
        }
        
        render() {
            n3= 17;
            for (i=[0:n3-1]) rotate(i/n3*360 + 180+ rands(0,1,1)[0])
            translate([0, -23 + rands(0,.5,1)[0], 11.5 + rands(0,.2,1)[0]]) Tile(5 + rands(0,2,1)[0]);
        }

        render() {
            n4= 11;
            for (i=[0:n4-1]) rotate(i/n4*360+ rands(0,1,1)[0])
            translate([0, -13, 14]) Tile(2, 8);
        }

        translate([0,0,10])hull() {
            cylinder(d=8, h = 7.5);
            cylinder(d=12, h = 7);
        }

        module Tile(a, l = 20) {
            render() translate([0,0,1]) hull() {
                linear_extrude(.5) {
                    intersection() {
                        translate([0, 12]) {
                        
                            square([10, 20], true);
                            translate([0,-2]) square([5, 20], true);
                        }
                        square([20, 2 * l], true);
                    }
                    
                }
                mirror([0,0,1])linear_extrude(1) {
                    intersection() {
                        translate([0, 12]) {
                        
                            square([8, 18], true);
                            translate([0,-2]) square([3, 18], true);
                        }
                        square([20, 2 * l], true);
                    }
                    
                }
                
                rotate(a, [1,0,0]) {
                    linear_extrude(1) {
                        intersection() {
                            translate([0, 12]) {
                                square([6, 15], true);
                                square([3, 18], true);
                            }
                            square([20, 2 * l], true);
                        }
                        
                    }
                    linear_extrude(1.25) {
                        intersection() {
                            translate([0, 12]) {
                                square([3, 10], true);
                            }
                            square([20, 2 * l], true);
                        }
                    }
                }
            }
        }
    }
}

module hull_track() {
    for(i = [0:$children - 2]) {
        hull() {
            children(i);
            children(i + 1);
        }
    }
}
