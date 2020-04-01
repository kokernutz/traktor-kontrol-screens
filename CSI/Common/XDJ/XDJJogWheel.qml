import CSI 1.0

Module
{
  id: module

  property int deck: 1
  property bool enabled: true
  property string deckProp: ""

  MappingPropertyDescriptor {
    id: jogMode
    path: deckProp + ".jog_mode"
    type: MappingPropertyDescriptor.Boolean;
    value: true;
  }

  Wire { enabled: module.enabled; from: "surface.jog_mode"; to:  TogglePropertyAdapter{ path: deckProp + ".jog_mode"; defaultValue: false } }

  Turntable { name: "cdj_jogwheel"; channel: module.deck }
  WiresGroup
  {
      enabled: module.enabled
      Wire { from: "surface.jogwheel.rotation"; to: "cdj_jogwheel.rotation" }
      Wire { from: "surface.jogwheel.speed"; to: "cdj_jogwheel.speed" }
      Wire { from: "surface.jogwheel.touch"; to: "cdj_jogwheel.touch"; enabled: jogMode.value }
  }

}
