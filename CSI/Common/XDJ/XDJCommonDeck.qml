import CSI 1.0

Module
{
  id: module

  property int deck: 1
  property string deckProp: ""
  property bool enabled: true
  onEnabledChanged: { if(enabled) tempo.enforceSupportedRange(); }

  XDJTransportButtons { name: "transport_buttons"; deck: module.deck; enabled: module.enabled }

  XDJDeckInfo { name: "deck_info"; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }

  XDJTempoModule { name: "tempo"; id: tempo; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }

  XDJJogWheel { name: "jogwheel"; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }

  XDJLoopingBasic { name: "looping_basic"; deck: module.deck; enabled: module.enabled }

  XDJLoopingHalfDouble { name: "looping_half_double"; deck: module.deck; enabled: module.enabled }
}
