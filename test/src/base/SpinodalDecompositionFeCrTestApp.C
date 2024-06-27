//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "SpinodalDecompositionFeCrTestApp.h"
#include "SpinodalDecompositionFeCrApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
SpinodalDecompositionFeCrTestApp::validParams()
{
  InputParameters params = SpinodalDecompositionFeCrApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

SpinodalDecompositionFeCrTestApp::SpinodalDecompositionFeCrTestApp(InputParameters parameters) : MooseApp(parameters)
{
  SpinodalDecompositionFeCrTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

SpinodalDecompositionFeCrTestApp::~SpinodalDecompositionFeCrTestApp() {}

void
SpinodalDecompositionFeCrTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  SpinodalDecompositionFeCrApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"SpinodalDecompositionFeCrTestApp"});
    Registry::registerActionsTo(af, {"SpinodalDecompositionFeCrTestApp"});
  }
}

void
SpinodalDecompositionFeCrTestApp::registerApps()
{
  registerApp(SpinodalDecompositionFeCrApp);
  registerApp(SpinodalDecompositionFeCrTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
SpinodalDecompositionFeCrTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  SpinodalDecompositionFeCrTestApp::registerAll(f, af, s);
}
extern "C" void
SpinodalDecompositionFeCrTestApp__registerApps()
{
  SpinodalDecompositionFeCrTestApp::registerApps();
}
