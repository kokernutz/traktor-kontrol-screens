import CSI 1.0
import "S4MK3Functions.js" as S4MK3Functions

Module
{
  id: module
  property string surface: "" // e.g. "s4mk3.left"
  property int deckIdx: 0 // Traktor deck 1..4
  property bool active: true
  property bool shift: false

  TempoControl { name: "tempo_control"; channel: deckIdx; color: S4MK3Functions.colorForDeck(deckIdx) }

  DirectPropertyAdapter { name: "tempo_fader_relative"; path: "mapping.settings.tempo_fader_relative"; input: false }
  Wire{ from: "tempo_fader_relative"; to: "tempo_control.enable_relative_mode" }

  WiresGroup
  {
    enabled: module.active

    Wire { from: "%surface%.sync"; to: "tempo_control.lock"; enabled: module.shift }
    Wire { from: "%surface%.pitch.led"; to: "tempo_control.indicator" }
    Wire { from: "%surface%.pitch.fader"; to: "tempo_control.adjust"; enabled: !module.shift }
    Wire { from: "%surface%.master";      to: "tempo_control.reset"           ; enabled: module.shift  }
  }
}
