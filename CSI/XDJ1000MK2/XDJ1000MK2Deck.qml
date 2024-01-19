import CSI 1.0

import "../Common/Pioneer"
import "../Common/XDJ"

Module
{
  id: module

  property int deck: 1
  property bool enabled: true

  readonly property string deckProp: "mapping.state.deck." + deck

  XDJCommonDeck { name: "common_deck"; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }

  BrowserModule { name: "browser"; deck: module.deck; lines: 7; useHeader: true; deckProp: module.deckProp; enabled: module.enabled }

  Waveform { name: "waveform"; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }

  Stripe { name: "stripe"; deck: module.deck; enabled: module.enabled  }

  XDJ1000MK2HotCues { name: "hotcues"; deck: module.deck; deckProp: module.deckProp; enabled: module.enabled }

  XDJPhaseMeter { name: "phase_meter"; channel: module.deck }
  Wire { from: "surface.deck_phase_info"; to:"phase_meter.deck.value"; enabled: module.enabled }
  Wire { from: "surface.master_phase_info"; to:"phase_meter.master.value"; enabled: module.enabled }
}
