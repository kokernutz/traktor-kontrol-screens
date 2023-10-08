import CSI 1.0

import "../Common/Pioneer"
import "../Common/CDJ"

Module {
  id: module

  property int deck: 1
  property bool enabled: true

  // Paths
  readonly property string deckSettingsPath: "mapping.settings.deck." + deck
  readonly property string deckPropertiesPath: "mapping.state.deck." + deck

  CDJCommonDeck { name: "common_deck"; deck: module.deck; deckProp: module.deckPropertiesPath; shift: call.value; enabled: module.enabled }

  BrowserModule { name: "browser"; deck: module.deck; lines: 10; useHeader: true; deckProp: module.deckPropertiesPath; enabled: module.enabled }

  CDJ3000BeatLoopButtons { name: "beat_loop_buttons"; deck: module.deck; enabled: module.enabled }

  CDJ3000BeatjumpButtons { name: "beatjump_buttons"; deck: module.deck; shift: call.value; enabled: module.enabled }

  KeyShift { name: "key_shift"; deck: module.deck; enabled: module.enabled }

  XDJPhaseMeter { name: "phase_meter"; channel: module.deck }
  Wire { from: "surface.deck_phase_info"; to:"phase_meter.deck.value"; enabled: module.enabled }
  Wire { from: "surface.master_phase_info"; to:"phase_meter.master.value"; enabled: module.enabled }

  MappingPropertyDescriptor { id: call; path: deckPropertiesPath + ".call"; type: MappingPropertyDescriptor.Boolean; value: false }
  Wire { from: "surface.hotcue_delete"; to: HoldPropertyAdapter { path: call.path } enabled: module.enabled }
}
