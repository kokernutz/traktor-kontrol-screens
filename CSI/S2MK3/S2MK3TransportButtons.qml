import CSI 1.0

Module
{
  id: module
  property string surface: "" // e.g. "s4mk3.left"
  property int deckIdx: 0 // Traktor deck 1..4
  property bool active: true
  property bool shift: false

  TransportSection { name: "transport";   channel: module.deckIdx }
  
  WiresGroup
  { 
    enabled: module.active

    Wire { from: "%surface%.reverse"; to: "transport.flux_reverse"                           } 
    Wire { from: "%surface%.flux";    to: "transport.flux"                                   } 
    Wire { from: "%surface%.play";    to: "transport.play"                                   }
    Wire { from: "%surface%.sync";    to: "transport.sync"                                   }
    Wire { from: "%surface%.cue";     to: "transport.cue";            enabled: !module.shift }
    Wire { from: "%surface%.cue";     to: "transport.return_to_zero"; enabled: module.shift; }                         
  }    
}
