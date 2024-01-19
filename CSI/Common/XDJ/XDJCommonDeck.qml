import CSI 1.0

import "../Pioneer"

Module {
  id: module

  property int deck: 1
  property string deckProp: ""
  property bool enabled: true
  onEnabledChanged: { if(enabled) tempo.enforceSupportedRange(); }

  DeckInfo { name: "deck_info"; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }

  TransportButtons { name: "transport_buttons"; deck: module.deck; enabled: module.enabled }

  ExtendedTransportButtons { name: "extended_transport_buttons"; deck: module.deck; enabled: module.enabled }

  TempoModule { name: "tempo"; id: tempo; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }

  JogWheel { name: "jogwheel"; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }

  LoopingBasic { name: "looping_basic"; deck: module.deck; enabled: module.enabled }

  LoopingHalfDouble { name: "looping_half_double"; deck: module.deck; enabled: module.enabled }

  LoopRollPads { name: "loop_roll_pads"; deck: module.deck; enabled: module.enabled }
}
