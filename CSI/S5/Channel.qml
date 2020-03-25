import CSI 1.0

Module
{
  // input
  id: channel
  property int number:     1
	property string surface: ""
  property bool shift:     false

  // helpers
  property string surface_prefix:  channel.surface + "." + channel.number + "." 
  property string app_prefix:      "app.traktor.mixer.channels." + channel.number + "."

  // channel strip
  Wire { from: surface_prefix + "volume";     to: DirectPropertyAdapter { path: app_prefix + "volume"    } }
  Wire { from: surface_prefix + "gain";       to: DirectPropertyAdapter { path: app_prefix + "gain"      } }
  Wire { from: surface_prefix + "eq.high";    to: DirectPropertyAdapter { path: app_prefix + "eq.high"   } }
  Wire { from: surface_prefix + "eq.mid";     to: DirectPropertyAdapter { path: app_prefix + "eq.mid"    } }
  Wire { from: surface_prefix + "eq.low";     to: DirectPropertyAdapter { path: app_prefix + "eq.low"    } }
  Wire { from: surface_prefix + "filter";     to: DirectPropertyAdapter { path: app_prefix + "fx.adjust" } }
  Wire { from: surface_prefix + "filter_on";  to: TogglePropertyAdapter { path: app_prefix + "fx.on"     } }
  Wire { from: surface_prefix + "cue";        to: TogglePropertyAdapter { path: app_prefix + "cue"       } }

  // level meter
	LEDLevelMeter { name: "meter"; dBThresholds: [-30,-20,-10,-6,-4,-2,0,2,4,6,8] }
	Wire { from: surface_prefix + "levelmeter"; to: "meter" }
	Wire { from: "meter.level"; to: DirectPropertyAdapter { path: app_prefix + "level.prefader.linear.sum"; input: false } }

  // fx Assign

  AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }

  WiresGroup
  {
    enabled: !channel.shift || (fxMode.value == FxMode.TwoFxUnits)
    Wire { from: surface_prefix + "fx.assign.1"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.1"; } }
    Wire { from: surface_prefix + "fx.assign.2"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.2"; } }
  }

  WiresGroup
  {
    enabled: channel.shift && (fxMode.value == FxMode.FourFxUnits)
    Wire { from: surface_prefix + "fx.assign.1"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.3"; } }
    Wire { from: surface_prefix + "fx.assign.2"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.4"; } }
  }

}
