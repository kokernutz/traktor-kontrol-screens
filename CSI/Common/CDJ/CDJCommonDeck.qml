import CSI 1.0

import "../Pioneer"

Module {
  id: module

  property int deck: 1
  property string deckProp: ""
  property bool shift: false
  property bool enabled: true
  onEnabledChanged: { if(enabled) tempo.enforceSupportedRange(); }

  DeckInfo { name: "deck_info"; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }

  ExtendedDeckInfo { name: "extended_deck_info"; deck: module.deck; deckProp: module.deckProp; jogTouch: jogwheel.jogTouch; enabled: module.enabled }

  BrowseEncoderLED { name: "browse_led"; deck: module.deck; enabled: module.enabled }

  TransportButtons { name: "transport_buttons"; deck: module.deck; enabled: module.enabled }

  ExtendedTransportButtons { name: "extended_transport_buttons"; deck: module.deck; enabled: module.enabled }

  TempoModule { name: "tempo"; id: tempo; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }
  AppProperty { id: isSyncEnabled; path: "app.traktor.decks." + deck + ".sync.enabled" }
  WiresGroup {
      enabled: module.enabled
      Wire { from: "surface.tempo_reset"; to: "tempo.tempo_control.lock"; enabled: !shift }
      Wire { from: "surface.tempo_reset"; to: "tempo.tempo_control.reset"; enabled: shift && !isSyncEnabled.value }
      Wire { from: "surface.tempo_reset.led"; to: "tempo.tempo_control.indicator" }
  }

  Waveform { name: "waveform"; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }

  Stripe { name: "stripe"; deck: module.deck; enabled: module.enabled  }

  JogWheel { name: "jogwheel"; id: jogwheel; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }
  Wire { from: "surface.jogwheel.LED"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deck + ".is_loaded"; input: false; color: Color.White } }

  LoopingBasic { name: "looping_basic"; deck: module.deck; enabled: module.enabled }

  CueLoopCall { name: "cue_loop_call"; deck: module.deck; loopControls: true; enabled: module.enabled }

  HotCuePads { name: "hotcues"; deck: module.deck; shift: call.value; enabled: module.enabled }

  LoopRollPads { name: "loop_roll_pads"; deck: module.deck; enabled: module.enabled }

  BeatjumpPads { name: "beatjump_pads"; deck: module.deck; enabled: module.enabled }
}
