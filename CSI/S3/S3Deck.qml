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
  property int deckIdx: 0
  property int deckType: deckTypeProp.value
  property bool deckPlaying: deckPlayingProp.value
  property int padsMode: 0
  readonly property var deckColor: Helpers.colorForDeck(module.deckIdx)


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

  //----------------------------------- Grid Adjust------------------------------------//

  // Grid Adjust //
  AppProperty { id: enableTick; path: "app.traktor.decks." + module.deckIdx + ".track.grid.enable_tick" }
  AppProperty { id: gridAdjust; path: "app.traktor.decks." + module.deckIdx + ".track.gridmarker.move" }
  AppProperty { id: gridLockedProp; path: "app.traktor.decks." + module.deckIdx + ".track.grid.lock_bpm" }

  MappingPropertyDescriptor
  {
    id: gridAdjustEnableProp;
    path: deckPropertiesPath + ".grid_adjust";
    type: MappingPropertyDescriptor.Boolean;
    value: false;
    onValueChanged: { enableTick.value = gridAdjustEnableProp.value; }
  }

  Wire
  {
    enabled: module.active && Helpers.deckTypeSupportsGridAdjust(deckTypeProp.value) && !gridLockedProp.value
    from: "%surface%.grid_adjust";
    to: HoldPropertyAdapter { path: deckPropertiesPath + ".grid_adjust"; value: true; color: deckColor }
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

  //-----------------------------------JogWheel------------------------------------//

  // Jogwheel //

  MappingPropertyDescriptor {
    id: jogMode
    path: deckPropertiesPath + ".jog_mode"
    type: MappingPropertyDescriptor.Boolean;
  }

  Wire { from: "%surface%.jog_mode"; to: TogglePropertyAdapter{ path: deckPropertiesPath + ".jog_mode"; color: deckColor } enabled: module.active }

  Turntable { name: "turntable"; channel: module.deckIdx; color: deckColor }

  AppProperty { id: loopActive; path: "app.traktor.decks." + module.deckIdx + ".loop.is_in_active_loop" }

  WiresGroup {
    enabled: !gridAdjustEnableProp.value && module.active
    Wire { from: "%surface%.jogwheel.rotation"; to: "turntable.rotation" }
    Wire { from: "%surface%.jogwheel.speed"; to: "turntable.speed" }
    Wire { from: "%surface%.jogwheel.touch"; to: "turntable.touch"; enabled: !jogMode.value }
    Wire { from: "%surface%.shift"; to: "turntable.shift" }

    WiresGroup
    {
        enabled: !loopActive.value && deckPlaying
        Wire { from: "%surface%.jogwheel_ring.2"; to: "turntable.lights" }
        Wire { from: "%surface%.jogwheel_ring.4"; to: "turntable.lights" }
        Wire { from: "%surface%.jogwheel_ring.6"; to: "turntable.lights" }
        Wire { from: "%surface%.jogwheel_ring.8"; to: "turntable.lights" }
    }

    WiresGroup
    {
        enabled: loopActive.value && deckPlaying
        Wire { from: "%surface%.jogwheel_ring.2"; to: "loop.active" }
        Wire { from: "%surface%.jogwheel_ring.4"; to: "loop.active" }
        Wire { from: "%surface%.jogwheel_ring.6"; to: "loop.active" }
        Wire { from: "%surface%.jogwheel_ring.8"; to: "loop.active" }
    }
  }

  //------------------------------------LOOP-----------------------------------------------//

  Loop { name: "loop"; channel: module.deckIdx; numberOfLeds: 1; color: Color.Green }

  WiresGroup
  {
    enabled: module.active
    Wire { from: "%surface%.loop_size"; to: "loop.autoloop" }
    Wire { from: "%surface%.loop_move"; to: "loop.move"; enabled: !module.shift }
    Wire { from: "%surface%.loop_move"; to: "loop.one_beat_move"; enabled:  module.shift }
  }


  //------------------------------------SUBMODULES------------------------------------------//

  S3Transport
  {
    name: "transport"
    surface: module.surface
    deckIdx: module.deckIdx
    active: module.active
    shift: module.shift
  }

  ExtendedBrowserModule
  {
    name: "browse"
    surface: module.surface
    deckIdx: module.deckIdx
    active: module.active
  }

  HotcuesModule
  {
    name: "hotcues"
    shift: module.shift
    surface: module.surface
    deckIdx:  module.deckIdx
    active: padsMode == PadsMode.hotcues && module.enablePads
  }

  S3Samples
  {
    name: "samples"
    surface: module.surface
    deckIdx: module.deckIdx
    active: padsMode == PadsMode.remix && module.enablePads
    shift: module.shift
  }

}
