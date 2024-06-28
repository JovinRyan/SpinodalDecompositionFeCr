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
  [constants]
    type = GenericFunctionMaterial
    block = 0
    prop_names = 'kappa_c M'
    prop_values = '8.125e-16*6.24150934e+18*1e+09^2*1e-27
                   2.2841e-26*1e+09^2/6.24150934e+18/1e-27'
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
[]

[Debug]
  show_var_residual_norms = true
[]
