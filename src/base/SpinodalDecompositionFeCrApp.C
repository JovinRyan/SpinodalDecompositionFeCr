#include "SpinodalDecompositionFeCrApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
SpinodalDecompositionFeCrApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

SpinodalDecompositionFeCrApp::SpinodalDecompositionFeCrApp(InputParameters parameters) : MooseApp(parameters)
{
  SpinodalDecompositionFeCrApp::registerAll(_factory, _action_factory, _syntax);
}

SpinodalDecompositionFeCrApp::~SpinodalDecompositionFeCrApp() {}

void
SpinodalDecompositionFeCrApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<SpinodalDecompositionFeCrApp>(f, af, s);
  Registry::registerObjectsTo(f, {"SpinodalDecompositionFeCrApp"});
  Registry::registerActionsTo(af, {"SpinodalDecompositionFeCrApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
SpinodalDecompositionFeCrApp::registerApps()
{
  registerApp(SpinodalDecompositionFeCrApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
SpinodalDecompositionFeCrApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  SpinodalDecompositionFeCrApp::registerAll(f, af, s);
}
extern "C" void
SpinodalDecompositionFeCrApp__registerApps()
{
  SpinodalDecompositionFeCrApp::registerApps();
}
