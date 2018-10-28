import CSI 1.0
import QtQuick 2.0

import "../../Defines"
import "../Common"
import "../Common/Settings"

Mapping
{
  //------------------------------------------------------------------------------------------------------------------
  // LOOP/BEATJUMP SIZE SETTINGS
  //------------------------------------------------------------------------------------------------------------------
  LoopModePads
  {
    name: "loop_mode_pads"
    loopSizePath: "mapping.settings.pad_loop_size" 
    beatJumpPath: "mapping.settings.pad_jump_size" 
  }

  //------------------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------------------

  // Settings - MIDI Controls
  MappingPropertyDescriptor { id: useMIDIControls;                  path: "mapping.settings.use_midi_controls";                  type: MappingPropertyDescriptor.Boolean;    value: false }

  // Settings - Touch Controls
  MappingPropertyDescriptor { id: showBrowserOnTouch;               path: "mapping.settings.show_browser_on_touch";              type: MappingPropertyDescriptor.Boolean;    value: false }
  MappingPropertyDescriptor { id: showFxOnTouch;                    path: "mapping.settings.show_fx_panels_on_touch";            type: MappingPropertyDescriptor.Boolean;    value: true  }
  MappingPropertyDescriptor { id: showPerformanceControlsOnTouch;   path: "mapping.settings.show_performance_control_on_touch";  type: MappingPropertyDescriptor.Boolean;    value: true  }

  // Settings - Touchstrip
  MappingPropertyDescriptor { id: scratchWithTouchstrip;            path: "mapping.settings.scratch_with_touchstrip";            type: MappingPropertyDescriptor.Boolean;    value: false }
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_bend_sensitivity";        type: MappingPropertyDescriptor.Float;      value: 50.0;   min: 0.0; max: 100.0 }
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_bend_invert";             type: MappingPropertyDescriptor.Boolean;    value: false  }
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_scratch_sensitivity";     type: MappingPropertyDescriptor.Float;      value: 50.0;   min: 0.0; max: 100.0 }
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_scratch_invert";          type: MappingPropertyDescriptor.Boolean;    value: true   }

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

    S8 { name: "s8" }

  //------------------------------------------------------------------------------------------------------------------
  //  LED Brightness wiring
  //------------------------------------------------------------------------------------------------------------------

  MappingPropertyDescriptor { path: "mapping.settings.led_on_brightness";      type: MappingPropertyDescriptor.Integer;   value: 100; min: 50; max: 100 }
  MappingPropertyDescriptor { path: "mapping.settings.led_dimmed_percentage";  type: MappingPropertyDescriptor.Integer;   value: 25;  min: 25; max: 50  }

  DirectPropertyAdapter { name: "LEDBrightnessOn";      path: "mapping.settings.led_on_brightness";      input: false }
  DirectPropertyAdapter { name: "LEDDimmedPercentage";  path: "mapping.settings.led_dimmed_percentage";  input: false }

  Wire { from: "s8.led_on_brightness.write";      to: "LEDBrightnessOn.read"     }
  Wire { from: "s8.led_dimmed_brightness.write";  to: "LEDDimmedPercentage.read" }

  //------------------------------------------------------------------------------------------------------------------

  Deck_S8Style
  {
    id: left
    name: "left"
    surface: "s8.left"
    settingsPath: "mapping.settings.left"
    propertiesPath: "mapping.state.left"
    decksAssignment: DecksAssignment.AC
    useMIDIControls: useMIDIControls.value
  }

  Deck_S8Style
  {
    id: right
    name: "right"
    surface: "s8.right"
    settingsPath: "mapping.settings.right"
    propertiesPath: "mapping.state.right"
    decksAssignment: DecksAssignment.BD
    useMIDIControls: useMIDIControls.value
  }

  Mixer
  {
    name: "mixer"
    surface: "s8"
    shift: left.shift || right.shift
  }

  //------------------------------------------------------------------------------------------------------------------
  //  Deck focus
  //------------------------------------------------------------------------------------------------------------------

  Wire
  {
    from: "s8.left.deck"
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
    from: "s8.right.deck"
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

