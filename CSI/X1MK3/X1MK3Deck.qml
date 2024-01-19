import CSI 1.0

import "Defines"
import "../../Defines"

Module
{
  id: module
  property bool shift: false
  property bool active: false
  property bool syncModifier: false
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

  // Browse encoder actions
  readonly property int browse_tree:      0
  readonly property int browse_favorites: 1

  // Loop encoder actions
  readonly property int beatjump_loop:      0
  readonly property int key_adjust:         1

  //------------------------SUBMODULES----------------------------

  X1MK3TransportButtons
  {
    name: "transport"
    shift: module.shift
    active: module.active
    surface: module.surface
    deckIdx: module.deckIdx

    nudgePushAction: module.nudgePushAction
    nudgeShiftPushAction: module.nudgeShiftPushAction
  }

  X1MK3HotcueButtons
  {
    name: "hotcue"
    shift: module.shift
    active: module.active
    surface: module.surface
    deckIdx: module.deckIdx

    hotcue12PushAction: module.hotcue12PushAction
    hotcue34PushAction: module.hotcue34PushAction
    hotcue12ShiftPushAction: module.hotcue12ShiftPushAction
    hotcue34ShiftPushAction: module.hotcue34ShiftPushAction
  }

  Loop { name: "loop";  channel: module.deckIdx }
  KeyControl { name: "key_control"; channel: module.deckIdx }

  WiresGroup
  {
    enabled: module.active

    Wire { from: "%surface%.loop"; to: "loop.autoloop"; enabled: !module.shift && !module.syncModifier }
    Wire { from: SetPropertyAdapter{ path: "app.traktor.decks." + module.deckIdx + ".loop.active"; value: 1; input: false; color: Color.White } to: "%surface%.loop.indicator" }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.loop"; to: "loop.move"; enabled: loopShiftAction == beatjump_loop }
      Wire { from: "%surface%.loop"; to: "key_control.coarse"; enabled: loopShiftAction == key_adjust }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.loop_in_out)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.loop_in_out))

      Wire { from: "%surface%.hotcues.1"; to: "loop.in" }
      Wire { from: "%surface%.hotcues.2"; to: "loop.out" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.loop_in_out)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.loop_in_out))

      Wire { from: "%surface%.hotcues.3"; to: "loop.in" }
      Wire { from: "%surface%.hotcues.4"; to: "loop.out" }
    }
  }

  AppProperty { id: inActiveLoopProp; path: "app.traktor.decks." + module.deckIdx + ".loop.is_in_active_loop" }
  AppProperty { id: endWarningProp; path: "app.traktor.decks." + module.deckIdx + ".track.track_end_warning" }

  AppProperty { id: syncProp; path: "app.traktor.decks." + module.deckIdx + ".sync.enabled" }
  AppProperty { id: phaseProp; path: "app.traktor.decks." + module.deckIdx + ".tempo.phase" }

  Lighter { name: "sync_lighter"; ledCount: 6; color: Color.Red;   brightness: 1.0 }
  Lighter { name: "loop_lighter"; ledCount: 6; color: Color.Green; brightness: 1.0 }
  Blinker { name: "warning_blinker"; ledCount: 6; autorun: true; color: Color.Red; defaultBrightness: 0.0; cycle: 300 }

  property bool shouldShowEndWarning: showEndWarning && endWarningProp.value
  property bool shouldShowActiveLoop: showActiveLoop && inActiveLoopProp.value
  property bool shouldShowSyncWarning: showSyncWarning && syncProp.value && (Math.abs(phaseProp.value) >= 0.008)

  Lighter { name: "default_lighter";   ledCount: 6; color: module.bottomLedsDefaultColor; brightness: 1.0 }
  Lighter { name: "rainbow_lighter_1"; color: Color.Red;                     brightness: 1.0 }
  Lighter { name: "rainbow_lighter_2"; color: Color.LightOrange;             brightness: 1.0 }
  Lighter { name: "rainbow_lighter_3"; color: Color.Yellow;                  brightness: 1.0 }
  Lighter { name: "rainbow_lighter_4"; color: Color.Green;                   brightness: 1.0 }
  Lighter { name: "rainbow_lighter_5"; color: Color.Blue;                    brightness: 1.0 }
  Lighter { name: "rainbow_lighter_6"; color: Color.Purple;                  brightness: 1.0 }

  WiresGroup
  {
    enabled: module.active

    Wire { from: "%surface%.bottom.leds";  to: "loop_lighter"; enabled: shouldShowActiveLoop }
    Wire { from: "%surface%.bottom.leds";  to: "warning_blinker"; enabled: shouldShowEndWarning && !shouldShowActiveLoop }
    Wire { from: "%surface%.bottom.leds";  to: "sync_lighter"; enabled: shouldShowSyncWarning && !shouldShowEndWarning && !shouldShowActiveLoop }

    WiresGroup
    {
      enabled: !shouldShowSyncWarning && !shouldShowEndWarning && !shouldShowActiveLoop

      Wire { from: "%surface%.bottom.leds"; to: "default_lighter"; enabled: module.bottomLedsDefaultColor != Color.White }

      WiresGroup
      {
        enabled: module.bottomLedsDefaultColor == Color.White
    
        Wire { from: "%surface%.bottom.leds.1"; to: "rainbow_lighter_1" }
        Wire { from: "%surface%.bottom.leds.2"; to: "rainbow_lighter_2" }
        Wire { from: "%surface%.bottom.leds.3"; to: "rainbow_lighter_3" }
        Wire { from: "%surface%.bottom.leds.4"; to: "rainbow_lighter_4" }
        Wire { from: "%surface%.bottom.leds.5"; to: "rainbow_lighter_5" }
        Wire { from: "%surface%.bottom.leds.6"; to: "rainbow_lighter_6" }
      }
    }
  }

  property bool coarseTempoStep: false
  property bool resetTempoEngaged: false
  AppProperty { id: tempoAdjProp; path: "app.traktor.decks." + module.deckIdx + ".tempo.adjust" }
  AppProperty { id: tempoAbsProp; path: "app.traktor.decks." + module.deckIdx + ".tempo.absolute" }

  WiresGroup
  {
    enabled: module.active && !module.shift && module.syncModifier

    Wire {
      from: "%surface%.loop.turn"
      to: EncoderScriptAdapter {
        onTick: {
          module.resetTempoEngaged = false;
        }
        onIncrement: {
          tempoAbsProp.value = tempoAbsProp.value + (module.coarseTempoStep ? 0.01 : 0.001)
        }
        onDecrement: {
          tempoAbsProp.value = tempoAbsProp.value - (module.coarseTempoStep ? 0.01 : 0.001)
        }
      }
    }

    Wire {
      from: "%surface%.loop.push"
      to: ButtonScriptAdapter {
        onPress: {
          module.coarseTempoStep = true;
          module.resetTempoEngaged = true;
        }
        onRelease: {
          module.coarseTempoStep = false;
          if (module.resetTempoEngaged)
          {
            // Reset the tempo
            tempoAdjProp.value = 0.0
          }
        }
      }
    }
  }

  // Absolute/Relative
  SetPropertyAdapter { name: "play_mode_absolute"; path: "app.traktor.decks." + module.deckIdx + ".playback_mode"; color: Color.Blue; value: PlaybackMode.Absolute }
  SetPropertyAdapter { name: "play_mode_relative"; path: "app.traktor.decks." + module.deckIdx + ".playback_mode"; color: Color.Blue; value: PlaybackMode.Relative }

  WiresGroup
  {
    enabled: module.active

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.abs_rel)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.abs_rel))

      Wire { from: "%surface%.hotcues.1"; to: "play_mode_absolute" }
      Wire { from: "%surface%.hotcues.2"; to: "play_mode_relative" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.abs_rel)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.abs_rel))

      Wire { from: "%surface%.hotcues.3"; to: "play_mode_absolute" }
      Wire { from: "%surface%.hotcues.4"; to: "play_mode_relative" }
    }
  }

  // Stutter Loops
  FluxedLoop { name: "fluxed_loop"; channel: module.deckIdx }
  ButtonSection { name: "stutter_pads"; buttons: 6; color: Color.Green; buttonHandling: ButtonSection.Stack }

  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_32 } to: "stutter_pads.button1.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_16 } to: "stutter_pads.button2.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_8  } to: "stutter_pads.button3.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_4  } to: "stutter_pads.button4.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_2  } to: "stutter_pads.button5.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1    } to: "stutter_pads.button6.value" }

  Wire { from: "stutter_pads.value";      to: "fluxed_loop.size"   }
  Wire { from: "stutter_pads.active";     to: "fluxed_loop.active" }

  WiresGroup
  {
    enabled: module.active

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.stutter_132_116)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.stutter_132_116))

      Wire { from: "%surface%.hotcues.1"; to: "stutter_pads.button1" }
      Wire { from: "%surface%.hotcues.2"; to: "stutter_pads.button2" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.stutter_132_116)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.stutter_132_116))

      Wire { from: "%surface%.hotcues.3"; to: "stutter_pads.button1" }
      Wire { from: "%surface%.hotcues.4"; to: "stutter_pads.button2" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.stutter_18_14)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.stutter_18_14))

      Wire { from: "%surface%.hotcues.1"; to: "stutter_pads.button3" }
      Wire { from: "%surface%.hotcues.2"; to: "stutter_pads.button4" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.stutter_18_14)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.stutter_18_14))

      Wire { from: "%surface%.hotcues.3"; to: "stutter_pads.button3" }
      Wire { from: "%surface%.hotcues.4"; to: "stutter_pads.button4" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.stutter_14_12)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.stutter_14_12))

      Wire { from: "%surface%.hotcues.1"; to: "stutter_pads.button4" }
      Wire { from: "%surface%.hotcues.2"; to: "stutter_pads.button5" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.stutter_14_12)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.stutter_14_12))

      Wire { from: "%surface%.hotcues.3"; to: "stutter_pads.button4" }
      Wire { from: "%surface%.hotcues.4"; to: "stutter_pads.button5" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.stutter_12_1)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.stutter_12_1))

      Wire { from: "%surface%.hotcues.1"; to: "stutter_pads.button5" }
      Wire { from: "%surface%.hotcues.2"; to: "stutter_pads.button6" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.stutter_12_1)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.stutter_12_1))

      Wire { from: "%surface%.hotcues.3"; to: "stutter_pads.button5" }
      Wire { from: "%surface%.hotcues.4"; to: "stutter_pads.button6" }
    }
  }

  // FX Assignment
  AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }

  WiresGroup
  {
    enabled: module.active

    WiresGroup
    {
      enabled: (fxMode.value == FxMode.TwoFxUnits) ||
               (!module.shift && (module.fxSectionLayer == FXSectionLayer.fx_primary)) ||
               ( module.shift && (module.fxSectionLayer == FXSectionLayer.fx_secondary))

      Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.1"; color: Color.LightOrange } }
      Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.2"; color: Color.LightOrange } }
    }

    WiresGroup
    {
      enabled:  (fxMode.value == FxMode.FourFxUnits) &&
                ((!module.shift && (module.fxSectionLayer == FXSectionLayer.fx_secondary)) ||
                 (module.shift && (module.fxSectionLayer == FXSectionLayer.fx_primary)))
                

      Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.3"; color: Color.LightOrange } }
      Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.4"; color: Color.LightOrange } }
    }
  }

  // Browser
  Browser { name: "browser" }

  WiresGroup
  {
    enabled: module.active

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.browse"; to: "browser.list_navigation" }
      Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".load.selected" } }
    }

    Wire
    {
      from: "%surface%.browse.turn"
      to: "browser.favorites_navigation.turn"
      enabled: module.shift && (browseShiftAction == browse_favorites)
    }

    Wire
    {
      from: "%surface%.browse"
      to: "browser.tree_navigation"
      enabled: module.shift && (browseShiftAction == browse_tree)
    }
  }
}
