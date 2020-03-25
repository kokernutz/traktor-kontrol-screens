import CSI 1.0

Module
{
  property string surfaceObject: "path"
  property string propertiesPath: "path"

  SoftTakeover { name: "module" }
  SwitchTimer  { name: "actiontimer";  resetTimeout: 20 }
  Or           { name: "action";   inputs: [ "actiontimer.output", "%surfaceObject%.touch" ] }
  And          { name: "indicate"; inputs: [ "action", "module.active" ] }

  MappingPropertyDescriptor { path: propertiesPath + ".active";  type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: propertiesPath + ".input";   type: MappingPropertyDescriptor.Float;   value: 0.0   }
  MappingPropertyDescriptor { path: propertiesPath + ".output";  type: MappingPropertyDescriptor.Float;   value: 0.0   }

  Wire { from: surfaceObject; to: "module.input" }
  Wire { from: surfaceObject; to: "actiontimer.input" }
  Wire { from: "module.active";          to: DirectPropertyAdapter { path: propertiesPath + ".active" } }
  Wire { from: "module.input_monitor";   to: DirectPropertyAdapter { path: propertiesPath + ".input"  } }
  Wire { from: "module.output_monitor";  to: DirectPropertyAdapter { path: propertiesPath + ".output" } }
}

