import CSI 1.0

Module
{
  id: module
  property bool shift: false
  property bool active: false
  property int deckIdx: 0
  property string surface: ""

  property int nudgePushAction: 0
  property int nudgeShiftPushAction: 0

  // Nudge buttons actions
  readonly property int nudgeTempoBend: 0
  readonly property int nudgeBeatjump:  1

  TransportSection
  {
    name: "transport"
    channel: module.deckIdx

    syncColor: Color.Blue
    fluxColor: Color.Blue
    masterColor: Color.Blue
  }

  AppProperty { id: deckIsLoaded; path: "app.traktor.decks." + deckIdx + ".is_loaded" }

  Beatgrid        { name: "beatgrid";   channel: module.deckIdx }
  ButtonBeatjump  { name: "beatjump";   channel: module.deckIdx }
  ButtonTempoBend { name: "tempo_bend"; channel: module.deckIdx }

  SwitchTrigger { name: "sync_inverter" }
  
  WiresGroup
  { 
    enabled: module.active

    Wire { from: "%surface%.play";      to: "transport.play"            ; enabled: !module.shift }
    Wire { from: "%surface%.play";      to: "beatgrid.tap"              ; enabled:  module.shift }

    Wire { from: "%surface%.sync";       to: "sync_inverter.input"      ; enabled: !module.shift }
    Wire { from: "sync_inverter.output"; to: "transport.sync"           ; enabled: !module.shift }
    Wire { from: "%surface%.sync";       to: "transport.master"         ; enabled:  module.shift }

    Wire {
      enabled: !module.shift
      from: Or
      {
        inputs:
        [
          "%surface%.loop.push",
          "%surface%.loop.is_turned"
        ]
      }
      to: "sync_inverter.reset"
   }

    Wire { from: "%surface%.rev";       to: "transport.flux_reverse"    ; enabled: !module.shift }
    Wire { from: "%surface%.rev";       to: "transport.flux"            ; enabled:  module.shift }
    Wire { from: "%surface%.cue";       to: "transport.cue"             ; enabled: !module.shift }
    Wire { from: "%surface%.cue";       to: "transport.return_to_zero"  ; enabled:  module.shift }

    WiresGroup
    {
      enabled: (!module.shift && nudgePushAction == nudgeTempoBend) || (module.shift && nudgeShiftPushAction == nudgeTempoBend)

      Wire { from: "%surface%.nudge_slow"; to: "tempo_bend.down" }
      Wire { from: "%surface%.nudge_fast"; to: "tempo_bend.up"   }
    }

    WiresGroup
    {
      enabled: !module.shift && nudgePushAction == nudgeBeatjump

      Wire { from: DirectPropertyAdapter { path: "mapping.settings.nudge_push_size"; input: false } to: "beatjump.size" }

      Wire { from: "%surface%.nudge_slow"; to: "beatjump.backward" }
      Wire { from: "%surface%.nudge_fast"; to: "beatjump.forward"  }
    }

    WiresGroup
    {
      enabled: module.shift && nudgeShiftPushAction == nudgeBeatjump

      Wire { from: DirectPropertyAdapter { path: "mapping.settings.nudge_shiftpush_size"; input: false } to: "beatjump.size" }

      Wire { from: "%surface%.nudge_slow"; to: "beatjump.backward" }
      Wire { from: "%surface%.nudge_fast"; to: "beatjump.forward"  }
    }
  }
}
