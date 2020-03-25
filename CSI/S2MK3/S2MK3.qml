import CSI 1.0
import QtQuick 2.0

import "../../Defines"
import "../Common/Settings"

Mapping
{

  S2MK3 { name: "s2mk3" }

  S2MK3Mixer
  {
    name: "mixer"
  }

  S2MK3Deck
  {
    id: left
    name: "left"
    surface: "s2mk3.left"
    propertiesPath: "state.left"
    deckIdx: 1
    navigateFavoritesOnShift: navigateFavoritesOnShiftSetting.value
    scratchOnTouch: scratchOnTouchProp.value
  }

  S2MK3Deck
  {
    id: right
    name: "right"
    surface: "s2mk3.right"
    propertiesPath: "state.right"
    deckIdx: 2
    navigateFavoritesOnShift: navigateFavoritesOnShiftSetting.value
    scratchOnTouch: scratchOnTouchProp.value
  }

  // ----------------- Global Properties ------------------- //

  MappingPropertyDescriptor { path: "mapping.settings.tempo_fader_relative"; type: MappingPropertyDescriptor.Boolean; value: true; }
  MappingPropertyDescriptor { id: scratchOnTouchProp; path: "mapping.settings.scratch_on_touch"; type: MappingPropertyDescriptor.Boolean; value: true; }

  // --- Quant and Snap --- //

  Wire
  {
    from: "s2mk3.global.quant"
    to: TogglePropertyAdapter { path: "app.traktor.snap" } 
    enabled: right.shift || left.shift
  }

  Wire
  {
    from: "s2mk3.global.quant"
    to: TogglePropertyAdapter { path: "app.traktor.quant" } 
    enabled: !(right.shift || left.shift)
  }

  
  // ----------------- Settings Properties ------------------- //

  MappingPropertyDescriptor 
  { 
    id: navigateFavoritesOnShiftSetting;
    path: "mapping.settings.browse_shift_fav_navigation"; 
    type: MappingPropertyDescriptor.Boolean; 
    value: true
  }


} // mapping

