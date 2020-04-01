import CSI 1.0
import "../../Defines"
import "../Common"
import "../Common/DeckHelpers.js" as Helpers

Module
{
  id: module
  property bool active: false
  property bool enablePads: false
  property bool shift: false
  property string surface: ""
  property string deckPropertiesPath: ""
  property int padsMode: 0
  property int deckIdx: 0
  property int deckType: deckTypeProp.value
  property bool deckPlaying: deckPlayingProp.value
  property bool isEncoderInUse: samples.isSlotSelected || stems.isStemSelected
  property bool isLinkedDeckEncoderInUse: false
  property var deckColor: Helpers.colorForDeck(deckIdx)
  property bool hapticHotcuesEnabled: true

  MappingPropertyDescriptor {
    id: deckColorProp
    path: deckPropertiesPath + ".deck_color"
    type: MappingPropertyDescriptor.Integer
    value: module.deckColor
  }

  AppProperty
  {
    id: deckTypeProp;
    path: "app.traktor.decks." + deckIdx + ".type";
  }

  AppProperty
  {
    id: deckPlayingProp;
    path: "app.traktor.decks." + deckIdx + ".play";
  }

  AppProperty { id: gridAdjust; path: "app.traktor.decks." + module.deckIdx + ".track.gridmarker.move" ; }
  AppProperty { id: enableTick; path: "app.traktor.decks." + module.deckIdx + ".track.grid.enable_tick"; }
  AppProperty { id: gridLockedProp; path: "app.traktor.decks." + module.deckIdx + ".track.grid.lock_bpm" }

  MappingPropertyDescriptor 
  { 
    id: gridAdjustEnableProp; 
    path: deckPropertiesPath + ".grid_adjust"; 
    type: MappingPropertyDescriptor.Boolean; 
    value: false;
    onValueChanged: { enableTick.value = gridAdjustEnableProp.value; } 
  }

  //----------------------------------- Grid Adjust------------------------------------//

  readonly property bool gridAdjustAvailable: module.active
                                              && jogMode.value === JogwheelMode.Jogwheel
                                              && Helpers.deckTypeSupportsGridAdjust(deckType)
                                              && !gridLockedProp.value;

  Wire
  { 
    enabled: gridAdjustAvailable;
    from: "%surface%.grid_adjust"; 
    to: HoldPropertyAdapter { path: deckPropertiesPath + ".grid_adjust"; value: true; color: module.deckColor }
  }

  Wire
  {
    enabled: gridAdjustAvailable && gridAdjustEnableProp.value;
    from: "%surface%.jogwheel.rotation"; 
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
  
  //-----------------------------------JogWheel------------------------------------//


  MappingPropertyDescriptor {
    id: jogMode
    path: deckPropertiesPath + ".jog_mode"
    type: MappingPropertyDescriptor.Integer
  }

  Turntable
  {
      name: "turntable"
      channel: module.deckIdx
  }

  WiresGroup
  {
      enabled: module.active

      Wire
      {
          from: "%surface%.jogwheel"
          to: "turntable"
          enabled: !gridAdjustEnableProp.value
      }
      
      Wire { from: "%surface%.jogwheel.mode";     to: "turntable.mode"     }
      Wire { from: "%surface%.jogwheel.mode";     to: DirectPropertyAdapter { path: deckPropertiesPath + ".jog_mode" }    }
      Wire { from: "%surface%.jogwheel.pitch";    to: "turntable.pitch"    }
      Wire { from: "%surface%.shift";             to: "turntable.shift"    }
      Wire { from: "%surface%.jogwheel.timeline"; to: "turntable.timeline"; enabled: module.hapticHotcuesEnabled }

      Wire
      {
          from: DirectPropertyAdapter { path: "app.traktor.decks." + deckIdx + ".play" }
          to: "%surface%.jogwheel.motor_on"
          // motor_on is currenty also used to tell the HWS if taktor is playing in Jog Mode.
      }


      Wire {
          from: "%surface%.play";
          to: "%surface%.jogwheel.motor_off";
          enabled: module.shift && deckPlaying
      }

      //Wire { from: "%surface%.jogwheel.motor_on"; to: "turntable.motor_on" }

      Wire {
        from: "%surface%.jogwheel.haptic_ticks"
        to: DirectPropertyAdapter { path: "mapping.settings.haptic.ticks_density"; input: false }
        enabled: (jogMode.value === JogwheelMode.Jogwheel || jogMode.value === JogwheelMode.CDJ) && !module.shift
      }

      Wire
      {
          from: DirectPropertyAdapter { path: deckPropertiesPath + ".deck_color"; input: false }
          to: "%surface%.jogwheel.led_color"
      }

      Wire
      {
          from: "%surface%.pitch.fader"
          to: "%surface%.jogwheel.tempo"
      }

      Wire
      {
          from: "%surface%.jogwheel.platter_speed"
          to:   DirectPropertyAdapter{ path: "mapping.settings.haptic.platter_speed"; input: false}
      }
  }

  //------------------------------------Key lock and adjust------------------------------------//
 
  KeyControl { name: "key_control"; channel: deckIdx }
  Wire { from: "%surface%.loop_size";  to: "key_control.coarse"; enabled: module.shift && module.active }

  //------------------------------------LOOP-----------------------------------------------//
  
  Loop { name: "loop";  channel: deckIdx }

  WiresGroup
  {
    // only enable loop control when the deck is in focus and no stem or slot is selected for either deck.
    enabled: module.active && !module.isEncoderInUse && !module.isLinkedDeckEncoderInUse

    WiresGroup
    {
      enabled: !module.shift
      Wire { from: "%surface%.loop_size"; to: "loop.autoloop"; }
      Wire { from: "%surface%.loop_move"; to: "loop.move";     }
    }
  
    Wire { from: "%surface%.loop_move"; to: "loop.one_beat_move"; enabled:  module.shift }
  }

  //------------------------------------SUBMODULES------------------------------------------//

  HotcuesModule
  {
    name: "hotcues"
    shift: module.shift
    surface: module.surface
    deckIdx:  module.deckIdx
    active: padsMode == PadsMode.hotcues && module.enablePads
  }

  S4MK3Stems
  {  
    id: stems
    name: "stems"
    surface: module.surface
    deckPropertiesPath: module.deckPropertiesPath
    deckIdx: module.deckIdx
    active: padsMode == PadsMode.stems && module.enablePads
    shift: module.shift
  }

  S4MK3Samples
  {  
    id: samples
    name: "samples"
    shift: module.shift
    surface: module.surface
    deckPropertiesPath: module.deckPropertiesPath
    deckIdx: module.deckIdx
    active: padsMode == PadsMode.remix && module.enablePads
  }

  S4MK3TransportButtons
  {  
    name: "transport"
    surface: module.surface
    deckIdx: module.deckIdx
    active: module.active
    shift: module.shift
  }

  S4MK3TempoControl
  {
    name: "TempoControl"
    surface: module.surface
    deckIdx: module.deckIdx
    active: module.active
    shift: module.shift
    canLock: jogMode.value != JogwheelMode.Turntable
  }

  ExtendedBrowserModule
  {
    name: "browse"
    surface: module.surface
    deckIdx: module.deckIdx
    active: module.active && !samples.isSlotSelected && !module.isLinkedDeckEncoderInUse
  }
}
