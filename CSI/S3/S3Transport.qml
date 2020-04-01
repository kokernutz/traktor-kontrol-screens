import CSI 1.0
import "../Common/DeckHelpers.js" as Helpers

Module
{
  id: module
  property string surface: "" // e.g. "s4mk3.left"
  property int deckIdx: 0 // Traktor deck 1..4
  property bool active: false
  property bool shift: false
  property var deckColor: Helpers.colorForDeck(deckIdx)

  TransportSection
  {
    name: "transport"
    channel: module.deckIdx
    masterColor: Color.White
    syncColor: module.deckColor
    cueColor: module.deckColor
  }

  TempoControl { name: "tempo_control"; channel: deckIdx }

  DirectPropertyAdapter { name: "tempo_fader_relative"; path: "mapping.settings.tempo_fader_relative"; input: false }
  Wire{ from: "tempo_fader_relative"; to: "tempo_control.enable_relative_mode" }

  WiresGroup
  {
    enabled: module.active

    Wire { from: "%surface%.key_lock";    to: TogglePropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".track.key.lock_enabled";
                                                                      color: module.deckColor; }
                                                                      enabled: !module.shift   }
    Wire { from: "%surface%.key_lock";    to: "tempo_control.reset";  enabled:  module.shift }
    Wire { from: "%surface%.pitch.fader"; to: "tempo_control.adjust"; enabled: !module.shift }
    Wire { from: "%surface%.reverse";     to: "transport.flux_reverse"    }
    Wire { from: "%surface%.flux";        to: "transport.flux"            }
    Wire { from: "%surface%.play";        to: "transport.play"            }
    Wire { from: "%surface%.sync";        to: "transport.sync"              ; enabled: !module.shift }
    Wire { from: "%surface%.sync";        to: "transport.master"            ; enabled:  module.shift }
    Wire { from: "%surface%.cue";         to: "transport.cue"               ; enabled: !module.shift }
    Wire { from: "%surface%.cue";         to: "transport.return_to_zero"    ; enabled:  module.shift }
  }
}
