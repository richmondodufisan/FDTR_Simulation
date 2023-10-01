import gmsh
import math
import sys

gmsh.initialize()
gmsh.model.add("FDTR_mesh")

newMeshName = "FDTR_mesh_theta_75_x0_15.msh"

xcen = 15
ycen = 0
radius = 8
dop_thick = 0.09

x_dir = 40
y_dir = 20
z_dir = 40

pump_refine = 0.7
reg_element_refine = 12
gb_refine = 0.4

x_left_up = -.9659258255
x_right_up = .9659258255
z_left_up = 0;
z_right_up = 0;

x_left_down = 40.0;
x_right_down = 40.0;
z_left_down = -10.97678673734355710863
z_right_down = -10.45914864778737569137

# Adding points for base box/substrate, i.e Silicon sample
p1 = gmsh.model.occ.addPoint(x_dir, y_dir, 0, reg_element_refine)
p2 = gmsh.model.occ.addPoint(x_dir, -y_dir, 0, reg_element_refine)
p3 = gmsh.model.occ.addPoint(-x_dir, -y_dir, 0, reg_element_refine)
p4 = gmsh.model.occ.addPoint(-x_dir, y_dir, 0, reg_element_refine)
p5 = gmsh.model.occ.addPoint(-x_dir, y_dir, -z_dir, reg_element_refine/2)
p6 = gmsh.model.occ.addPoint(-x_dir, -y_dir, -z_dir, reg_element_refine/2)
p7 = gmsh.model.occ.addPoint(x_dir, -y_dir, -z_dir, reg_element_refine/2)
p8 = gmsh.model.occ.addPoint(x_dir, y_dir, -z_dir, reg_element_refine/2)

# Adding lines for base box
c1 = gmsh.model.occ.addLine(p3, p2)
c2 = gmsh.model.occ.addLine(p3, p6)
c3 = gmsh.model.occ.addLine(p6, p7)
c4 = gmsh.model.occ.addLine(p7, p2)
c5 = gmsh.model.occ.addLine(p6, p5)
c6 = gmsh.model.occ.addLine(p5, p8)
c7 = gmsh.model.occ.addLine(p8, p7)
c8 = gmsh.model.occ.addLine(p8, p1)
c9 = gmsh.model.occ.addLine(p1, p2)
c10 = gmsh.model.occ.addLine(p3, p4)
c11 = gmsh.model.occ.addLine(p4, p5)
c12 = gmsh.model.occ.addLine(p4, p1)

# Adding Surfaces
cloop1 = gmsh.model.occ.addCurveLoop([c10, c11, c5, c2])
s1 = gmsh.model.occ.addPlaneSurface([cloop1])
cloop2 = gmsh.model.occ.addCurveLoop([c3, c4, -c1, c2])
s2 = gmsh.model.occ.addPlaneSurface([cloop2])
cloop3 = gmsh.model.occ.addCurveLoop([c7, c4, -c9, -c8])
s3 = gmsh.model.occ.addPlaneSurface([cloop3])
cloop4 = gmsh.model.occ.addCurveLoop([c6, c7, -c3, c5])
s4 = gmsh.model.occ.addPlaneSurface([cloop4])
cloop5 = gmsh.model.occ.addCurveLoop([c6, c8, -c12, c11])
s5 = gmsh.model.occ.addPlaneSurface([cloop5])
cloop6 = gmsh.model.occ.addCurveLoop([c1, -c9, -c12, -c10])
s6 = gmsh.model.occ.addPlaneSurface([cloop6])

# Add transducer box
p9 = gmsh.model.occ.addPoint(x_dir, y_dir, dop_thick, reg_element_refine, 9)
p10 = gmsh.model.occ.addPoint(x_dir, -y_dir, dop_thick, reg_element_refine, 10)
p11 = gmsh.model.occ.addPoint(-x_dir, -y_dir, dop_thick, reg_element_refine, 11)
p12 = gmsh.model.occ.addPoint(-x_dir, y_dir, dop_thick, reg_element_refine, 12)

# Add transducer lines
c13 = gmsh.model.occ.addLine(p9, p10)
c14 = gmsh.model.occ.addLine(p10, p11)
c15 = gmsh.model.occ.addLine(p11, p12)
c16 = gmsh.model.occ.addLine(p12, p9)
c17 = gmsh.model.occ.addLine(p11, p3)
c18 = gmsh.model.occ.addLine(p12, p4)
c19 = gmsh.model.occ.addLine(p10, p2)
c20 = gmsh.model.occ.addLine(p9, p1)

# Adding surfaces
cloop7 = gmsh.model.occ.addCurveLoop([c10, c18, c15, c17])
s7 = gmsh.model.occ.addPlaneSurface([cloop7])
cloop8 = gmsh.model.occ.addCurveLoop([c14, c17, c1, c19])
s8 = gmsh.model.occ.addPlaneSurface([cloop8])
cloop9 = gmsh.model.occ.addCurveLoop([c9, c19, c13, c20])
s9 = gmsh.model.occ.addPlaneSurface([cloop9])
cloop10 = gmsh.model.occ.addCurveLoop([c12, c20, c16, c18])
s10 = gmsh.model.occ.addPlaneSurface([cloop10])
cloop11 = gmsh.model.occ.addCurveLoop([c14, c15, c16, c13])
s11 = gmsh.model.occ.addPlaneSurface([cloop11])

# Substrate volume
sloop1 = gmsh.model.occ.addSurfaceLoop([s6, s2, s4, s5, s3, s1])
v1 = gmsh.model.occ.addVolume([sloop1])

# Transducer volume
sloop2 = gmsh.model.occ.addSurfaceLoop([s6, s11, s8, s7, s10, s9])
v2 = gmsh.model.occ.addVolume([sloop2])

# Points for radial refinement dummy volume
p13 = gmsh.model.occ.addPoint(xcen, ycen, 0, dop_thick)
p14 = gmsh.model.occ.addPoint(xcen, ycen+radius, 0, pump_refine)
p15 = gmsh.model.occ.addPoint(xcen, ycen-radius, 0, pump_refine)
p16 = gmsh.model.occ.addPoint(xcen+radius, ycen, 0, pump_refine)
p17 = gmsh.model.occ.addPoint(xcen-radius, ycen, 0, pump_refine)
p18 = gmsh.model.occ.addPoint(xcen, ycen, 0-radius, pump_refine)

# p28 = gmsh.model.occ.addPoint(xcen, ycen+(radius/2), 0, dop_thick)
# p29 = gmsh.model.occ.addPoint(xcen, ycen-(radius/2), 0, dop_thick)
# p30 = gmsh.model.occ.addPoint(xcen+(radius/2), ycen, 0, dop_thick)
# p31 = gmsh.model.occ.addPoint(xcen-(radius/2), ycen, 0, dop_thick)

# Make circle arcs for radial refinement
c21 = gmsh.model.occ.addCircleArc(p17, p13, p15)
c22 = gmsh.model.occ.addCircleArc(p15, p13, p16)
c23 = gmsh.model.occ.addCircleArc(p16, p13, p14)
c24 = gmsh.model.occ.addCircleArc(p17, p13, p14)
c25 = gmsh.model.occ.addCircleArc(p17, p13, p18)
c26 = gmsh.model.occ.addCircleArc(p15, p13, p18)
c27 = gmsh.model.occ.addCircleArc(p16, p13, p18)
c28 = gmsh.model.occ.addCircleArc(p14, p13, p18)

# Make surface loops for semisphere
cloop12 = gmsh.model.occ.addCurveLoop([c21, c22, c23, c24])
s12 = gmsh.model.occ.addPlaneSurface([cloop12])
cloop13 = gmsh.model.occ.addCurveLoop([c25, c26, c21])
s13 = gmsh.model.occ.addSurfaceFilling(cloop13)
cloop14 = gmsh.model.occ.addCurveLoop([c22, c27, c26])
s14 = gmsh.model.occ.addSurfaceFilling(cloop14)
cloop15 = gmsh.model.occ.addCurveLoop([c23, c28, c27])
s15 = gmsh.model.occ.addSurfaceFilling(cloop15)
cloop16 = gmsh.model.occ.addCurveLoop([c24, c28, c25])
s16 = gmsh.model.occ.addSurfaceFilling(cloop16)

# Make semisphere volume
sloop3 = gmsh.model.occ.addSurfaceLoop([s12, s13, s14, s15, s16])
v3 = gmsh.model.occ.addVolume([sloop3])

# Adding points for grain boundary refinement dummy volume
p19 = gmsh.model.occ.addPoint(x_left_up, -y_dir, z_left_up, gb_refine)
p20 = gmsh.model.occ.addPoint(x_right_up, -y_dir, z_right_up, gb_refine)
p21 = gmsh.model.occ.addPoint(x_left_up, y_dir, z_left_up, gb_refine)
p22 = gmsh.model.occ.addPoint(x_right_up, y_dir, z_right_up, gb_refine)
p23 = gmsh.model.occ.addPoint(x_left_down, -y_dir, z_left_down, gb_refine)
p24 = gmsh.model.occ.addPoint(x_right_down, -y_dir, z_right_down, gb_refine)
p25 = gmsh.model.occ.addPoint(x_left_down, y_dir, z_left_down, gb_refine)
p26 = gmsh.model.occ.addPoint(x_right_down, y_dir, z_right_down, gb_refine)

# Adding lines..
c29 = gmsh.model.occ.addLine(p19, p23)
c30 = gmsh.model.occ.addLine(p20, p24)
c31 = gmsh.model.occ.addLine(p21, p25)
c32 = gmsh.model.occ.addLine(p22, p26)
c33 = gmsh.model.occ.addLine(p19, p21)
c34 = gmsh.model.occ.addLine(p22, p20)
c35 = gmsh.model.occ.addLine(p23, p25)
c36 = gmsh.model.occ.addLine(p26, p24)
c37 = gmsh.model.occ.addLine(p19, p20)
c38 = gmsh.model.occ.addLine(p21, p22)
c39 = gmsh.model.occ.addLine(p23, p24)
c40 = gmsh.model.occ.addLine(p25, p26)

# surfaces
cloop17 = gmsh.model.occ.addCurveLoop([c29, c35, c31, c33])
s17 = gmsh.model.occ.addPlaneSurface([cloop17])
cloop18 = gmsh.model.occ.addCurveLoop([c30, c36, c32, c34])
s18 = gmsh.model.occ.addPlaneSurface([cloop18])
cloop19 = gmsh.model.occ.addCurveLoop([c37, c33, c38, c34])
s19 = gmsh.model.occ.addPlaneSurface([cloop19])
cloop20 = gmsh.model.occ.addCurveLoop([c39, c36, c40, c35])
s20 = gmsh.model.occ.addPlaneSurface([cloop20])
cloop21 = gmsh.model.occ.addCurveLoop([c29, c39, c30, c37])
s21 = gmsh.model.occ.addPlaneSurface([cloop21])
cloop22 = gmsh.model.occ.addCurveLoop([c31, c40, c32, c38])
s22 = gmsh.model.occ.addPlaneSurface([cloop22])

# Make grain boundary volume
sloop4 = gmsh.model.occ.addSurfaceLoop([s17, s18, s19, s20, s21])
v4 = gmsh.model.occ.addVolume([sloop4])

# Adding mesh refinement for pump region in transducer
p27 = gmsh.model.occ.addPoint(xcen, ycen, dop_thick, dop_thick)
p28 = gmsh.model.occ.addPoint(xcen, ycen+radius, dop_thick, dop_thick)
p29 = gmsh.model.occ.addPoint(xcen, ycen-radius, dop_thick, dop_thick)
p30 = gmsh.model.occ.addPoint(xcen+radius, ycen, dop_thick, dop_thick)
p31 = gmsh.model.occ.addPoint(xcen-radius, ycen, dop_thick, dop_thick)

# p32 = gmsh.model.occ.addPoint(xcen, ycen+(radius/2), dop_thick, dop_thick)
# p33 = gmsh.model.occ.addPoint(xcen, ycen-(radius/2), dop_thick, dop_thick)
# p34 = gmsh.model.occ.addPoint(xcen+(radius/2), ycen, dop_thick, dop_thick)
# p35 = gmsh.model.occ.addPoint(xcen-(radius/2), ycen, dop_thick, dop_thick)

c41 = gmsh.model.occ.addCircleArc(p31, p27, p29)
c42 = gmsh.model.occ.addCircleArc(p29, p27, p30)
c43 = gmsh.model.occ.addCircleArc(p30, p27, p28)
c44 = gmsh.model.occ.addCircleArc(p28, p27, p31)

c45 = gmsh.model.occ.addLine(p31, p17)
c46 = gmsh.model.occ.addLine(p29, p15)
c47 = gmsh.model.occ.addLine(p30, p16)
c48 = gmsh.model.occ.addLine(p28, p14)

cloop23 = gmsh.model.occ.addCurveLoop([c41, c42, c43, c44])
s23 = gmsh.model.occ.addPlaneSurface([cloop23])
cloop24 = gmsh.model.occ.addCurveLoop([c45, c41, c46, c21])
s24 = gmsh.model.occ.addSurfaceFilling(cloop24)
cloop25 = gmsh.model.occ.addCurveLoop([c46, c42, c47, c22])
s25 = gmsh.model.occ.addSurfaceFilling(cloop25)
cloop26= gmsh.model.occ.addCurveLoop([c47, c43, c48, c23])
s26 = gmsh.model.occ.addSurfaceFilling(cloop26)
cloop27 = gmsh.model.occ.addCurveLoop([c48, c44, c45, c24])
s27 = gmsh.model.occ.addSurfaceFilling(cloop27)

sloop5 = gmsh.model.occ.addSurfaceLoop([s12, s23, s24, s25, s26])
v5 = gmsh.model.occ.addVolume([sloop5])

gmsh.model.occ.removeAllDuplicates()

gmsh.model.occ.synchronize()

# assign mesh size of gb_refine at all points without a mesh size constraint
p = gmsh.model.occ.getEntities(0)
s = gmsh.model.mesh.getSizes(p)
for ps in zip(p, s):
    if ps[1] == 0:
        gmsh.model.mesh.setSize([ps[0]], gb_refine)
   
# Delete extra volume erroneously created by Coherence/removeAllDuplicates()   
volumes = gmsh.model.occ.getEntities(3)
lastVolume = volumes[-1]
gmsh.model.removeEntities([lastVolume], recursive=True)

# More efficient meshing algorithm used when there are multiple subvolumes
gmsh.option.setNumber("Mesh.Algorithm",5)

# Create 3D mesh
gmsh.model.mesh.generate(3)

gmsh.write(newMeshName)

# gmsh.fltk.run()