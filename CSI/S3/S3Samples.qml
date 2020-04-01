import CSI 1.0

Module
{
  id: module
  property bool shift: false
  property string surface: ""
  property int deckIdx: 0
  property bool active: false

  RemixTrigger { name: "triggering"; channel: module.deckIdx }
  RemixMixing { name: "mixing"; channel: module.deckIdx }

  WiresGroup
  {
    enabled: module.active

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
    }

    Wire { from: "%surface%.pads.5"; to: "mixing.1.mute" }
    Wire { from: "%surface%.pads.6"; to: "mixing.2.mute" }
    Wire { from: "%surface%.pads.7"; to: "mixing.3.mute" }
    Wire { from: "%surface%.pads.8"; to: "mixing.4.mute" }
  }
}

