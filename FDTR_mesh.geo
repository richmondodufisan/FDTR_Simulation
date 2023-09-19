// Gmsh project created on Wed Aug 09 07:54:14 2023
xcen = 0;
ycen = 0;
radius = 8;
dop_thick = 0.09;

x_dir = 40;
y_dir = 20;
z_dir = 40;

pump_refine = 0.9;
reg_element_refine = 12;
gb_refine = 0.6;

x_left_up = -.5000000000;
x_right_up = .5000000000;
z_left_up = 0;
z_right_up = 0;

x_left_down = -.5000000000;
x_right_down = .5000000000;
z_left_down = -40.0;
z_right_down = -40.0;


SetFactory("OpenCASCADE");
//+
Point(1) = {x_dir, y_dir, 0, reg_element_refine};
//+
Point(2) = {x_dir, -y_dir, 0, reg_element_refine};
//+
Point(3) = {-x_dir, -y_dir, 0, reg_element_refine};
//+
Point(4) = {-x_dir, y_dir, 0, reg_element_refine};
//+
Point(5) = {-x_dir, y_dir, -z_dir, reg_element_refine};
//+
Point(6) = {-x_dir, -y_dir, -z_dir, reg_element_refine};
//+
Point(7) = {x_dir, -y_dir, -z_dir, reg_element_refine};
//+
Point(8) = {x_dir, y_dir, -z_dir, reg_element_refine};
//+
Line(1) = {3, 2};
//+
Line(2) = {3, 6};
//+
Line(3) = {6, 7};
//+
Line(4) = {7, 2};
//+
Line(5) = {6, 5};
//+
Line(6) = {5, 8};
//+
Line(7) = {8, 7};
//+
Line(8) = {8, 1};
//+
Line(9) = {1, 2};
//+
Line(10) = {2, 3};
//+
Line(11) = {3, 4};
//+
Line(12) = {4, 5};
//+
Line(13) = {4, 1};
//+
Curve Loop(1) = {11, 12, -5, -2};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {3, 4, -1, 2};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {7, 4, -9, -8};
//+
Plane Surface(3) = {3};
//+
Curve Loop(4) = {6, 7, -3, 5};
//+
Plane Surface(4) = {4};
//+
Curve Loop(5) = {6, 8, -13, 12};
//+
Plane Surface(5) = {5};
//+
Curve Loop(6) = {1, -9, -13, -11};
//+
Plane Surface(6) = {6};
//+
Point(9) = {x_dir, y_dir, dop_thick, reg_element_refine};
//+
Point(10) = {x_dir, -y_dir, dop_thick, reg_element_refine};
//+
Point(11) = {-x_dir, -y_dir, dop_thick, reg_element_refine};
//+
Point(12) = {-x_dir, y_dir, dop_thick, reg_element_refine};
//+
Line(14) = {9, 10};
//+
Line(15) = {10, 11};
//+
Line(16) = {11, 12};
//+
Line(17) = {12, 9};
//+
Line(18) = {11, 3};
//+
Line(19) = {12, 4};
//+
Line(20) = {10, 2};
//+
Line(21) = {9, 1};
//+
Curve Loop(7) = {11, -19, -16, 18};
//+
Plane Surface(7) = {7};
//+
Curve Loop(8) = {15, 18, 1, -20};
//+
Plane Surface(8) = {8};
//+
Curve Loop(9) = {9, -20, -14, 21};
//+
Plane Surface(9) = {9};
//+
Curve Loop(10) = {13, -21, -17, 19};
//+
Plane Surface(10) = {10};
//+
Curve Loop(11) = {15, 16, 17, 14};
//+
Plane Surface(11) = {11};
//+
Surface Loop(1) = {2, 4, 5, 3, 1, 8, 11, 7, 10, 9};
//+
Surface Loop(2) = {6, 2, 4, 5, 3, 1};
//+
Volume(1) = {2};
//+
Surface Loop(3) = {6, 11, 8, 7, 10, 9};
//+
Volume(2) = {3};
//+
Point(13) = {xcen, ycen, 0, pump_refine};
//+
Point(14) = {xcen, ycen+radius, 0, pump_refine};
//+
Point(15) = {xcen, ycen-radius, 0, pump_refine};
//+
Point(16) = {xcen+radius, ycen, 0, pump_refine};
//+
Point(17) = {xcen-radius, ycen, 0, pump_refine};
//+
Point(18) = {xcen, ycen, 0-radius, pump_refine};
//+
Circle(22) = {17, 13, 15};
//+
Circle(23) = {15, 13, 16};
//+
Circle(24) = {16, 13, 14};
//+
Circle(25) = {17, 13, 14};
//+
Circle(26) = {17, 13, 18};
//+
Circle(27) = {15, 13, 18};
//+
Circle(28) = {16, 13, 18};
//+
Circle(29) = {14, 13, 18};
//+
Curve Loop(12) = {22, 23, 24, -25};
//+
Plane Surface(12) = {12};
//+
Curve Loop(13) = {26, -27, -22};
//+
Surface(13) = {13};
//+
Curve Loop(15) = {23, 28, -27};
//+
Surface(14) = {15};
//+
Curve Loop(17) = {24, 29, -28};
//+
Surface(15) = {17};
//+
Curve Loop(19) = {25, 29, -26};
//+
Surface(16) = {19};
//+
Point(19) = {xcen, ycen, dop_thick, pump_refine};
//+
Point(20) = {xcen, ycen+radius, dop_thick, pump_refine};
//+
Point(21) = {xcen, ycen-radius, dop_thick, pump_refine};
//+
Point(22) = {xcen+radius, ycen, dop_thick, pump_refine};
//+
Point(23) = {xcen-radius, ycen, dop_thick, pump_refine};
//+
Circle(30) = {23, 19, 21};
//+
Circle(31) = {21, 19, 22};
//+
Circle(32) = {22, 19, 20};
//+
Circle(33) = {20, 19, 23};
//+
Line(34) = {23, 17};
//+
Line(35) = {21, 15};
//+
Line(36) = {22, 16};
//+
Line(37) = {20, 14};
//+
Curve Loop(21) = {30, 31, 32, 33};
//+
Plane Surface(17) = {21};
//+
Curve Loop(22) = {22, -35, -30, 34};
//+
Surface(18) = {22};
//+
Curve Loop(24) = {35, 23, -36, -31};
//+
Surface(19) = {24};
//+
Curve Loop(26) = {36, 24, -37, -32};
//+
Surface(20) = {26};
//+
Curve Loop(28) = {37, -25, -34, -33};
//+
Surface(21) = {28};
//+
Surface Loop(4) = {12, 13, 14, 15, 16};
//+
Volume(3) = {4};
//+
Surface Loop(5) = {12, 17, 18, 19, 20, 21};
//+
Volume(4) = {5};
//+
Point(24) = {x_left_up, -y_dir, z_left_up, gb_refine};
//+
Point(25) = {x_right_up, -y_dir, z_right_up, gb_refine};
//+
Point(26) = {x_left_up, y_dir, z_left_up,  gb_refine};
//+
Point(27) = {x_right_up, y_dir, z_right_up, gb_refine};
//+
Point(28) = {x_left_down, -y_dir, z_left_down, gb_refine};
//+
Point(29) = {x_right_down, -y_dir, z_right_down, gb_refine};
//+
Point(30) = {x_left_down, y_dir, z_left_down,  gb_refine};
//+
Point(31) = {x_right_down, y_dir, z_right_down, gb_refine};
//+
Line(58) = {24, 28};
//+
Line(59) = {25, 29};
//+
Line(60) = {26, 30};
//+
Line(61) = {27, 31};
//+
Line(62) = {24, 26};
//+
Line(63) = {27, 25};
//+
Line(64) = {28, 30};
//+
Line(65) = {31, 29};
//+
Curve Loop(43) = {58, 64, -60, -62};
//+
Plane Surface(33) = {43};
//+
Curve Loop(44) = {59, -65, -61, 63};
//+
Plane Surface(34) = {44};
//+
Line(66) = {24, 25};
//+
Line(67) = {26, 27};
//+
Line(68) = {28, 29};
//+
Line(69) = {30, 31};
//+
Curve Loop(45) = {66, 62, 67, 63};
//+
Plane Surface(35) = {45};
//+
Curve Loop(47) = {68, -65, -69, -64};
//+
Plane Surface(36) = {47};
//+
Curve Loop(48) = {58, 68, -59, -66};
//+
Plane Surface(37) = {48};
//+
Curve Loop(49) = {60, 69, -61, -67};
//+
Plane Surface(38) = {49};
//+
Surface Loop(6) = {33, 34, 35, 36, 37, 38};
//+
Volume(6) = {6};
//+
Coherence;
