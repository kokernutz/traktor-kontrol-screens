import CSI 1.0
import QtQuick 2.0

import "../../Defines"
import "../Common/Settings"

Mapping
{
  id: s5mapping;

  // keep this as a dummy to avoid having qml warnings in the screen
  MappingPropertyDescriptor { id: useMIDIControls; path: "mapping.settings.use_midi_controls"; type: MappingPropertyDescriptor.Boolean; value: false }

  //------------------------------------------------------------------------------------------------------------------
  // 
  //------------------------------------------------------------------------------------------------------------------

  // Settings - Touch Controls
  MappingPropertyDescriptor { id: showBrowserOnTouch;               path: "mapping.settings.show_browser_on_touch";              type: MappingPropertyDescriptor.Boolean;    value: false;  }
  MappingPropertyDescriptor { id: showFxOnTouch;                    path: "mapping.settings.show_fx_panels_on_touch";            type: MappingPropertyDescriptor.Boolean;    value: true;  }
  MappingPropertyDescriptor { id: showPerformanceControlsOnTouch;   path: "mapping.settings.show_performance_control_on_touch";  type: MappingPropertyDescriptor.Boolean;    value: true;  }

  // Settings - Touchstrip
  MappingPropertyDescriptor { id: scratchWithTouchstrip;            path: "mapping.settings.scratch_with_touchstrip";            type: MappingPropertyDescriptor.Boolean;    value: false }
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_bend_sensitivity";        type: MappingPropertyDescriptor.Float;      value: 50.0;   min: 0.0; max: 100.0 }
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_bend_invert";             type: MappingPropertyDescriptor.Boolean;    value: false  }
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_scratch_sensitivity";     type: MappingPropertyDescriptor.Float;      value: 50.0;   min: 0.0; max: 100.0 }
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_scratch_invert";          type: MappingPropertyDescriptor.Boolean;    value: true   }

  MappingPropertyDescriptor { id: stemSelectorModeHold; path: "mapping.settings.stem_select_hold";   type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { id: stemResetOnLoad;      path: "mapping.settings.stem_reset_on_load"; type: MappingPropertyDescriptor.Boolean; value: true  }

  //------------------------------------------------------------------------------------------------------------------
  // CROSS-DISPLAY INTERACTION
  // Browser should be open on one display only
  //------------------------------------------------------------------------------------------------------------------

  property bool leftScreenViewValue: left.screenView.value
  property bool rightScreenViewValue: right.screenView.value

  onLeftScreenViewValueChanged:
  {
    if (left.screenView.value == ScreenView.browser && right.screenView.value == ScreenView.browser)
    {
      right.screenView.value = ScreenView.deck;
    }
  }

  onRightScreenViewValueChanged:
  {
    if (left.screenView.value == ScreenView.browser && right.screenView.value == ScreenView.browser)
    {
      left.screenView.value = ScreenView.deck;
    }
  }

  //------------------------------------------------------------------------------------------------------------------

  onMappingLoaded:
  {
    left.initializeModule();
    right.initializeModule();
  }

  //------------------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------------------

  S5 { name: "s5" }

  //------------------------------------------------------------------------------------------------------------------
  //  LED Brightness wiring
  //------------------------------------------------------------------------------------------------------------------

  MappingPropertyDescriptor { path: "mapping.settings.led_on_brightness";      type: MappingPropertyDescriptor.Integer;   value: 100; min: 50; max: 100 }
  MappingPropertyDescriptor { path: "mapping.settings.led_dimmed_percentage";  type: MappingPropertyDescriptor.Integer;   value: 25;  min: 25; max: 50  }

  DirectPropertyAdapter { name: "LEDBrightnessOn";      path: "mapping.settings.led_on_brightness";      input: false }
  DirectPropertyAdapter { name: "LEDDimmedPercentage";  path: "mapping.settings.led_dimmed_percentage";  input: false }

  Wire { from: "s5.led_on_brightness.write";      to: "LEDBrightnessOn.read"     }
  Wire { from: "s5.led_dimmed_brightness.write";  to: "LEDDimmedPercentage.read" }

  //------------------------------------------------------------------------------------------------------------------

  S5Deck
  {
    id: left
    name: "left"
    surface: "s5.left"
    settingsPath: "mapping.settings.left"
    propertiesPath: "mapping.state.left"
    decksAssignment: DecksAssignment.AC
    stemResetOnLoad: stemResetOnLoad.value
    stemSelectorModeHold: stemSelectorModeHold.value
  }

  S5Deck
  {
    id: right
    name: "right"
    surface: "s5.right"
    settingsPath: "mapping.settings.right"
    propertiesPath: "mapping.state.right"
    decksAssignment: DecksAssignment.BD
    stemResetOnLoad: stemResetOnLoad.value
    stemSelectorModeHold: stemSelectorModeHold.value
  }
    
  Mixer
  {
    name: "mixer"
    surface: "s5"
    shift: left.shift || right.shift
  }

  //------------------------------------------------------------------------------------------------------------------
  //  Deck focus
  //------------------------------------------------------------------------------------------------------------------

  Wire
  {
    from: "s5.left.deck"
    to: ButtonScriptAdapter
    {
      onPress:
      {
        left.deckFocus = !left.deckFocus;
      }
      brightness: 1.0
      color: (left.deckFocus ? Color.White : Color.Blue)
    }
  }

  Wire
  {
    from: "s5.right.deck"
    to: ButtonScriptAdapter
    {
      onPress:
      {
        right.deckFocus = !right.deckFocus;
      }
      brightness: 1.0
      color: (right.deckFocus ? Color.White : Color.Blue)
    }
  }
} // mapping

