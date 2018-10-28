import CSI 1.0

Module
{
  id: module
  property string surface_prefix: "s4mk3.left"
  property int fxUnit: 1

  FxUnit { name: "adapter"; channel: fxUnit }

  // knobs
  Wire { from: "%surface_prefix%.fx.knobs.1"; to: "adapter.dry_wet" }
  Wire { from: "%surface_prefix%.fx.knobs.2"; to: "adapter.knob1" }
  Wire { from: "%surface_prefix%.fx.knobs.3"; to: "adapter.knob2" }
  Wire { from: "%surface_prefix%.fx.knobs.4"; to: "adapter.knob3" }

  // buttons
  Wire { from: "%surface_prefix%.fx.buttons.1"; to: "adapter.enabled" }
  Wire { from: "%surface_prefix%.fx.buttons.2"; to: "adapter.button1" }
  Wire { from: "%surface_prefix%.fx.buttons.3"; to: "adapter.button2" }
  Wire { from: "%surface_prefix%.fx.buttons.4"; to: "adapter.button3" }

}
