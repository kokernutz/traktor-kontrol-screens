import CSI 1.0
import QtQuick 2.5
import "../../Defines"

Module
{
  id: module
  property bool shift: false 
  property string surface: ""
  property int deckIdx: 0
  property bool active: false
  property string deckPropertiesPath: ""
  property bool isSlotSelected: (module.active && propActiveSlot.value != 0)

  RemixTrigger { name: "triggering"; channel: deckIdx; target: RemixTrigger.StepSequencer }
  RemixMixing { name: "mixing"; channel: deckIdx }

  MappingPropertyDescriptor { id: mute ; path: deckPropertiesPath + ".mute"; type: MappingPropertyDescriptor.Boolean; value: false}
  MappingPropertyDescriptor { id: propActiveSlot; path: deckPropertiesPath + ".active_slot"; 
                              type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 4 }
  MappingPropertyDescriptor { id: propSampleBrowsing; path: deckPropertiesPath + ".sample_browsing";
                              type: MappingPropertyDescriptor.Boolean; value: false }

  Timer 
  {
    id: sample_browsing_countdown;
    interval: 500;
    onTriggered: { propSampleBrowsing.value = false; }
  }

  function playerPath(playerId)
  {
    return "app.traktor.decks." + module.deckIdx + ".remix.players." + playerId;
  }

  Wire { from: "%surface%.mute"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".mute"; value: true  } }

  WiresGroup
  {
    enabled: active

    // Mute + pad to mute column
    WiresGroup
    {
      enabled: mute.value

      Wire { from: "%surface%.pads.1"; to: "mixing.1.mute" } 
      Wire { from: "%surface%.pads.2"; to: "mixing.2.mute" }
      Wire { from: "%surface%.pads.3"; to: "mixing.3.mute" }
      Wire { from: "%surface%.pads.4"; to: "mixing.4.mute" }
    }

    WiresGroup
    {
      enabled: !mute.value


      WiresGroup
      {
        enabled: !module.shift
        
        Wire { from: "%surface%.pads.1"; to: "triggering.1.trigger" } 
        Wire { from: "%surface%.pads.2"; to: "triggering.2.trigger" }
        Wire { from: "%surface%.pads.3"; to: "triggering.3.trigger" }
        Wire { from: "%surface%.pads.4"; to: "triggering.4.trigger" }
      }

      WiresGroup
      {
        enabled: module.shift
        
        Wire { from: "%surface%.pads.1"; to: "triggering.1.stop" } 
        Wire { from: "%surface%.pads.2"; to: "triggering.2.stop" }
        Wire { from: "%surface%.pads.3"; to: "triggering.3.stop" }
        Wire { from: "%surface%.pads.4"; to: "triggering.4.stop" }

        Wire { from: "%surface%.pads.1"; to: InvokeActionAdapter { path: playerPath(1) + ".sequencer.delete_pattern"; } } 
        Wire { from: "%surface%.pads.2"; to: InvokeActionAdapter { path: playerPath(2) + ".sequencer.delete_pattern"; } } 
        Wire { from: "%surface%.pads.3"; to: InvokeActionAdapter { path: playerPath(3) + ".sequencer.delete_pattern"; } } 
        Wire { from: "%surface%.pads.4"; to: InvokeActionAdapter { path: playerPath(4) + ".sequencer.delete_pattern"; } } 
      }
    }

    WiresGroup
    {
      enabled: module.shift && propActiveSlot.value == 0

      Wire { from: "%surface%.loop_size.push";  to: TogglePropertyAdapter  { path: "app.traktor.decks." + deckIdx + ".remix.quant" } }
      Wire { from: "%surface%.loop_size.turn";  to: RelativePropertyAdapter { path:"app.traktor.decks." + deckIdx + ".remix.quant_index"; mode: RelativeMode.Stepped } }
    }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.record"; to: TogglePropertyAdapter  { path: "app.traktor.decks." + deckIdx + ".remix.sequencer.rec.on" } }
      Wire { from: "%surface%.record"; to: SetPropertyAdapter     { path: "app.traktor.decks." + deckIdx + ".remix.sequencer.on"; value: true; output: false }}

      WiresGroup
      {
        enabled: propActiveSlot.value == 1
        
        Wire { from: "%surface%.loop_move";       to: "mixing.1.volume" }
        Wire { from: "%surface%.loop_size";       to: "mixing.1.filter" }
        Wire { from: "%surface%.browse.encoder";  to: "triggering.1.selected_cell"; enabled: propSampleBrowsing.value }
      }

      WiresGroup
      {
        enabled: propActiveSlot.value == 2
        
        Wire { from: "%surface%.loop_move";       to: "mixing.2.volume" }
        Wire { from: "%surface%.loop_size";       to: "mixing.2.filter" }
        Wire { from: "%surface%.browse.encoder";  to: "triggering.2.selected_cell"; enabled: propSampleBrowsing.value }
      }

      WiresGroup
      {
        enabled: propActiveSlot.value == 3
        
        Wire { from: "%surface%.loop_move";       to: "mixing.3.volume" }
        Wire { from: "%surface%.loop_size";       to: "mixing.3.filter" }
        Wire { from: "%surface%.browse.encoder";  to: "triggering.3.selected_cell"; enabled: propSampleBrowsing.value }
      }

      WiresGroup
      {
        enabled: propActiveSlot.value == 4
        
        Wire { from: "%surface%.loop_move";       to: "mixing.4.volume" }
        Wire { from: "%surface%.loop_size";       to: "mixing.4.filter" }
        Wire { from: "%surface%.browse.encoder";  to: "triggering.4.selected_cell"; enabled: propSampleBrowsing.value }
      }

      Wire
      {
        enabled: propActiveSlot.value != 0
        from: Or
        {
          inputs:
          [
            "%surface%.browse.encoder.push",
            "%surface%.browse.encoder.is_turned",
          ]
        }
        to: ButtonScriptAdapter{
            onPress:
            {
              sample_browsing_countdown.stop();
              propSampleBrowsing.value = true;
            }
            onRelease:
            {
              sample_browsing_countdown.restart();
            }
        }
      }
    }

    //------------------------- Lower pads to slot focus ---------------------------

    Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".active_slot"; value: 1; defaultValue: 0 } }
    Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".active_slot"; value: 2; defaultValue: 0 } }
    Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".active_slot"; value: 3; defaultValue: 0 } }
    Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".active_slot"; value: 4; defaultValue: 0 } }
  }

}
