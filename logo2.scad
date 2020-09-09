module logo() {
    d_sep = 50;
    z = 10;
    m = d_sep/z;
    h_a = m/1.5;
    h_f = m/1.5;

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

    ang_hole = 360 / z - ang_extra - 360 / z / 2;
    w_hole = sin(ang_hole) * r;

    n = z;
    module gear() {
        union() {
            circle(r=r, $fn=360);
            for (i = [-2: n-3]) {
                rotate(i*360/z) {
                    tooth();
                }
            }
        }
    }

    module impl() {
        union() {
            difference() {
                gear();
                rotate(360 / z / 2 + 360 / z * 2) square([r_max * 2, w_hole * 2], center = true);
                circle(r=r - w_hole * 3, $fn=360);
            }
            rotate(45) square([(r - w_hole * 3) * 2, w_hole * 3], center=true);
        }
    }
    impl();
}

logo();