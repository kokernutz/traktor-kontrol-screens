import CSI 1.0
import QtQuick 2.0
import "../../Screens/Defines"

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
  Wire { from: surface_prefix + "volume";     to: DirectPropertyAdapter { path: app_prefix + "volume"            } }
  Wire { from: surface_prefix + "gain";       to: DirectPropertyAdapter { path: app_prefix + "gain"              } }
  Wire { from: surface_prefix + "eq.high";    to: DirectPropertyAdapter { path: app_prefix + "eq.high"           } }
  Wire { from: surface_prefix + "eq.mid";     to: DirectPropertyAdapter { path: app_prefix + "eq.mid"            } }
  Wire { from: surface_prefix + "eq.low";     to: DirectPropertyAdapter { path: app_prefix + "eq.low"            } }
  Wire { from: surface_prefix + "filter";     to: DirectPropertyAdapter { path: app_prefix + "fx.adjust"         } }
  Wire { from: surface_prefix + "filter_on";  to: DirectPropertyAdapter { path: app_prefix + "fx.on"             } }
  Wire { from: surface_prefix + "cue";        to: DirectPropertyAdapter { path: app_prefix + "cue"               } }

  // level meter
	LEDLevelMeter { name: "meter"; dBThresholds: [-30,-20,-10,-6,-4,-2,0,2,4,6,8] }
	Wire { from: surface_prefix + "levelmeter"; to: "meter" }
	Wire { from: "meter.level"; to: DirectPropertyAdapter { path: app_prefix + "level.prefader.linear.sum" } }

  // xfader assign
  Wire { from: surface_prefix + "xfader_assign.left";  to: DirectPropertyAdapter { path: app_prefix + "xfader_assign.left"   } }
  Wire { from: surface_prefix + "xfader_assign.right"; to: DirectPropertyAdapter { path: app_prefix + "xfader_assign.right"  } }


  // fx Assign

  AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }
  AppProperty { id: mixerFXOn; path: app_prefix + "fx.on" }
  AppProperty { id: mixerFX; path: app_prefix + "fx.select" }

WiresGroup
  {
    enabled: (!channel.shift || (fxMode.value == FxMode.TwoFxUnits)) && !prefs.mixerFXSelector && !prefs.prioritizeFXSelection
    Wire { from: surface_prefix + "fx.assign.1"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.1"; } }
    Wire { from: surface_prefix + "fx.assign.2"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.2"; } }
  }

  WiresGroup
  {
    enabled: (!channel.shift) && prefs.mixerFXSelector && !prefs.prioritizeFXSelection
    Wire { from: surface_prefix + "fx.assign.1"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.1"; } }
    Wire { from: surface_prefix + "fx.assign.2"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.2"; } }
  }

  WiresGroup
  {
    enabled: (!channel.shift) && prefs.mixerFXSelector && prefs.prioritizeFXSelection
    Wire { from: surface_prefix + "fx.assign.1"; to: ButtonScriptAdapter { onRelease: { mixerFX.value = (mixerFX.value + 4) % 5; } } }
    Wire { from: surface_prefix + "fx.assign.2"; to: ButtonScriptAdapter { onRelease: { mixerFX.value = (mixerFX.value + 1) % 5; } } }
  }

  WiresGroup
  {
    enabled: (channel.shift && (fxMode.value == FxMode.FourFxUnits)) && !prefs.mixerFXSelector && !prefs.prioritizeFXSelection
    Wire { from: surface_prefix + "fx.assign.1"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.3"; } }
    Wire { from: surface_prefix + "fx.assign.2"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.4"; } }
  }

  WiresGroup
  {
    enabled: (channel.shift && (!mixerFXOn.value && fxMode.value == FxMode.FourFxUnits)) && prefs.mixerFXSelector && !prefs.prioritizeFXSelection
    Wire { from: surface_prefix + "fx.assign.1"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.3"; } }
    Wire { from: surface_prefix + "fx.assign.2"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.4"; } }
  }

  WiresGroup
  {
    enabled: (channel.shift && (mixerFXOn.value || fxMode.value == FxMode.TwoFxUnits)) && prefs.mixerFXSelector && !prefs.prioritizeFXSelection
    Wire { from: surface_prefix + "fx.assign.1"; to: ButtonScriptAdapter { onRelease: { mixerFX.value = (mixerFX.value + 4) % 5; } } }
    Wire { from: surface_prefix + "fx.assign.2"; to: ButtonScriptAdapter { onRelease: { mixerFX.value = (mixerFX.value + 1) % 5; } } }
  }

  WiresGroup
  {
    enabled: (channel.shift) && prefs.mixerFXSelector && prefs.prioritizeFXSelection
    Wire { from: surface_prefix + "fx.assign.1"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.1"; } }
    Wire { from: surface_prefix + "fx.assign.2"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.2"; } }
  }

  Prefs{
    id:prefs
  }

}
