import CSI 1.0

Module
{
  id: module
  property string surface: "" // e.g. "s4mk3.left"
  property int deckIdx: 0 // Traktor deck 1..4
  property bool active: true
  property bool shift: false

  TempoControl { name: "tempo_control"; channel: deckIdx }

  DirectPropertyAdapter { name: "tempo_fader_relative"; path: "mapping.settings.tempo_fader_relative"; input: false }
  Wire{ from: "tempo_fader_relative"; to: "tempo_control.enable_relative_mode" }

  Wire { from: "%surface%.pitch.fader"; to: "tempo_control.adjust"; enabled: module.active && !module.shift }

}
