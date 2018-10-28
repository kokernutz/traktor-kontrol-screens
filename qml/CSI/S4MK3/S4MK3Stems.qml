import CSI 1.0

Module
{
  id: module
  property string surface: ""
  property int deckIdx: 0
  property bool active: false
  property bool shift: false 
  property string deckPropertiesPath: ""
  property bool isStemSelected: propActiveStem.value != 0 && module.active
  
  StemDeckStreams { name: "stems"; channel: deckIdx; encoderStep: 0.05 }

  MappingPropertyDescriptor { id: propActiveStem; path: deckPropertiesPath + ".stems.active_stem"; type: MappingPropertyDescriptor.Integer; value: 0; }
  
  WiresGroup
  {
    enabled: active

    //----------------------- Top Pads to stem mutes -----------------------------
    
    Wire { from: "%surface%.pads.1"; to: "stems.1.muted" }
    Wire { from: "%surface%.pads.2"; to: "stems.2.muted" }
    Wire { from: "%surface%.pads.3"; to: "stems.3.muted" }
    Wire { from: "%surface%.pads.4"; to: "stems.4.muted" }

    //------- Loop and beatjump to focused stem's volume and filter amount -------

    WiresGroup
    {
      enabled: !module.shift
    
      WiresGroup
      {
        enabled: propActiveStem.value == 1
        
        Wire { from: "%surface%.loop_move";     to: "stems.1.volume_stepped" }
        Wire { from: "%surface%.loop_size";     to: "stems.1.filter_stepped" }
      }
      WiresGroup
      {
        enabled: propActiveStem.value == 2
        
        Wire { from: "%surface%.loop_move";     to: "stems.2.volume_stepped" }
        Wire { from: "%surface%.loop_size";     to: "stems.2.filter_stepped" }
      }
      WiresGroup
      {
        enabled: propActiveStem.value == 3
        
        Wire { from: "%surface%.loop_move";     to: "stems.3.volume_stepped" }
        Wire { from: "%surface%.loop_size";     to: "stems.3.filter_stepped" }
      }
      WiresGroup
      {
        enabled: propActiveStem.value == 4
        
        Wire { from: "%surface%.loop_move";     to: "stems.4.volume_stepped" }
        Wire { from: "%surface%.loop_size";     to: "stems.4.filter_stepped" }
      }
    }

    //------------------------- Lower pads to stem focus ---------------------------

    Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".stems.active_stem"; value: 1; defaultValue: 0 } }
    Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".stems.active_stem"; value: 2; defaultValue: 0 } }
    Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".stems.active_stem"; value: 3; defaultValue: 0 } }
    Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".stems.active_stem"; value: 4; defaultValue: 0 } }
  }

}