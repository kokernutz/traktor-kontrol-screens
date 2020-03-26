import CSI 1.0
import "../Common/DeckHelpers.js" as Helpers

Module
{
  id: module
  property string surface: "" // e.g. "s4mk3.left"
  property int deckIdx: 0 // Traktor deck 1..4
  property bool active: false
  property var deckColor: Helpers.colorForDeck(deckIdx)
  property bool shift: false

  TransportSection
  {
    name: "transport"
    channel: module.deckIdx
    masterColor: module.deckColor
    syncColor: module.deckColor
    cueColor: module.deckColor
  }
  
  WiresGroup
  { 
    enabled: module.active
        
    Wire { from: "%surface%.reverse";   to: "transport.flux_reverse"    }
    Wire { from: "%surface%.flux";      to: "transport.flux"            }
    Wire { from: "%surface%.play";      to: "transport.play"            }
    Wire { from: "%surface%.sync";      to: "transport.sync"              ; enabled: !module.shift }
    Wire { from: "%surface%.master";    to: "transport.master"            ; enabled: !module.shift }
    Wire { from: "%surface%.cue";       to: "transport.cue"               ; enabled: !module.shift }
    Wire { from: "%surface%.cue";       to: "transport.return_to_zero"    ; enabled:  module.shift }
  }   
}
