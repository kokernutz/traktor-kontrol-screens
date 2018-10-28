import CSI 1.0

Module
{
  id: module
  property bool shift: false
  property string surface: ""
  property int deckIdx: 0
  property bool active: false

  Hotcues   { name: "hotcues";      channel: deckIdx }

  WiresGroup
  {
    enabled: active 

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.pads.1";   to: "hotcues.1.trigger" }
      Wire { from: "%surface%.pads.2";   to: "hotcues.2.trigger" }
      Wire { from: "%surface%.pads.3";   to: "hotcues.3.trigger" }
      Wire { from: "%surface%.pads.4";   to: "hotcues.4.trigger" }
      Wire { from: "%surface%.pads.5";   to: "hotcues.5.trigger" }
      Wire { from: "%surface%.pads.6";   to: "hotcues.6.trigger" }
      Wire { from: "%surface%.pads.7";   to: "hotcues.7.trigger" }
      Wire { from: "%surface%.pads.8";   to: "hotcues.8.trigger" }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.pads.1";   to: "hotcues.1.delete" }
      Wire { from: "%surface%.pads.2";   to: "hotcues.2.delete" }
      Wire { from: "%surface%.pads.3";   to: "hotcues.3.delete" }
      Wire { from: "%surface%.pads.4";   to: "hotcues.4.delete" }
      Wire { from: "%surface%.pads.5";   to: "hotcues.5.delete" }
      Wire { from: "%surface%.pads.6";   to: "hotcues.6.delete" }
      Wire { from: "%surface%.pads.7";   to: "hotcues.7.delete" }
      Wire { from: "%surface%.pads.8";   to: "hotcues.8.delete" }
    }
  }
}
