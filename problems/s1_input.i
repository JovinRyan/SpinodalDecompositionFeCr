[GlobalParams]
  block = 0
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  elem_type = QUAD4
  nx = 25
  ny = 25
  xmax = 25
  ymax = 25
  uniform_refine = 2
[]

[Variables]
  [c] #mol fraction of Cr
    order = FIRST
    family = LAGRANGE
  []

  [w] #chemical potential ev/mol
    order = FIRST
    family = LAGRANGE
  []
[]

[AuxVariables]
  [f_density]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [f_density]
    type = TotalFreeEnergy
    variable = f_density
    f_name = 'f_loc'
    kappa_names = 'kappa_c'
    interfacial_vars = c
  []
[]

[ICs]
  [concentrationIC]
    type = RandomIC
    min = 0.44774
    max = 0.48774
    seed = 210
    variable = c
  []
[]

[BCs]
  [Periodic] #Periodic BCs is usually used for phase field models
    [c_bc]
      auto_direction = 'x y'
    []
  []
[]

[Kernels]
  [w_dot]
    variable = w
    v = c
    type = CoupledTimeDerivative
  []

  [coupled_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  []

  [coupled_parsed]
    type = SplitCHParsed
    variable = c
    f_name = f_loc
    kappa_name = kappa_c
    w = w
  []
[]

[Materials]
  [kappa]
    type = GenericFunctionMaterial
    prop_names = 'kappa_c'
    prop_values = '8.125e-16*6.24150934e+18*1e+09^2*1e-27'
  []

  [mobility]
    type = DerivativeParsedMaterial
    property_name = M
    coupled_variables = c
    constant_names = 'Acr    Bcr    Ccr    Dcr
                            Ecr    Fcr    Gcr
                            Afe    Bfe    Cfe    Dfe
                            Efe    Ffe    Gfe
                            nm_m   eV_J   d'
    constant_expressions = '-32.770969 -25.8186669 -3.29612744 17.669757
                            37.6197853 20.6941796  10.8095813
                            -31.687117 -26.0291774 0.2286581   24.3633544
                            44.3334237 8.72990497  20.956768
                            1e+09      6.24150934e+18          1e-27'
    expression = 'nm_m^2/eV_J/d*((1-c)^2*c*10^
                (Acr*c+Bcr*(1-c)+Ccr*c*log(c)+Dcr*(1-c)*log(1-c)+
                Ecr*c*(1-c)+Fcr*c*(1-c)*(2*c-1)+Gcr*c*(1-c)*(2*c-1)^2)
                +c^2*(1-c)*10^
                (Afe*c+Bfe*(1-c)+Cfe*c*log(c)+Dfe*(1-c)*log(1-c)+
                Efe*c*(1-c)+Ffe*c*(1-c)*(2*c-1)+Gfe*c*(1-c)*(2*c-1)^2))'
    derivative_order = 1
    outputs = exodus
  []

  [local_energy]
    type = DerivativeParsedMaterial
    block = 0
    property_name = f_loc
    coupled_variables = c
    constant_names = 'A   B   C   D   E   F   G  eV_J  d'
    constant_expressions = '-2.446831e+04 -2.827533e+04 4.167994e+03 7.052907e+03
                            1.208993e+04 2.568625e+03 -2.354293e+03
                            6.24150934e+18 1e-27'
    expression = 'eV_J*d*(A*c+B*(1-c)+C*c*log(c)+D*(1-c)*log(1-c)+
                E*c*(1-c)+F*c*(1-c)*(2*c-1)+G*c*(1-c)*(2*c-1)^2)'
    derivative_order = 2
  []

  [precipitate_indicator]
    type = ParsedMaterial
    property_name = prec_indic
    coupled_variables = c
    expression = if(c>0.6,0.0016,0)
  []
[]

[Preconditioning]
  [coupled]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  l_max_its = 30
  l_tol = 1e-06
  nl_max_its = 50
  nl_abs_tol = 1e-9
  end_time = 604800 #7 days
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type
                         -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm      31                  preonly
                         ilu          1'

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 10
    cutback_factor = 0.8
    growth_factor = 1.5
    optimal_iterations = 7
  []

  [Adaptivity]
    coarsen_fraction = 0.1
    refine_fraction = 0.7
    max_h_level = 2
  []
[]

[Outputs]
  exodus = true
  console = true
  perf_graph = true
[]

[Postprocessors]
  [evaluations]
    type = NumResidualEvaluations
  []

  [active_time]
    type = PerfGraphData
    section_name = 'Root'
    data_type = TOTAL
  []

  [step_size]
    type = TimestepSize
  []

  [iterations]
    type = NumLinearIterations
  []

  [nodes]
    type = NumNodes
  []

  [precipitate_area]
    type = ElementIntegralMaterialProperty
    mat_prop = prec_indic
  []

  [total_energy]
    type = ElementIntegralVariablePostprocessor
    variable = f_density
  []
[]

[Debug]
  show_var_residual_norms = true
[]
