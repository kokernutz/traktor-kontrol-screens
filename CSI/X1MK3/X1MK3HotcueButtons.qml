import CSI 1.0

import "Defines"

Module
{
  id: module
  property bool shift: false
  property bool active: false
  property int deckIdx: 0
  property string surface: ""

  property int hotcue12PushAction: 0
  property int hotcue34PushAction: 0
  property int hotcue12ShiftPushAction: 0
  property int hotcue34ShiftPushAction: 0

  Hotcues { name: "hotcues"; channel: module.deckIdx }
  RemixDeckSlots { name: "remix_slots"; channel: module.deckIdx }

  AppProperty { id: deckTypeProp; path: "app.traktor.decks." + module.deckIdx + ".type" }

  WiresGroup
  { 
    enabled: module.active && (deckTypeProp.value == DeckType.Track || deckTypeProp.value == DeckType.Stem)

    // Hotcue buttons 1-2
    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.trigger_12)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.trigger_12))
  
      Wire { from: "%surface%.hotcues.1"; to: "hotcues.1.trigger" }
      Wire { from: "%surface%.hotcues.2"; to: "hotcues.2.trigger" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.trigger_34)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.trigger_34))
  
      Wire { from: "%surface%.hotcues.1"; to: "hotcues.3.trigger" }
      Wire { from: "%surface%.hotcues.2"; to: "hotcues.4.trigger" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.trigger_56)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.trigger_56))
  
      Wire { from: "%surface%.hotcues.1"; to: "hotcues.5.trigger" }
      Wire { from: "%surface%.hotcues.2"; to: "hotcues.6.trigger" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.trigger_78)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.trigger_78))
  
      Wire { from: "%surface%.hotcues.1"; to: "hotcues.7.trigger" }
      Wire { from: "%surface%.hotcues.2"; to: "hotcues.8.trigger" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue12ShiftPushAction == HotcueAction.delete_12)
  
      Wire { from: "%surface%.hotcues.1"; to: "hotcues.1.delete" }
      Wire { from: "%surface%.hotcues.2"; to: "hotcues.2.delete" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue12ShiftPushAction == HotcueAction.delete_34)
  
      Wire { from: "%surface%.hotcues.1"; to: "hotcues.3.delete" }
      Wire { from: "%surface%.hotcues.2"; to: "hotcues.4.delete" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue12ShiftPushAction == HotcueAction.delete_56)
  
      Wire { from: "%surface%.hotcues.1"; to: "hotcues.5.delete" }
      Wire { from: "%surface%.hotcues.2"; to: "hotcues.6.delete" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue12ShiftPushAction == HotcueAction.delete_78)
  
      Wire { from: "%surface%.hotcues.1"; to: "hotcues.7.delete" }
      Wire { from: "%surface%.hotcues.2"; to: "hotcues.8.delete" }
    }

    // Hotcue buttons 3-4
    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.trigger_12)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.trigger_12))
  
      Wire { from: "%surface%.hotcues.3"; to: "hotcues.1.trigger" }
      Wire { from: "%surface%.hotcues.4"; to: "hotcues.2.trigger" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.trigger_34)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.trigger_34))
  
      Wire { from: "%surface%.hotcues.3"; to: "hotcues.3.trigger" }
      Wire { from: "%surface%.hotcues.4"; to: "hotcues.4.trigger" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.trigger_56)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.trigger_56))
  
      Wire { from: "%surface%.hotcues.3"; to: "hotcues.5.trigger" }
      Wire { from: "%surface%.hotcues.4"; to: "hotcues.6.trigger" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.trigger_78)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.trigger_78))
  
      Wire { from: "%surface%.hotcues.3"; to: "hotcues.7.trigger" }
      Wire { from: "%surface%.hotcues.4"; to: "hotcues.8.trigger" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue34ShiftPushAction == HotcueAction.delete_12)
  
      Wire { from: "%surface%.hotcues.3"; to: "hotcues.1.delete" }
      Wire { from: "%surface%.hotcues.4"; to: "hotcues.2.delete" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue34ShiftPushAction == HotcueAction.delete_34)
  
      Wire { from: "%surface%.hotcues.3"; to: "hotcues.3.delete" }
      Wire { from: "%surface%.hotcues.4"; to: "hotcues.4.delete" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue34ShiftPushAction == HotcueAction.delete_56)
  
      Wire { from: "%surface%.hotcues.3"; to: "hotcues.5.delete" }
      Wire { from: "%surface%.hotcues.4"; to: "hotcues.6.delete" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue34ShiftPushAction == HotcueAction.delete_78)
  
      Wire { from: "%surface%.hotcues.3"; to: "hotcues.7.delete" }
      Wire { from: "%surface%.hotcues.4"; to: "hotcues.8.delete" }
    }
  }

  WiresGroup
  { 
    enabled: module.active && (deckTypeProp.value == DeckType.Remix)

    // Hotcue buttons 1-2
    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.trigger_12)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.trigger_12))
  
      Wire { from: "%surface%.hotcues.1"; to: "remix_slots.1.adaptive_primary" }
      Wire { from: "%surface%.hotcues.2"; to: "remix_slots.2.adaptive_primary" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.trigger_34)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.trigger_34))
  
      Wire { from: "%surface%.hotcues.1"; to: "remix_slots.3.adaptive_primary" }
      Wire { from: "%surface%.hotcues.2"; to: "remix_slots.4.adaptive_primary" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue12ShiftPushAction == HotcueAction.delete_12)
  
      Wire { from: "%surface%.hotcues.1"; to: "remix_slots.1.adaptive_secondary" }
      Wire { from: "%surface%.hotcues.2"; to: "remix_slots.2.adaptive_secondary" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue12ShiftPushAction == HotcueAction.delete_34)
  
      Wire { from: "%surface%.hotcues.1"; to: "remix_slots.3.adaptive_secondary" }
      Wire { from: "%surface%.hotcues.2"; to: "remix_slots.4.adaptive_secondary" }
    }

    // Hotcue buttons 3-4
    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.trigger_12)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.trigger_12))
  
      Wire { from: "%surface%.hotcues.3"; to: "remix_slots.1.adaptive_primary" }
      Wire { from: "%surface%.hotcues.4"; to: "remix_slots.2.adaptive_primary" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.trigger_34)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.trigger_34))
  
      Wire { from: "%surface%.hotcues.3"; to: "remix_slots.3.adaptive_primary" }
      Wire { from: "%surface%.hotcues.4"; to: "remix_slots.4.adaptive_primary" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue34ShiftPushAction == HotcueAction.delete_12)
  
      Wire { from: "%surface%.hotcues.3"; to: "remix_slots.1.adaptive_secondary" }
      Wire { from: "%surface%.hotcues.4"; to: "remix_slots.2.adaptive_secondary" }
    }

    WiresGroup
    {
      enabled: module.shift && (hotcue34ShiftPushAction == HotcueAction.delete_34)
  
      Wire { from: "%surface%.hotcues.3"; to: "remix_slots.3.adaptive_secondary" }
      Wire { from: "%surface%.hotcues.4"; to: "remix_slots.4.adaptive_secondary" }
    }
  }
}
