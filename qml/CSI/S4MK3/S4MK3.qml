import CSI 1.0
import QtQuick 2.0

import "../../Defines"
import "../Common/Settings"


Mapping
{
  S4MK3 { name: "s4mk3" }

  // ----------------- Global Properties ------------------- //
  
  MappingPropertyDescriptor 
  { 
    id: navigateFavoritesOnShiftSetting;
    path: "mapping.settings.browse_shift_fav_navigation"; 
    type: MappingPropertyDescriptor.Boolean; 
    value: true
  }

  MappingPropertyDescriptor
  {
    id: ttmodeRpm
    path: "mapping.settings.haptic.platter_speed"
    type: MappingPropertyDescriptor.Integer
    value: 0
  }

  MappingPropertyDescriptor { path: "mapping.settings.tempo_fader_relative"; type: MappingPropertyDescriptor.Boolean; value: true; }
  
  MappingPropertyDescriptor { path: "mapping.settings.haptic.ticks_density"; type: MappingPropertyDescriptor.Integer; value: 1; min: 0; max: 2 }

  MappingPropertyDescriptor { path: "mapping.settings.haptic.tension"; type: MappingPropertyDescriptor.Integer; min: 0; max: 255 }

  Wire { from: "s4mk3.jogwheel.tension"; to: DirectPropertyAdapter { path: "mapping.settings.haptic.tension" } }


  // ----------------- Mapping Modules ------------------- //

  S4MK3Mixer
  {
    name: "mixer"
    shift: left.shift.value || right.shift.value
  }

  S4MK3Side
  {
    id: left
    name: "left"
    surface: "s4mk3.left"
    propertiesPath: "mapping.state.left"
    topDeckIdx: 1
    bottomDeckIdx: 3
    navigateFavoritesOnShift: navigateFavoritesOnShiftSetting.value 
  }

  S4MK3Side
  {
    id: right
    name: "right"
    surface: "s4mk3.right"
    propertiesPath: "mapping.state.right"
    topDeckIdx: 2
    bottomDeckIdx: 4
    navigateFavoritesOnShift: navigateFavoritesOnShiftSetting.value 
  }

  S4MK3DeckFX
  {
      name: "fx1"
      surface_prefix: "s4mk3.left"
      fxUnit: 1
  }

  S4MK3DeckFX
  {
      name: "fx2"
      surface_prefix: "s4mk3.right"
      fxUnit: 2
  }

} // mapping

