import CSI 1.0

Module
{
  id: module

  property int deck: 1
  property bool enabled: true
  property string deckProp: ""

  readonly property bool jogTouch: jogTouch.value

  MappingPropertyDescriptor {
    id: jogMode
    path: deckProp + ".jog_mode"
    type: MappingPropertyDescriptor.Boolean
    value: true
  }

  MappingPropertyDescriptor {
    id: jogTouch
    path: deckProp + ".jog_touch"
    type: MappingPropertyDescriptor.Boolean
    value: false
  }

  Turntable { name: "cdj_jogwheel"; channel: module.deck }
  WiresGroup {
      enabled: module.enabled
      Wire { from: "surface.jogwheel.rotation"; to: "cdj_jogwheel.rotation" }
      Wire { from: "surface.jogwheel.speed"; to: "cdj_jogwheel.speed" }
      Wire { from: "surface.jogwheel.touch"; to: "cdj_jogwheel.touch"; enabled: jogMode.value }
      Wire { from: "surface.jogwheel.touch"; to: HoldPropertyAdapter { path: jogTouch.path } enabled: jogMode.value }
      Wire { from: "surface.jog_mode"; to:  TogglePropertyAdapter{ path: deckProp + ".jog_mode"; defaultValue: false } }
      Wire { from: "surface.display.current_time"; to: "cdj_jogwheel.playhead_info" }
  }

}
