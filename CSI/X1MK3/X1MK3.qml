import CSI 1.0
import QtQuick 2.0

import "Defines"

Mapping
{
  id: mapping
  readonly property string propertiesPath: "mapping.state"

  X1MK3 { name: "surface" }

  X1MK3DeviceSetup {
    id: deviceSetup;
    name: "device_setup";

    surface: "surface";
    propertiesPath: mapping.propertiesPath
  }

  onRunningChanged:
  {
    // When the mapping is reloaded go back into device setup
    deviceSetup.reset();
  }


  KontrolScreen { name: "screen"; side: ScreenSide.Left; propertiesPath: mapping.propertiesPath; flavor: ScreenFlavor.X1MK3_Mode }
  Wire { from: "screen.output"; to: "surface.display.mode" }

  // Settings
  MappingPropertyDescriptor { path: "mapping.settings.nudge_push_size"; type: MappingPropertyDescriptor.Integer; value: 11 /* 32 beats */ }
  MappingPropertyDescriptor { path: "mapping.settings.nudge_shiftpush_size"; type: MappingPropertyDescriptor.Integer; value: 11 /* 32 beats */ }
  MappingPropertyDescriptor { id: nudgePushActionProp; path: "mapping.settings.nudge_push_action"; type: MappingPropertyDescriptor.Integer; value: 0 /* Tempo Bend */ }
  MappingPropertyDescriptor { id: nudgeShiftPushActionProp; path: "mapping.settings.nudge_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: 1 /* Beatjump */ }
  
  MappingPropertyDescriptor { id: hotcue12PushActionProp; path: "mapping.settings.hotcue12_push_action"; type: MappingPropertyDescriptor.Integer; value: 0 /* Hotcues 1-2 */ }
  MappingPropertyDescriptor { id: hotcue34PushActionProp; path: "mapping.settings.hotcue34_push_action"; type: MappingPropertyDescriptor.Integer; value: 1 /* Hotcues 3-4 */ }
  MappingPropertyDescriptor { id: hotcue12ShiftPushActionProp; path: "mapping.settings.hotcue12_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: 4 /* Delete Hotcues 1-2 */ }
  MappingPropertyDescriptor { id: hotcue34ShiftPushActionProp; path: "mapping.settings.hotcue34_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: 5 /* Delete Hotcues 3-4 */ }

  MappingPropertyDescriptor { id: browseShiftActionProp; path: "mapping.settings.browse_shift_action"; type: MappingPropertyDescriptor.Integer; value: 0 /* Tree Up/Down */ }
  MappingPropertyDescriptor { id: browseShiftPushActionProp; path: "mapping.settings.browse_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: 0 /* Expand/Collapse tree folders */ }

  MappingPropertyDescriptor { id: loopShiftActionProp; path: "mapping.settings.loop_shift_action"; type: MappingPropertyDescriptor.Integer; value: 0 /* Beatjump Loop */ }

  MappingPropertyDescriptor { id: maximizeBrowserWhenBrowsingProp; path: "mapping.settings.maximize_browser_when_browsing"; type: MappingPropertyDescriptor.Boolean; value: false }

  MappingPropertyDescriptor { path: "mapping.settings.deck_display.main_info"; type: MappingPropertyDescriptor.Integer; value: 0 /* Remaining Time */ }

  // Color override
  MappingPropertyDescriptor { path: "mapping.settings.12_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.hotcues.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.12_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.hotcues.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.12_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.hotcues.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.12_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.hotcues.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.12_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.34_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.hotcues.3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.34_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.hotcues.4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.34_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.hotcues.3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.34_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.hotcues.4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.34_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.nudge_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.nudge_slow.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.nudge_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.nudge_fast.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.nudge_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.nudge_slow.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.nudge_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.nudge_fast.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.nudge_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.cue_rev_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.cue.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_rev_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.rev.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_rev_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.cue.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_rev_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.rev.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_rev_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.play_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.play.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.play_button.custom_color"; input: false } }
  Wire { from: "surface.right.play.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.play_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.sync_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.sync.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.sync_button.custom_color"; input: false } }
  Wire { from: "surface.right.sync.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.sync_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.fx_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.fx.buttons.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.fx.buttons.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.fx.buttons.3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.fx.buttons.4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.fx.buttons.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.fx.buttons.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.fx.buttons.3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.fx.buttons.4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.assign_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.assign.left.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.assign.right.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.assign.left.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.assign.right.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { id: showEndWarningProp; path: "mapping.settings.bottom_leds.show_end_warning"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: showSyncWarningProp; path: "mapping.settings.bottom_leds.show_sync_warning"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: showActiveLoopProp; path: "mapping.settings.bottom_leds.show_active_loop"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: bottomLedsDefaultColorProp; path: "mapping.settings.bottom_leds.default_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }

  // Shift
  property alias shift: shiftProp
  MappingPropertyDescriptor { id: shiftProp; path: mapping.propertiesPath + ".shift"; type: MappingPropertyDescriptor.Boolean; value: false }
  Wire { from: "surface.shift";  to: DirectPropertyAdapter { path: mapping.propertiesPath + ".shift"  } }

  X1MK3Side
  {
    name: "left_deck"
    surface: "surface.left"
    propertiesPath: mapping.propertiesPath + ".left.deck"
    active: deviceSetup.state == DeviceSetupState.assigned

    shift: shiftProp.value
    deckIdx: deviceSetup.leftDeckIdx
    fxSectionLayer: fxSection.layer

    nudgePushAction: nudgePushActionProp.value
    nudgeShiftPushAction: nudgeShiftPushActionProp.value

    hotcue12PushAction: hotcue12PushActionProp.value
    hotcue34PushAction: hotcue34PushActionProp.value
    hotcue12ShiftPushAction: hotcue12ShiftPushActionProp.value
    hotcue34ShiftPushAction: hotcue34ShiftPushActionProp.value

    browseShiftAction: browseShiftActionProp.value
    browseShiftPushAction: browseShiftPushActionProp.value

    loopShiftAction: loopShiftActionProp.value

    showEndWarning: showEndWarningProp.value
    showSyncWarning: showSyncWarningProp.value
    showActiveLoop: showActiveLoopProp.value
    bottomLedsDefaultColor: bottomLedsDefaultColorProp.value
  }

  X1MK3Side
  {
    name: "right_deck"
    surface: "surface.right"
    propertiesPath: mapping.propertiesPath + ".right.deck"
    active: deviceSetup.state == DeviceSetupState.assigned

    shift: shiftProp.value
    deckIdx: deviceSetup.rightDeckIdx
    fxSectionLayer: fxSection.layer

    nudgePushAction: nudgePushActionProp.value
    nudgeShiftPushAction: nudgeShiftPushActionProp.value

    hotcue12PushAction: hotcue12PushActionProp.value
    hotcue34PushAction: hotcue34PushActionProp.value
    hotcue12ShiftPushAction: hotcue12ShiftPushActionProp.value
    hotcue34ShiftPushAction: hotcue34ShiftPushActionProp.value

    browseShiftAction: browseShiftActionProp.value
    browseShiftPushAction: browseShiftPushActionProp.value

    loopShiftAction: loopShiftActionProp.value

    showEndWarning: showEndWarningProp.value
    showSyncWarning: showSyncWarningProp.value
    showActiveLoop: showActiveLoopProp.value
    bottomLedsDefaultColor: bottomLedsDefaultColorProp.value
  }

  AppProperty { id: browserFullScreen; path: "app.traktor.browser.full_screen" }

  property bool fullScreenTimerRunning: false

  SwitchTimer {
    name: "show_browser_full_screen_timer";
    setTimeout: 0;
    resetTimeout: 2000;

    onSet: {
      fullScreenTimerRunning = true;
      browserFullScreen.value = true;
    }

    onReset: {
      browserFullScreen.value = false
      fullScreenTimerRunning = false;
    }
  }

  WiresGroup {
    enabled: (deviceSetup.state == DeviceSetupState.assigned) && maximizeBrowserWhenBrowsingProp.value

    Wire {
      from: Or
      {
        inputs: [ "surface.left.browse.is_turned", "surface.right.browse.is_turned" ]
      }
      to: "show_browser_full_screen_timer.input"
    }

    Wire {
      enabled: shiftProp.value && browseShiftPushActionProp.value == BrowseEncoderAction.browse_expand_tree;
      from: Or
      {
        inputs: [ "surface.left.browse.push", "surface.right.browse.push" ]
      }
      to: "show_browser_full_screen_timer.input"
    }

    Wire {
      enabled: !shiftProp.value && fullScreenTimerRunning && browserFullScreen.value;
      from: Or
      {
        inputs: [ "surface.left.browse.push", "surface.right.browse.push" ]
      }
      to: ValuePropertyAdapter { path: "app.traktor.browser.full_screen"; output: false; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled }
    }
  }

  X1MK3FXSection
  {
    id: fxSection
    name: "fx_section"
    surface: "surface"
    shift: shiftProp.value
    propertiesPath: mapping.propertiesPath
    active: deviceSetup.state == DeviceSetupState.assigned

    leftDeckIdx: deviceSetup.leftDeckIdx
    rightDeckIdx: deviceSetup.rightDeckIdx

    leftPrimaryFxIdx: deviceSetup.leftPrimaryFxIdx
    rightPrimaryFxIdx: deviceSetup.rightPrimaryFxIdx
    leftSecondaryFxIdx: deviceSetup.leftSecondaryFxIdx
    rightSecondaryFxIdx: deviceSetup.rightSecondaryFxIdx
  }

  // Blinking timer for screens
  MappingPropertyDescriptor { id: blinkerProp; path: mapping.propertiesPath + ".blinker"; type: MappingPropertyDescriptor.Boolean; value: false }
  Timer { interval: 500; running: true; repeat: true; onTriggered: blinkerProp.value = blinkerProp.value ? false : true; }
} //Mapping
