
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
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_bend_sensitivity";        type: MappingPropertyDescriptor.Float;      value: 50.0;   min: 0.0; max: 100.0; }
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_bend_invert";             type: MappingPropertyDescriptor.Boolean;    value: false;  }
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_scratch_sensitivity";     type: MappingPropertyDescriptor.Float;      value: 50.0;   min: 0.0; max: 100.0; }
  MappingPropertyDescriptor { path: "mapping.settings.touchstrip_scratch_invert";          type: MappingPropertyDescriptor.Boolean;    value: true;  }

  //------------------------------------------------------------------------------------------------------------------
  // CROSS-DISPLAY INTERACTION
  // Browser should be open on one display only
  //------------------------------------------------------------------------------------------------------------------

  /*
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
  */

  //------------------------------------------------------------------------------------------------------------------

  onMappingLoaded:
  {
    deck.initializeModule();
  }

  //------------------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------------------

  D2 { name: "surface" }

  //------------------------------------------------------------------------------------------------------------------
  //  LED Brightness wiring
  //------------------------------------------------------------------------------------------------------------------

  MappingPropertyDescriptor { path: "mapping.settings.led_on_brightness";      type: MappingPropertyDescriptor.Integer;   value: 100; min: 50; max: 100 }
  MappingPropertyDescriptor { path: "mapping.settings.led_dimmed_percentage";  type: MappingPropertyDescriptor.Integer;   value: 25;  min: 25; max: 50  }

  DirectPropertyAdapter { name: "LEDBrightnessOn";      path: "mapping.settings.led_on_brightness";      input: false }
  DirectPropertyAdapter { name: "LEDDimmedPercentage";  path: "mapping.settings.led_dimmed_percentage";  input: false }

  Wire { from: "surface.led_on_brightness.write";      to: "LEDBrightnessOn.read"     }
  Wire { from: "surface.led_dimmed_brightness.write";  to: "LEDDimmedPercentage.read" }

  //------------------------------------------------------------------------------------------------------------------

  Deck_S8Style
  {
    id: deck
    name: "deck"
    surface: "surface"
    settingsPath: "mapping.settings"
    propertiesPath: "mapping.state"
    useMIDIControls: useMIDIControls.value
    decksAssignment: decksAssignment.value
  }
 
  //------------------------------------------------------------------------------------------------------------------
  // Decks Assignment / Deck focus
  //------------------------------------------------------------------------------------------------------------------

  property bool isInDecksAssignmentMode: false
  property bool triggerDeckFocusSwitch:  true

  MappingPropertyDescriptor { id: decksAssignment; path: "mapping.settings.decks_assignment"; type: MappingPropertyDescriptor.Integer; value: DecksAssignment.AC; }

  ButtonScriptAdapter 
  { 
    name: "deck_button_adapter"
    onPress: 
    { 
      isInDecksAssignmentMode = true;
      triggerDeckFocusSwitch  = true
    } 
    onRelease:
    {
      if (triggerDeckFocusSwitch) deck.deckFocus = !deck.deckFocus;
      isInDecksAssignmentMode = false;
    }
    brightness: 1.0; 
    color: (deck.deckFocus ? Color.White : Color.Blue) 
  } 

  Wire { from: "surface.deck"; to: "deck_button_adapter" }

  WiresGroup
  {
    enabled: isInDecksAssignmentMode

    Wire 
    {
      from: "surface.fx.assign.1"
      to: ButtonScriptAdapter
      {
        onPress:
        {
          decksAssignment.value  = DecksAssignment.AC;
          deck.deckFocus         = false;
          triggerDeckFocusSwitch = false;
        }
        brightness: (decksAssignment.value == DecksAssignment.AC)
      }
    }

    Wire 
    {
      from: "surface.fx.assign.2"
      to: ButtonScriptAdapter
      {
        onPress:
        {
          decksAssignment.value  = DecksAssignment.BD;
          deck.deckFocus         = false;
          triggerDeckFocusSwitch = false;
        }
        brightness: (decksAssignment.value == DecksAssignment.BD)
      }
    }

    Wire 
    {
      from: "surface.fx.assign.3"
      to: ButtonScriptAdapter
      {
        onPress:
        {
          decksAssignment.value  = DecksAssignment.AC;
          deck.deckFocus         = true;
          triggerDeckFocusSwitch = false;
        }
        brightness: (decksAssignment.value == DecksAssignment.AC)
      }
    }

    Wire 
    {
      from: "surface.fx.assign.4"
      to: ButtonScriptAdapter
      {
        onPress:
        {
          decksAssignment.value  = DecksAssignment.BD;
          deck.deckFocus         = true;
          triggerDeckFocusSwitch = false;
        }
        brightness: (decksAssignment.value == DecksAssignment.BD)
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------
  // Fx Assignment
  //------------------------------------------------------------------------------------------------------------------

  AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }

  WiresGroup
  {
    enabled: !isInDecksAssignmentMode

    WiresGroup
    {
      enabled: !deck.shift
      WiresGroup
      {
        enabled: decksAssignment.value == DecksAssignment.AC
        Wire { from: "surface.fx.assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.1"; } }
        Wire { from: "surface.fx.assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.1"; } }
        Wire { from: "surface.fx.assign.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.1"; } }
        Wire { from: "surface.fx.assign.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.1"; } }
      }

      WiresGroup
      {
        enabled: decksAssignment.value == DecksAssignment.BD
        Wire { from: "surface.fx.assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.2"; } }
        Wire { from: "surface.fx.assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.2"; } }
        Wire { from: "surface.fx.assign.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.2"; } }
        Wire { from: "surface.fx.assign.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.2"; } }
      }
    }

    WiresGroup
    {
      enabled: deck.shift && (fxMode.value == FxMode.FourFxUnits)
      WiresGroup
      {
        enabled: decksAssignment.value == DecksAssignment.AC
        Wire { from: "surface.fx.assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.3"; } }
        Wire { from: "surface.fx.assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.3"; } }
        Wire { from: "surface.fx.assign.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.3"; } }
        Wire { from: "surface.fx.assign.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.3"; } }
      }

      WiresGroup
      {
        enabled: decksAssignment.value == DecksAssignment.BD
        Wire { from: "surface.fx.assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.4"; } }
        Wire { from: "surface.fx.assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.4"; } }
        Wire { from: "surface.fx.assign.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.4"; } }
        Wire { from: "surface.fx.assign.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.4"; } }
      }
    }
  }
} //Mapping
