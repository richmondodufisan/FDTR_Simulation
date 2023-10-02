#Global Parameters
x0_val = 0
y0_val = 0
freq_val = 1e6
dphase = 0.2
tp = 1

dop_thick = 0.09

theta_deg = 0
theta_rad = ${fparse (theta_deg/180)*pi}

period = ${fparse 1/freq_val}

dt_val = ${fparse 5.0*(dphase/360.0)*period*tp}
t_val = ${fparse 2.2*period*tp*1}

[Mesh]
  [sample_mesh]
    type = FileMeshGenerator
    file = FDTR_mesh.msh
  []
  [sample_block]
    type = SubdomainBoundingBoxGenerator
    input = sample_mesh
    block_id = 1
    top_right = '40 20 0'
    bottom_left = '-40 -20 -40'
  []
  [doping_block]
    type = SubdomainBoundingBoxGenerator
    input = sample_block
    block_id = 2	
    top_right = '40 20 ${dop_thick}'
    bottom_left = '-40 -20 0'
  []
  
  [rename]
    type = RenameBlockGenerator
    old_block = '1 2'
    new_block = 'sample_material doping_material'
    input = doping_block
  []
  
  [applied_pump_area]
    type = ParsedGenerateSideset
	input = rename
	combinatorial_geometry = '(z > ${dop_thick}-1e-8) & (z < ${dop_thick}+1e-8) & (((x-x0)^2 + (y-y0)^2)< 64)'
	constant_names = 'x0 y0'
	constant_expressions = '${x0_val} ${y0_val}'
	new_sideset_name = top_pump_area
  []
  
  [top_no_pump]
    type = ParsedGenerateSideset
	input = applied_pump_area
	combinatorial_geometry = '(z > ${dop_thick}-1e-8) & (z < ${dop_thick}+1e-8) & (((x-x0)^2 + (y-y0)^2) >= 64)'
	constant_names = 'x0 y0'
	constant_expressions = '${x0_val} ${y0_val}'
	new_sideset_name = top_no_pump_area
  []
  
  [conductance_area]	
    type = SideSetsBetweenSubdomainsGenerator
    input = top_no_pump
    primary_block = doping_material
    paired_block = sample_material
    new_boundary = 'boundary_conductance'
  []
    
  [bottom_area]
    type = ParsedGenerateSideset
	input = conductance_area
	combinatorial_geometry = '((z > -40-1e-8) & (z < -40+1e-8))'
	new_sideset_name = bottom_surface
  []
  
  [side_areas]
    type = ParsedGenerateSideset
	input = bottom_area
	combinatorial_geometry = '((x > -40-1e-8) & (x < -40+1e-8)) | ((x > 40-1e-8) & (x < 40+1e-8)) | ((y > -20-1e-8) & (y < -20+1e-8)) | ((y > 20-1e-8) & (y < 20+1e-8))'
	new_sideset_name = side_surfaces
  []
[]

[Variables]
  [temp_dop]
    order = FIRST
    family = LAGRANGE
	block = doping_material
  []
  [temp_samp]
    order = FIRST
    family = LAGRANGE
	block = sample_material
  []
[]

[Kernels]
  [heat_conduction_doping]
    type = ADHeatConduction
    variable = temp_dop
	thermal_conductivity = k_dope
	block = doping_material
  []
  [heat_conduction_sample]
    type = ADHeatConduction
    variable = temp_samp
	thermal_conductivity = k_samp
	block = sample_material
  []
  [heat_conduction_time_dep_doping]
    type = ADHeatConductionTimeDerivative
    variable = temp_dop
	density_name = rho_dope
	specific_heat = c_dope
	block = doping_material
  []
  [heat_conduction_time_dep_sample]
    type = ADHeatConductionTimeDerivative
    variable = temp_samp
	density_name = rho_samp
	specific_heat = c_samp
	block = sample_material
  []
[]

[InterfaceKernels]
  [gap_01]
    type = SideSetHeatTransferKernel
    variable = temp_dop
    neighbor_var = temp_samp
    boundary = 'boundary_conductance'
	conductance = 3e-5
	
	Tbulk_mat = 0
	h_primary = 0
	h_neighbor = 0
	emissivity_eff_primary = 0
	emissivity_eff_neighbor = 0
  []
[]

[AuxVariables]
  [avg_surf_temp]
  []
  [bulk_gb_dist]
    order = FIRST
    family = MONOMIAL
  []
[]

[AuxKernels]
  [average_surface_temperature]
    type = ParsedAux
    variable = avg_surf_temp
    coupled_variables = 'temp_dop'
	constant_names = 'x0 y0 Rprobe T0 pi'
	constant_expressions = '${x0_val} ${y0_val} 1.34 293.15 3.14159265359'
	use_xyzt = true
	expression = '((temp_dop-T0)/(pi*(Rprobe^2)))*exp((-((x-x0)^2+(y-y0)^2))/(Rprobe^2))'
	block = doping_material
  []
  [visualize_gb]
    type = ADMaterialRealAux
	variable = bulk_gb_dist
	property = k_samp
	block = sample_material
  []
[]

[Postprocessors]
  [integral]
    type = SideIntegralVariablePostprocessor
    boundary = 'top_pump_area'
    variable = avg_surf_temp
  []
[]

[Functions]
  [heat_source_function]
    type = ADParsedFunction
    expression = '((((Q0*absorbance)/(pi*(Rpump^2)))*exp((-((x-x0)^2+(y-y0)^2))/(Rpump^2)))*0.5*(1-cos((2*pi*freq*t))))'
    symbol_names = 'x0 y0 Rpump Q0 absorbance freq'
    symbol_values = '${x0_val} ${y0_val} 1.53 0.01 1 ${freq_val}'
  []
  [grain_boundary_function]
    type = ADParsedFunction
	expression = 'if ( (x<((-gb_width/(2*cos(theta)))+(abs(z)*tan(theta)))) | (x>((gb_width/(2*cos(theta)))+(abs(z)*tan(theta)))), k_bulk, k_gb)'
	symbol_names = 'gb_width theta k_bulk k_gb'
	symbol_values = '0.1 ${theta_rad} 130e-6 56.52e-6'
  []
[]

[Materials]
  [basic_doping_materials]
    type = ADGenericConstantMaterial
    block = doping_material
    prop_names = 'rho_dope c_dope k_dope'
    prop_values = '19.3e-15 0.1287e3 215e-6'
  []
  [basic_sample_materials]
    type = ADGenericConstantMaterial
    block = sample_material
    prop_names = 'rho_samp c_samp'
    prop_values = '2.329e-15 0.6891e3'
  []
  [thermal_conductivity_sample]
    type = ADGenericFunctionMaterial
    prop_names = k_samp
    prop_values = grain_boundary_function
	block = sample_material
  []
  [heat_source_material]
    type = ADGenericFunctionMaterial
    prop_names = heat_source_mat
    prop_values = heat_source_function
  []
[]

[BCs]
  [ambient_temperature]
    type = DirichletBC
    variable = temp_samp
    boundary = 'bottom_surface'
    value = 293.15
  []
  [heat_source_term]
    type = FunctionNeumannBC
	variable = temp_dop
	boundary = 'top_pump_area top_no_pump_area'
	function = heat_source_function
  []
[]

[ICs]
  [initial_temperature_sample]
    type = ConstantIC
	variable = temp_samp
	value = 293.15
	block = sample_material
  []
  [initial_temperature_doping]
    type = ConstantIC
	variable = temp_dop
	value = 293.15
	block = doping_material
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type   -pc_hypre_type    -ksp_type     -ksp_gmres_restart  -pc_hypre_boomeramg_strong_threshold -pc_hypre_boomeramg_agg_nl -pc_hypre_boomeramg_agg_num_paths -pc_hypre_boomeramg_max_levels -pc_hypre_boomeramg_coarsen_type -pc_hypre_boomeramg_interp_type -pc_hypre_boomeramg_P_max -pc_hypre_boomeramg_truncfactor'
  petsc_options_value = 'hypre      boomeramg         gmres         301                  0.6                                  4                          5                                 25                             Falgout                          ext+i                           1                         0.3'

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  l_tol = 1e-5
  l_max_its = 300
  nl_max_its = 20

  line_search = 'none'

  automatic_scaling=true
  compute_scaling_once =true
  verbose=false

  dtmin = ${dt_val}
  dtmax= ${dt_val}
  
  start_time = 0.0
  end_time = ${t_val}
   
  [TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 15
    iteration_window = 3
    linear_iteration_ratio = 100
    growth_factor=1.5
    cutback_factor=0.5
    dt = ${dt_val}
  []
  [Predictor]
    type = SimplePredictor
    scale = 1.0
    skip_after_failed_timestep = true
  []
[] 

[Outputs]
  interval = 1
  #execute_on = 'initial timestep_end'
  print_linear_residuals = false
  csv = true
  exodus = false
  [pgraph]
    type = PerfGraphOutput
    execute_on = 'final'  # Default is "final"
    level = 1             # Default is 1
  []
[]
