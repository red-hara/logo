d_sep = 50;
z = 20;
m = d_sep/z;
h_a = m;
h_f = m*1.25;

r = d_sep/2-h_f;
r_a = d_sep/2+h_a;

r_max = r + h_f + h_a;
r_mid = d_sep / 2;
a_max = sqrt(r_max*r_max - r*r)/r*180/PI;
a_mid = sqrt(r_mid*r_mid - r*r)/r*180/PI;

function x(a) = r*cos(a) + r*a*sin(a)/180*PI;
function y(a) = r*sin(a) - r*a*cos(a)/180*PI;

ang_max = atan2(y(a_max), x(a_max));
ang_mid = atan2(y(a_mid), x(a_mid));
ang_extra = 360 / z / 4 + ang_mid;

function rng_p(a, rn) = (a > a_max) ? concat(rn, [[x(a_max), y(a_max)]]) : rng_p(a + 1, concat(rn, [[x(a), y(a)]]));
function rng_n(a, rn) = (a > a_max) ? concat(rn, [[x(a_max), -y(a_max)]]) : rng_n(a + 1, concat(rn, [[x(a), -y(a)]]));

module tooth() {
    zero = [[0, 0]];
    rotate(-ang_extra) polygon(concat(zero, rng_p(0, [])));
    rotate(ang_extra) polygon(concat(zero, rng_n(0, [])));
    base_x = x(0);
    base_y = y(0);
    top_x = x(a_max);
    top_y = y(a_max);
    points = [
        [cos(ang_extra)*base_x - sin(ang_extra)*base_y, sin(ang_extra)*base_x + cos(ang_extra)*base_y],
        [cos(ang_extra)*top_x + sin(ang_extra)*top_y, sin(ang_extra)*top_x - cos(ang_extra)*top_y],
        [cos(-ang_extra)*top_x - sin(-ang_extra)*top_y, sin(-ang_extra)*top_x + cos(-ang_extra)*top_y],
        [cos(-ang_extra)*base_x - sin(-ang_extra)*base_y, sin(-ang_extra)*base_x + cos(-ang_extra)*base_y]
    ];
    polygon(points);
}


n = z;
module gear() {
    circle(r=r, $fn=360);
    for (i = [-2: n-3]) {
        rotate(i*360/z) {
            tooth();
        }
    }
}

module bigear(a) {
    union() {
        linear_extrude(height=10, twist = a) gear();
        translate([0, 0, 10]) rotate(-a) linear_extrude(height=10, twist = -a) gear();
    }
}

rotate(360*$t) bigear(10);
translate([d_sep, 0]) rotate(-360*$t) rotate(180 + 360/z/2) bigear(-10);