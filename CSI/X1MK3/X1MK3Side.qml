import CSI 1.0
import "Defines"

Module
{
  id: module

  property bool shift: false
  property bool active: false
  property int deckIdx: 0
  property string surface: ""
  property string propertiesPath: ""

  property int fxSectionLayer: FXSectionLayer.fx_primary

  // Settings
  property int nudgePushAction: 0
  property int nudgeShiftPushAction: 0

  property int hotcue12PushAction: 0
  property int hotcue34PushAction: 0
  property int hotcue12ShiftPushAction: 0
  property int hotcue34ShiftPushAction: 0

  property int browseShiftAction: 0
  property int loopShiftAction: 0

  property bool showEndWarning: false
  property bool showSyncWarning: false
  property bool showActiveLoop: false
  property int  bottomLedsDefaultColor: 0

  X1MK3Deck
  {
    name: "deck_a"
    deckIdx: 1
    active: module.active && (module.deckIdx == 1)

    surface: module.surface
    propertiesPath: module.propertiesPath

    shift: module.shift
    syncModifier: syncModifierProp.value
    fxSectionLayer: module.fxSectionLayer

    nudgePushAction: module.nudgePushAction
    nudgeShiftPushAction: module.nudgeShiftPushAction

    hotcue12PushAction: module.hotcue12PushAction
    hotcue34PushAction: module.hotcue34PushAction
    hotcue12ShiftPushAction: module.hotcue12ShiftPushAction
    hotcue34ShiftPushAction: module.hotcue34ShiftPushAction

    loopShiftAction: module.loopShiftAction
    browseShiftAction: module.browseShiftAction

    showEndWarning: module.showEndWarning
    showSyncWarning: module.showSyncWarning
    showActiveLoop: module.showActiveLoop
    bottomLedsDefaultColor: module.bottomLedsDefaultColor
  }

  X1MK3Deck
  {
    name: "deck_b"
    deckIdx: 2
    active: module.active && (module.deckIdx == 2)

    surface: module.surface
    propertiesPath: module.propertiesPath

    shift: module.shift
    syncModifier: syncModifierProp.value
    fxSectionLayer: module.fxSectionLayer

    nudgePushAction: module.nudgePushAction
    nudgeShiftPushAction: module.nudgeShiftPushAction

    hotcue12PushAction: module.hotcue12PushAction
    hotcue34PushAction: module.hotcue34PushAction
    hotcue12ShiftPushAction: module.hotcue12ShiftPushAction
    hotcue34ShiftPushAction: module.hotcue34ShiftPushAction

    loopShiftAction: module.loopShiftAction
    browseShiftAction: module.browseShiftAction

    showEndWarning: module.showEndWarning
    showSyncWarning: module.showSyncWarning
    showActiveLoop: module.showActiveLoop
    bottomLedsDefaultColor: module.bottomLedsDefaultColor
  }

  X1MK3Deck
  {
    name: "deck_c"
    deckIdx: 3
    active: module.active && (module.deckIdx == 3)

    surface: module.surface
    propertiesPath: module.propertiesPath

    shift: module.shift
    syncModifier: syncModifierProp.value
    fxSectionLayer: module.fxSectionLayer

    nudgePushAction: module.nudgePushAction
    nudgeShiftPushAction: module.nudgeShiftPushAction

    hotcue12PushAction: module.hotcue12PushAction
    hotcue34PushAction: module.hotcue34PushAction
    hotcue12ShiftPushAction: module.hotcue12ShiftPushAction
    hotcue34ShiftPushAction: module.hotcue34ShiftPushAction

    loopShiftAction: module.loopShiftAction
    browseShiftAction: module.browseShiftAction

    showEndWarning: module.showEndWarning
    showSyncWarning: module.showSyncWarning
    showActiveLoop: module.showActiveLoop
    bottomLedsDefaultColor: module.bottomLedsDefaultColor
  }

  X1MK3Deck
  {
    name: "deck_d"
    deckIdx: 4
    active: module.active && (module.deckIdx == 4)

    surface: module.surface
    propertiesPath: module.propertiesPath

    shift: module.shift
    syncModifier: syncModifierProp.value
    fxSectionLayer: module.fxSectionLayer

    nudgePushAction: module.nudgePushAction
    nudgeShiftPushAction: module.nudgeShiftPushAction

    hotcue12PushAction: module.hotcue12PushAction
    hotcue34PushAction: module.hotcue34PushAction
    hotcue12ShiftPushAction: module.hotcue12ShiftPushAction
    hotcue34ShiftPushAction: module.hotcue34ShiftPushAction

    loopShiftAction: module.loopShiftAction
    browseShiftAction: module.browseShiftAction

    showEndWarning: module.showEndWarning
    showSyncWarning: module.showSyncWarning
    showActiveLoop: module.showActiveLoop
    bottomLedsDefaultColor: module.bottomLedsDefaultColor
  }


  // Screen
  MappingPropertyDescriptor { path: module.propertiesPath + ".deck_index"; type: MappingPropertyDescriptor.Integer; value: module.deckIdx }
  MappingPropertyDescriptor { path: module.propertiesPath + ".show_loop_size"; type: MappingPropertyDescriptor.Boolean; value: false }

  MappingPropertyDescriptor { id: syncModifierProp; path: module.propertiesPath + ".sync_modifier"; type: MappingPropertyDescriptor.Boolean; value: false }
  Wire { from: "%surface%.sync";  to: DirectPropertyAdapter { path: module.propertiesPath + ".sync_modifier"; output: false } }

  SwitchTimer { name: "show_loop_size_timer"; setTimeout: 0; resetTimeout: 500; ignoreEvents: PinEvent.WireEnabled }
  
  WiresGroup
  {
    enabled: module.active && !shift && !syncModifierProp.value

    Wire { from: "%surface%.loop.is_turned"; to: "show_loop_size_timer.input" }
    Wire { from: "show_loop_size_timer.output.value"; to: ValuePropertyAdapter { path: module.propertiesPath + ".show_loop_size"; output: false } }
  }

  KontrolScreen { name: "deck_screen"; propertiesPath: module.propertiesPath; flavor: ScreenFlavor.X1MK3_Deck }
  Wire { from: "deck_screen.output"; to: "%surface%.display.loop" }
}
