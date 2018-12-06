import CSI 1.0
import "../../Defines"
import "../Common"

Module
{
  id: module
  property string surface:                    "" // e.g. "s2mk3.left"
  property int deckIdx:                       0
  property string propertiesPath:             surface + "." + deckIdx
  readonly property bool shift:               shiftProp.value
  readonly property int bottomDeckIdx:        (deckIdx + 2)
  property bool navigateFavoritesOnShift:     true
  property bool scratchOnTouch:               true

  // Pads Mode //
  MappingPropertyDescriptor { id: padsModeProp; path: propertiesPath + ".pads_mode"; type: MappingPropertyDescriptor.Integer; value: PadsMode.disabled; }

  function updatePadsMode()
  {
    if (topDeckTypeProp.value == DeckType.Remix || (bottomDeckTypeProp.value == DeckType.Remix && topDeckTypeProp.value == DeckType.Live)) 
    {
      padsModeProp.value = PadsMode.remix;
    }
    else if(bottomDeckTypeProp.value != DeckType.Remix ||  padsModeProp.value != PadsMode.remix)
    {
      if (PadsMode.isPadsModeSupported(PadsMode.hotcues, topDeckTypeProp.value))
      {
        padsModeProp.value = PadsMode.hotcues;
      }
      else if (PadsMode.isPadsModeSupported(PadsMode.disabled, topDeckTypeProp.value))
      {
        padsModeProp.value = PadsMode.disabled;
      }
    } 
  }

  function deckTypeSupportsGridAdjust(deckType)
  {
    return deckType == DeckType.Track || deckType == DeckType.Stem;
  }

  // Shift //
  Wire 
  { 
    enabled: PadsMode.isPadsModeSupported(PadsMode.hotcues, topDeckTypeProp.value)
    from: "%surface%.hotcues"; 
    to: SetPropertyAdapter  { path: propertiesPath + ".pads_mode"; value: PadsMode.hotcues }
  }

  Wire 
  { 
    enabled: PadsMode.isPadsModeSupported(PadsMode.remix, topDeckTypeProp.value) || PadsMode.isPadsModeSupported(PadsMode.remix, bottomDeckTypeProp.value)
    from: "%surface%.samples"; 
    to: SetPropertyAdapter  { path: propertiesPath + ".pads_mode"; value: PadsMode.remix }
  }

  // Deck Types //
  AppProperty { id: topDeckTypeProp;       path: "app.traktor.decks." + deckIdx + ".type";       onValueChanged: { updatePadsMode(); } }
  AppProperty { id: bottomDeckTypeProp;    path: "app.traktor.decks." + bottomDeckIdx + ".type"; onValueChanged: { updatePadsMode(); } }

  // Shift //
  MappingPropertyDescriptor { id: shiftProp; path: propertiesPath + ".shift"; type: MappingPropertyDescriptor.Boolean; value: false }
  Wire { from: "%surface%.shift";  to: DirectPropertyAdapter { path: propertiesPath + ".shift"  } }


  // Key Lock //
  Wire
  {
    from: "%surface%.key_lock";  
    to: TogglePropertyAdapter { path: "app.traktor.decks." + deckIdx + ".track.key.lock_enabled" } 
  }

  // Grid Adjust //
  AppProperty { id: enableTick; path: "app.traktor.decks." + module.deckIdx + ".track.grid.enable_tick"; }
  AppProperty { id: gridAdjust; path: "app.traktor.decks." + module.deckIdx + ".track.gridmarker.move"; }
  AppProperty { id: gridLockedProp; path: "app.traktor.decks." + module.deckIdx + ".track.grid.lock_bpm" }

  MappingPropertyDescriptor 
  { 
    id: gridAdjustEnableProp; 
    path: propertiesPath + ".grid_adjust"; 
    type: MappingPropertyDescriptor.Boolean; 
    value: false;
    onValueChanged: { enableTick.value = gridAdjustEnableProp.value; } 
  }

  Wire 
  { 
    enabled: deckTypeSupportsGridAdjust(topDeckTypeProp.value) && !gridLockedProp.value
    from: "%surface%.grid_adjust"; 
    to: HoldPropertyAdapter { path: propertiesPath + ".grid_adjust"; value: true} 
  }

  Wire
  {
    enabled: gridAdjustEnableProp.value; 
    from: "%surface%.jogwheel"; 
    to: EncoderScriptAdapter 
    { 
      onTick: 
      { 
        const minimalTickValue = 0.0035;
        const rotationScaleFactor = 20;
        if (value < -minimalTickValue || value > minimalTickValue)
          gridAdjust.value = value * rotationScaleFactor; 
      }
    }
  }

  //------------------------------------SUBMODULES------------------------------------//

  BrowserModule
  {
    name: "browse"
    surface: module.surface
    deckIdx: module.deckIdx
    shift: shiftProp.value
    navigateFavoritesOnShift: module.navigateFavoritesOnShift
  }

  S2MK3TransportButtons
  {  
    name: "transport"
    surface: module.surface
    deckIdx: module.deckIdx
    shift: shiftProp.value
  }

  S2MK3SamplesModule
  {
    name: "topDeckSamples"
    surface: module.surface
    deckIdx: module.deckIdx
    active: padsModeProp.value == PadsMode.remix && PadsMode.isPadsModeSupported(PadsMode.remix, topDeckTypeProp.value)
    shift: shiftProp.value
  }

  S2MK3SamplesModule
  {
    name: "bottomDeckSamples"
    surface: module.surface
    deckIdx: module.bottomDeckIdx
    active: padsModeProp.value == PadsMode.remix && !PadsMode.isPadsModeSupported(PadsMode.remix, topDeckTypeProp.value)
    shift: shiftProp.value
  }

  HotcuesModule
  {
    name: "hotcues"
    surface: module.surface
    deckIdx: module.deckIdx
    active: padsModeProp.value == PadsMode.hotcues && PadsMode.isPadsModeSupported(PadsMode.hotcues, topDeckTypeProp.value)
    shift: shiftProp.value
  }

  S2MK3TempoControl
  {
    name: "TempoControl"
    surface: module.surface
    deckIdx: module.deckIdx
    shift: module.shift
  }

  // Jogwheel //

  Turntable { name: "turntable"; channel: module.deckIdx }

  WiresGroup {
    enabled: !gridAdjustEnableProp.value
    Wire { from: "%surface%.jogwheel.rotation"; to: "turntable.rotation" }
    Wire { from: "%surface%.jogwheel.speed"; to: "turntable.speed" }
    Wire { from: "%surface%.jogwheel.touch"; to: "turntable.touch"; enabled: scratchOnTouch }
    Wire { from: "%surface%.shift"; to: "turntable.shift" }
  }
  
  // Loop move and size //
  Loop { name: "loop";  channel: module.deckIdx }
  Wire { from: "%surface%.loop_size"; to: "loop.autoloop"}
  Wire { from: "%surface%.loop_move"; to: "loop.move"; enabled: !module.shift}
  Wire { from: "%surface%.loop_move"; to: "loop.one_beat_move"; enabled:  module.shift }

}
