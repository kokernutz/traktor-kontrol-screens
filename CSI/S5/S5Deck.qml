import CSI 1.0
import QtQuick 2.0

import "../../Defines"
import "../Common"

Module
{
  id: module
  property bool useMIDIControls: false
  property bool stemResetOnLoad: true
  property bool stemSelectorModeHold: false
  property string surface
  property int decksAssignment: DecksAssignment.AC
  property string settingsPath: "path"
  property string propertiesPath: "path"
  property alias deckFocus: deckFocusProp.value
  function initializeModule()
  {
    updateFocusDependentDeckTypes();

    updateDeckPadsMode(topDeckType, topDeckPadsMode);
    updateDeckPadsMode(bottomDeckType, bottomDeckPadsMode);
  }

  property bool keyOrBPMOverlay: false;

  MappingPropertyDescriptor {
    id: screenOverlay;
    path: propertiesPath + ".overlay";
    type: MappingPropertyDescriptor.Integer;
    value: Overlay.none;
    onValueChanged: {
        keyOrBPMOverlay = screenOverlay.value == Overlay.bpm || screenOverlay.value == Overlay.key;
      if (value == Overlay.fx) {
        editMode.value  = editModeNone;
      }
      // idle timeout for BPM and Key overlays
      if (keyOrBPMOverlay) {
        overlay_countdown.restart();
      }
    }
  }

  MappingPropertyDescriptor { path: propertiesPath + ".top_info_show"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: propertiesPath + ".bottom_info_show"; type: MappingPropertyDescriptor.Boolean; value: false }

  AppProperty { id: masterDeckIdProp; path: "app.traktor.masterclock.source_id" }
  AppProperty { id: isTempoSynced;    path: "app.traktor.decks." + (focusedDeckId) + ".sync.enabled" }

  AppProperty { 
    path: "app.traktor.masterclock.tempo"; 
    onValueChanged: { 
      var masterDeckId = masterDeckIdProp.value + 1;
      if( screenOverlay.value == Overlay.bpm && (isTempoSynced.value || masterDeckId == focusedDeckId) )
        overlay_countdown.restart(); 
    } 
  }
  
  //------------------------------------------------------------------------------------------------------------------
  //  Footer Selection
  //------------------------------------------------------------------------------------------------------------------
  
  MappingPropertyDescriptor {
    id: selectedFooterItem
    path: propertiesPath + ".selected_footer_item"
    type: MappingPropertyDescriptor.Integer
    value: 1
    min: 1
    max: 4
  }
  
  WiresGroup
  {
    enabled: isInEditMode || isInBrowser
    
    Wire { from: "%surface%.display.buttons.8";  to: RelativePropertyAdapter { path: propertiesPath + ".selected_footer_item"; wrap: true; mode: RelativeMode.Increment } }
    Wire { from: "%surface%.display.buttons.4";  to: RelativePropertyAdapter { path: propertiesPath + ".selected_footer_item"; wrap: true; mode: RelativeMode.Decrement } }
  }

  //------------------------------------------------------------------------------------------------------------------
  //  KEY/BPM IDLE TIMEOUT METHODS
  //------------------------------------------------------------------------------------------------------------------

  Timer {
    id: overlay_countdown;
    interval: 2000;
    onTriggered:
    {
      if (keyOrBPMOverlay) {
        screenOverlay.value = Overlay.none;
      }
    }
  }

  Wire {
    enabled: keyOrBPMOverlay
    from: Or
    {
      inputs:
      [
        "%surface%.browse.push",
        "%surface%.browse.touch",
        "%surface%.browse.is_turned",
        "%surface%.back"
      ]
    }
    to: ButtonScriptAdapter{
        onPress: overlay_countdown.stop()
        onRelease: overlay_countdown.restart()
    }
  }

 //------------------------------------------------------------------------------------------------------------------
 //
 //------------------------------------------------------------------------------------------------------------------
  
  MappingPropertyDescriptor { id: screenIsSingleDeck;  path: propertiesPath + ".deck_single";   type: MappingPropertyDescriptor.Boolean; value: true }

  MappingPropertyDescriptor { id: deckFocusProp; path: propertiesPath + ".deck_focus"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { updateFocusDependentDeckTypes(); updateFooter(); updatePads(); updateEncoder(); resetStemSelection(); if(screenViewProp.value  == ScreenView.deck) { screenOverlay.value  = Overlay.none; } editMode.value  = editModeNone; } }

  readonly property int focusedDeckId:   (deckFocus ? bottomDeckId : topDeckId)
  readonly property int unfocusedDeckId: (deckFocus ? topDeckId : bottomDeckId)

  readonly property int padsFocusedDeckId:    (padsFocus.value    ? bottomDeckId : topDeckId)
  readonly property int footerFocusedDeckId:  (footerFocus.value  ? bottomDeckId : topDeckId)
  readonly property int encoderFocusedDeckId: (encoderFocus.value ? bottomDeckId : topDeckId)

  property int topDeckType:    (decksAssignment == DecksAssignment.AC ? deckAType : deckBType)
  property int bottomDeckType: (decksAssignment == DecksAssignment.AC ? deckCType : deckDType)

  property int focusedDeckType
  property int unfocusedDeckType

  function updateFocusDependentDeckTypes()
  {
    focusedDeckType   = (deckFocus ? bottomDeckType : topDeckType);
    unfocusedDeckType = (deckFocus ? topDeckType : bottomDeckType);
  }

  onTopDeckTypeChanged:
  {
    updateFocusDependentDeckTypes();
    updateEditMode();
    updateEncoder();

    defaultFooterPage(topDeckType, topDeckFooterPage);

    updateDeckPadsMode(topDeckType, topDeckPadsMode);
    validateDeckPadsMode(bottomDeckType, topDeckType, bottomDeckPadsMode);
  }

  onBottomDeckTypeChanged:
  {
    updateFocusDependentDeckTypes();
    updateEditMode();
    updateEncoder();

    defaultFooterPage(bottomDeckType, bottomDeckFooterPage);

    updateDeckPadsMode(bottomDeckType, bottomDeckPadsMode);
    validateDeckPadsMode(topDeckType, bottomDeckType, topDeckPadsMode);
  }

  onFocusedDeckTypeChanged:
  {
    showDisplayButtonArea.value = true;
    screenOverlay.value = Overlay.none;
    resetStemSelection();
  }

  AppProperty { id: deckAIsLoaded; path: "app.traktor.decks.1.is_loaded" }
  AppProperty { id: deckBIsLoaded; path: "app.traktor.decks.2.is_loaded" }
  AppProperty { id: deckCIsLoaded; path: "app.traktor.decks.3.is_loaded" }
  AppProperty { id: deckDIsLoaded; path: "app.traktor.decks.4.is_loaded" }

  readonly property bool footerHasDetails:     (hasBottomControls(deckAType) && decksAssignment == DecksAssignment.AC)
                                            || (hasBottomControls(deckCType) && decksAssignment == DecksAssignment.AC)
                                            || (hasBottomControls(deckBType) && decksAssignment == DecksAssignment.BD)
                                            || (hasBottomControls(deckDType) && decksAssignment == DecksAssignment.BD)

  readonly property bool footerShouldPopup:    (hasBottomControls(deckAType) && deckAIsLoaded.value && decksAssignment == DecksAssignment.AC)
                                            || (hasBottomControls(deckCType) && deckCIsLoaded.value && decksAssignment == DecksAssignment.AC)
                                            || (hasBottomControls(deckBType) && deckBIsLoaded.value && decksAssignment == DecksAssignment.BD)
                                            || (hasBottomControls(deckDType) && deckDIsLoaded.value && decksAssignment == DecksAssignment.BD)

  MappingPropertyDescriptor { id: browserIsTemporary;  path: propertiesPath + ".browser.is_temporary";  type: MappingPropertyDescriptor.Boolean; value: false }
  
  readonly property bool isInBrowser: (screenViewProp.value == ScreenView.browser)
  onIsInBrowserChanged: updateEncoder()

  //------------------------------------------------------------------------------------------------------------------
  //  GENERIC PURPOSE CONSTANTS
  //------------------------------------------------------------------------------------------------------------------  

  readonly property real onBrightness:     1.0
  readonly property real dimmedBrightness: 0.0

  readonly property int touchstripLedBarSize: 25

  //------------------------------------------------------------------------------------------------------------------
  // DECK TYPES of Deck A, B, C and D
  //------------------------------------------------------------------------------------------------------------------

  AppProperty { id: deckADeckType;   path: "app.traktor.decks.1.type" }
  AppProperty { id: deckBDeckType;   path: "app.traktor.decks.2.type" }
  AppProperty { id: deckCDeckType;   path: "app.traktor.decks.3.type" }
  AppProperty { id: deckDDeckType;   path: "app.traktor.decks.4.type" }
  AppProperty { id: deckADirectThru; path: "app.traktor.decks.1.direct_thru" }
  AppProperty { id: deckBDirectThru; path: "app.traktor.decks.2.direct_thru" }
  AppProperty { id: deckCDirectThru; path: "app.traktor.decks.3.direct_thru" }
  AppProperty { id: deckDDirectThru; path: "app.traktor.decks.4.direct_thru" }

  readonly property int thruDeckType:   4
  readonly property int deckAType : deckADirectThru.value ? thruDeckType : deckADeckType.value;
  readonly property int deckBType : deckBDirectThru.value ? thruDeckType : deckBDeckType.value;
  readonly property int deckCType : deckCDirectThru.value ? thruDeckType : deckCDeckType.value;
  readonly property int deckDType : deckDDirectThru.value ? thruDeckType : deckDDeckType.value;

  function hasEditMode       (deckType) { return deckType == DeckType.Track  || deckType == DeckType.Stem;}
  function hasHotcues        (deckType) { return deckType == DeckType.Track  || deckType == DeckType.Stem;}
  function hasSeek           (deckType) { return deckType == DeckType.Track  || deckType == DeckType.Stem;}
  function hasWaveform       (deckType) { return deckType == DeckType.Track  || deckType == DeckType.Stem;}
  function hasBpmAdjust      (deckType) { return deckType == DeckType.Track  || deckType == DeckType.Stem || deckType == DeckType.Remix;}
  function hasKeylock        (deckType) { return deckType == DeckType.Track  || deckType == DeckType.Stem;}

  function hasTransport      (deckType) { return deckType == DeckType.Track  || deckType == DeckType.Stem || deckType == DeckType.Remix;}
  function hasButtonArea     (deckType) { return deckType == DeckType.Track  || deckType == DeckType.Stem || deckType == DeckType.Remix;}
  function hasLoopMode       (deckType) { return deckType == DeckType.Track  || deckType == DeckType.Stem || deckType == DeckType.Remix;}
  function hasFreezeMode     (deckType) { return deckType == DeckType.Track  || deckType == DeckType.Stem || deckType == DeckType.Remix;}

  function hasBottomControls (deckType) { return deckType == DeckType.Stem;  }
  function hasRemixMode      (deckType) { return deckType == DeckType.Remix; }
  function hasStemMode       (deckType) { return deckType == DeckType.Stem;  }

  //------------------------------------------------------------------------------------------------------------------
  //  Soft takeover knobs
  //------------------------------------------------------------------------------------------------------------------ 

  SoftTakeoverIndicator
  {
    name: "softtakeover_knobs1"
    surfaceObject: surface + ".fx.knobs.1"
    propertiesPath: module.propertiesPath + ".softtakeover.knobs.1";
  }

  SoftTakeoverIndicator
  {
    name: "softtakeover_knobs2"
    surfaceObject: surface + ".fx.knobs.2"
    propertiesPath: module.propertiesPath + ".softtakeover.knobs.2";
  }

  SoftTakeoverIndicator
  {
    name: "softtakeover_knobs3"
    surfaceObject: surface + ".fx.knobs.3"
    propertiesPath: module.propertiesPath + ".softtakeover.knobs.3";
  }

  SoftTakeoverIndicator
  {
    name: "softtakeover_knobs4"
    surfaceObject: surface + ".fx.knobs.4"
    propertiesPath: module.propertiesPath + ".softtakeover.knobs.4";
  }

  MappingPropertyDescriptor { id: showSofttakeoverKnobs;  path: propertiesPath + ".softtakeover.show_knobs";   type: MappingPropertyDescriptor.Boolean; value: false }

  SwitchTimer { name: "softtakeover_knobs_timer";  resetTimeout: 300 }

  Wire
  {
    from:
      Or
      {
        inputs:
        [
          "softtakeover_knobs1.indicate",
          "softtakeover_knobs2.indicate",
          "softtakeover_knobs3.indicate",
          "softtakeover_knobs4.indicate"
        ]
      }
    to: "softtakeover_knobs_timer.input"
  }

  // keep this in to avoid warning messages from the screen qml (because it relies on this properties)
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.show_faders";      type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.1.active";  type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.1.input";   type: MappingPropertyDescriptor.Float;   value: 0.0   }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.1.output";  type: MappingPropertyDescriptor.Float;   value: 0.0   }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.1.active";  type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.2.input";   type: MappingPropertyDescriptor.Float;   value: 0.0   }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.2.output";  type: MappingPropertyDescriptor.Float;   value: 0.0   }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.2.active";  type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.2.input";   type: MappingPropertyDescriptor.Float;   value: 0.0   }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.3.output";  type: MappingPropertyDescriptor.Float;   value: 0.0   }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.3.active";  type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.3.input";   type: MappingPropertyDescriptor.Float;   value: 0.0   }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.3.output";  type: MappingPropertyDescriptor.Float;   value: 0.0   }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.4.active";  type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.4.input";   type: MappingPropertyDescriptor.Float;   value: 0.0   }
  MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.4.output";  type: MappingPropertyDescriptor.Float;   value: 0.0   }

  //------------------------------------------------------------------------------------------------------------------
  //  GENERIC PURPOSE PROPERTIES
  //------------------------------------------------------------------------------------------------------------------  

  AppProperty { id: deckALoopActive;   path: "app.traktor.decks.1.loop.is_in_active_loop" }
  AppProperty { id: deckBLoopActive;   path: "app.traktor.decks.2.loop.is_in_active_loop" }
  AppProperty { id: deckCLoopActive;   path: "app.traktor.decks.3.loop.is_in_active_loop" }
  AppProperty { id: deckDLoopActive;   path: "app.traktor.decks.4.loop.is_in_active_loop" }

  function getTopDeckId(assignment)
  {
    switch (assignment)
    {
      case DecksAssignment.AC: return 1;
      case DecksAssignment.BD: return 2;
    }
  }

  function getBottomDeckId(assignment)
  {
    switch (assignment)
    {
      case DecksAssignment.AC: return 3;
      case DecksAssignment.BD: return 4;
    }
  }

  property int topDeckId: getTopDeckId(decksAssignment);
  property int bottomDeckId: getBottomDeckId(decksAssignment);

  //------------------------------------------------------------------------------------------------------------------
  // ENCODER FOCUS AND MODE
  //------------------------------------------------------------------------------------------------------------------

  // Constants to use in enablers for loop encoder modes
  readonly property int encoderLoopMode:      1
  readonly property int encoderSlicerMode:    2
  readonly property int encoderRemixMode:     3
  readonly property int encoderCaptureMode:   4
  readonly property int encoderStemMode:      5
  readonly property int encoderBeatgridMode:  6
  readonly property int encoderBrowserMode:   7

  readonly property real encoderStepsizeStemControl: 0.025

  MappingPropertyDescriptor { id: encoderMode;   path: propertiesPath + ".encoder_mode";     type: MappingPropertyDescriptor.Integer;  value: encoderLoopMode  }
  MappingPropertyDescriptor { id: encoderFocus;  path: propertiesPath + ".encoder_focus";    type: MappingPropertyDescriptor.Boolean;  value: false            }

  //------------------------------------------------------------------------------------------------------------------

  MappingPropertyDescriptor { id: captureState;  path: propertiesPath + ".capture";  type: MappingPropertyDescriptor.Boolean;  value: false; onValueChanged: updateEncoder(); }
  MappingPropertyDescriptor { id: freezeState;   path: propertiesPath + ".freeze";   type: MappingPropertyDescriptor.Boolean;  value: false; onValueChanged: updateEncoder(); }
  MappingPropertyDescriptor { id: remixState;    path: propertiesPath + ".remix";    type: MappingPropertyDescriptor.Boolean;  value: false; onValueChanged: updateEncoder(); }

  MappingPropertyDescriptor { id: stemSelectorMode1;    path: propertiesPath + ".stem_selector_mode.1";   type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { id: stemSelectorMode2;    path: propertiesPath + ".stem_selector_mode.2";   type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { id: stemSelectorMode3;    path: propertiesPath + ".stem_selector_mode.3";   type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { id: stemSelectorMode4;    path: propertiesPath + ".stem_selector_mode.4";   type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { id: stemSelectorModeAny;  path: propertiesPath + ".stem_selector_mode.any"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: updateEncoder(); }
  
  function resetStemSelection()
  {
    stemSelectorMode1.value = false
    stemSelectorMode2.value = false
    stemSelectorMode3.value = false
    stemSelectorMode4.value = false
    stemSelectorModeAny.value = false
  }
  

  function updateEncoder()
  {
    if (isInEditMode)
    {
      encoderMode.value = encoderBeatgridMode;
    }
    else if (isInBrowser)
    {
      encoderMode.value = encoderBrowserMode;
    }
    else if (freezeState.value && !remixState.value)
    {
      encoderMode.value = encoderSlicerMode;
    }
    else if (captureState.value && !remixState.value)
    {
      encoderMode.value = encoderCaptureMode;
    }
    else if (remixState.value)
    {
      encoderMode.value = encoderRemixMode;
    }
    else if(stemSelectorModeAny.value)
    {
      encoderMode.value = encoderStemMode;
    }
    else
    {
      encoderMode.value = encoderLoopMode;
    }

    if (encoderMode.value == encoderCaptureMode || encoderMode.value == encoderRemixMode)
    {
      if (topDeckType == DeckType.Remix && bottomDeckType == DeckType.Remix)
      {
        encoderFocus.value = deckFocus;
      }
      else if (topDeckType == DeckType.Remix)
      {
        encoderFocus.value = false;
      }
      else if (bottomDeckType == DeckType.Remix)
      {
        encoderFocus.value = true;
      }
    }
    else
    {
      encoderFocus.value = deckFocus;
    }
  }

  //------------------------------------------------------------------------------------------------------------------
  //  RESET TO DECK VIEW AFTER LOAD
  //  After a deck has been loaded with new content the controller display is reset to default deck view
  //------------------------------------------------------------------------------------------------------------------

  AppProperty { path: "app.traktor.decks.1.is_loaded_signal";  onValueChanged: onDeckLoaded(1); }
  AppProperty { path: "app.traktor.decks.2.is_loaded_signal";  onValueChanged: onDeckLoaded(2); }
  AppProperty { path: "app.traktor.decks.3.is_loaded_signal";  onValueChanged: onDeckLoaded(3); }
  AppProperty { path: "app.traktor.decks.4.is_loaded_signal";  onValueChanged: onDeckLoaded(4); }

  function onDeckLoaded(deckId)
  {
    if (deckId == topDeckId || deckId == bottomDeckId)
    {
      if (screenViewProp.value == ScreenView.browser)
      {
        screenViewProp.value = ScreenView.deck;
      }
    }

    if (stemResetOnLoad && s5mapping.running && hasStemMode((deckId == focusedDeckId) ? focusedDeckType : unfocusedDeckType))
    {
      resetFocusedStemDeckVolumeAndFilter(deckId);
    }
  }

  AppProperty { id: topStemVolume1;   path: "app.traktor.decks."+ topDeckId + ".stems.1.volume" }
  AppProperty { id: topStemVolume2;   path: "app.traktor.decks."+ topDeckId + ".stems.2.volume" }
  AppProperty { id: topStemVolume3;   path: "app.traktor.decks."+ topDeckId + ".stems.3.volume" }
  AppProperty { id: topStemVolume4;   path: "app.traktor.decks."+ topDeckId + ".stems.4.volume" }
  AppProperty { id: topStemFilter1;   path: "app.traktor.decks."+ topDeckId + ".stems.1.filter_value" }
  AppProperty { id: topStemFilter2;   path: "app.traktor.decks."+ topDeckId + ".stems.2.filter_value" }
  AppProperty { id: topStemFilter3;   path: "app.traktor.decks."+ topDeckId + ".stems.3.filter_value" }
  AppProperty { id: topStemFilter4;   path: "app.traktor.decks."+ topDeckId + ".stems.4.filter_value" }
  AppProperty { id: topStemFilterOn1; path: "app.traktor.decks."+ topDeckId + ".stems.1.filter_on" }
  AppProperty { id: topStemFilterOn2; path: "app.traktor.decks."+ topDeckId + ".stems.2.filter_on" }
  AppProperty { id: topStemFilterOn3; path: "app.traktor.decks."+ topDeckId + ".stems.3.filter_on" }
  AppProperty { id: topStemFilterOn4; path: "app.traktor.decks."+ topDeckId + ".stems.4.filter_on" }

  AppProperty { id: bottomStemVolume1;   path: "app.traktor.decks."+ bottomDeckId + ".stems.1.volume" }
  AppProperty { id: bottomStemVolume2;   path: "app.traktor.decks."+ bottomDeckId + ".stems.2.volume" }
  AppProperty { id: bottomStemVolume3;   path: "app.traktor.decks."+ bottomDeckId + ".stems.3.volume" }
  AppProperty { id: bottomStemVolume4;   path: "app.traktor.decks."+ bottomDeckId + ".stems.4.volume" }
  AppProperty { id: bottomStemFilter1;   path: "app.traktor.decks."+ bottomDeckId + ".stems.1.filter_value" }
  AppProperty { id: bottomStemFilter2;   path: "app.traktor.decks."+ bottomDeckId + ".stems.2.filter_value" }
  AppProperty { id: bottomStemFilter3;   path: "app.traktor.decks."+ bottomDeckId + ".stems.3.filter_value" }
  AppProperty { id: bottomStemFilter4;   path: "app.traktor.decks."+ bottomDeckId + ".stems.4.filter_value" }
  AppProperty { id: bottomStemFilterOn1; path: "app.traktor.decks."+ bottomDeckId + ".stems.1.filter_on" }
  AppProperty { id: bottomStemFilterOn2; path: "app.traktor.decks."+ bottomDeckId + ".stems.2.filter_on" }
  AppProperty { id: bottomStemFilterOn3; path: "app.traktor.decks."+ bottomDeckId + ".stems.3.filter_on" }
  AppProperty { id: bottomStemFilterOn4; path: "app.traktor.decks."+ bottomDeckId + ".stems.4.filter_on" }


  function resetFocusedStemDeckVolumeAndFilter(deckId)
  {
    var defaultVolume   = 1.0;
    var defaultFilter   = 0.5;
    var defaultFilterOn = false;

    if (deckId == topDeckId)
    {
      topStemVolume1.value   = defaultVolume;
      topStemVolume2.value   = defaultVolume;
      topStemVolume3.value   = defaultVolume;
      topStemVolume4.value   = defaultVolume;
      topStemFilter1.value   = defaultFilter;
      topStemFilter2.value   = defaultFilter;
      topStemFilter3.value   = defaultFilter;
      topStemFilter4.value   = defaultFilter;
      topStemFilterOn1.value = defaultFilterOn;
      topStemFilterOn2.value = defaultFilterOn;
      topStemFilterOn3.value = defaultFilterOn;
      topStemFilterOn4.value = defaultFilterOn;
    }
    else
    {
      bottomStemVolume1.value   = defaultVolume;
      bottomStemVolume2.value   = defaultVolume;
      bottomStemVolume3.value   = defaultVolume;
      bottomStemVolume4.value   = defaultVolume;
      bottomStemFilter1.value   = defaultFilter;
      bottomStemFilter2.value   = defaultFilter;
      bottomStemFilter3.value   = defaultFilter;
      bottomStemFilter4.value   = defaultFilter;
      bottomStemFilterOn1.value = defaultFilterOn;
      bottomStemFilterOn2.value = defaultFilterOn;
      bottomStemFilterOn3.value = defaultFilterOn;
      bottomStemFilterOn4.value = defaultFilterOn;
    }
  }

  //------------------------------------------------------------------------------------------------------------------
  // PERFORMANCE CONTROLS PAGE AND FOCUS
  //------------------------------------------------------------------------------------------------------------------

  MappingPropertyDescriptor { id: footerPage;   path: propertiesPath + ".footer_page";    type: MappingPropertyDescriptor.Integer;  value: FooterPage.empty }
  MappingPropertyDescriptor { id: footerFocus;  path: propertiesPath + ".footer_focus";   type: MappingPropertyDescriptor.Boolean;  value: false     }

  MappingPropertyDescriptor { id: topDeckFooterPage;   path: propertiesPath + ".top.footer_page";  type: MappingPropertyDescriptor.Integer;  value: FooterPage.empty;  onValueChanged: updateFooter(); }
  MappingPropertyDescriptor { id: bottomDeckFooterPage;   path: propertiesPath + ".bottom.footer_page";  type: MappingPropertyDescriptor.Integer;  value: FooterPage.empty;  onValueChanged: updateFooter(); }

  function defaultFooterPage(deckType, footerPage)
  {
    if (!validateFooterPage(deckType, footerPage.value))
    {
      if (deckType == DeckType.Stem)
      {
        footerPage.value = FooterPage.volume;
      }
      else
      {
        footerPage.value = FooterPage.empty;
      }
    }
  }

  function updateFooter()
  {
    var upperDeckHasControls = hasBottomControls(topDeckType);
    var lowerDeckHasControls = hasBottomControls(bottomDeckType);

    if (lowerDeckHasControls && upperDeckHasControls)
    {
      footerFocus.value = deckFocus;
    }
    else if (lowerDeckHasControls)
    {
      footerFocus.value = true;
    }
    else if (upperDeckHasControls)
    {
      footerFocus.value = false;
    }
    else
    {
      footerFocus.value = false;
    }

    footerPage.value = (footerFocus.value ? bottomDeckFooterPage.value : topDeckFooterPage.value);
  }

  //------------------------------------------------------------------------------------------------------------------
  // WAVEFORM ZOOM LEVEL
  //------------------------------------------------------------------------------------------------------------------

  MappingPropertyDescriptor { path: settingsPath + ".top.waveform_zoom";       type: MappingPropertyDescriptor.Integer;   value: 7;   min: 0;  max: 9;   }
  MappingPropertyDescriptor { path: settingsPath + ".bottom.waveform_zoom";    type: MappingPropertyDescriptor.Integer;   value: 7;   min: 0;  max: 9;   }

  //------------------------------------------------------------------------------------------------------------------
  // STEM DECK STYLE (Track- or DAW-deck style)
  //------------------------------------------------------------------------------------------------------------------

  MappingPropertyDescriptor { path: propertiesPath + ".top.stem_deck_style";    type: MappingPropertyDescriptor.Integer;  value: StemStyle.daw  }
  MappingPropertyDescriptor { path: propertiesPath + ".bottom.stem_deck_style"; type: MappingPropertyDescriptor.Integer;  value: StemStyle.daw  }


  //------------------------------------------------------------------------------------------------------------------
  // SHOW/HIDE LOOP PREVIEW
  //------------------------------------------------------------------------------------------------------------------

  MappingPropertyDescriptor { path: propertiesPath + ".top.show_loop_size";    type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: propertiesPath + ".bottom.show_loop_size"; type: MappingPropertyDescriptor.Boolean; value: false }

  //------------------------------------------------------------------------------------------------------------------
  // PADS MODE AND FOCUS
  //------------------------------------------------------------------------------------------------------------------

  // Constants defining valid Mode values
  readonly property int disabledMode: 0
  readonly property int hotcueMode:   1
  readonly property int freezeMode:   2
  readonly property int remixMode:    3
  readonly property int stemMode:     4

  MappingPropertyDescriptor { id: padsMode;   path: propertiesPath + ".pads_mode";     type: MappingPropertyDescriptor.Integer;  value: disabledMode  }
  MappingPropertyDescriptor { id: padsFocus;  path: propertiesPath + ".pads_focus";    type: MappingPropertyDescriptor.Boolean;  value: false         }

  MappingPropertyDescriptor
  {
    id: topDeckPadsMode
    path: propertiesPath + ".top.pads_mode"
    type: MappingPropertyDescriptor.Integer
    value: disabledMode
    onValueChanged:
    {
      updatePads();

      switch (decksAssignment)
      {
        case DecksAssignment.AC:
          deckAFreezeEnabled.value = (topDeckPadsMode.value == freezeMode);
          break;

        case DecksAssignment.BD:
          deckBFreezeEnabled.value = (topDeckPadsMode.value == freezeMode);
          break;
      }
    }
  }

  MappingPropertyDescriptor
  {
    id: bottomDeckPadsMode
    path: propertiesPath + ".bottom.pads_mode"
    type: MappingPropertyDescriptor.Integer
    value: disabledMode
    onValueChanged:
    {
      updatePads();

      switch (decksAssignment)
      {
        case DecksAssignment.AC:
          deckCFreezeEnabled.value = (bottomDeckPadsMode.value == freezeMode);
          break;

        case DecksAssignment.BD:
          deckDFreezeEnabled.value = (bottomDeckPadsMode.value == freezeMode);
          break;
      }
    }
  }

  function updatePads()
  {
    var focusedDeckPadsMode = (deckFocus ? bottomDeckPadsMode : topDeckPadsMode);
    
    resetStemSelection();

    switch (focusedDeckPadsMode.value)
    {
      case hotcueMode:
        if ( hasHotcues(focusedDeckType) )
        {
          padsMode.value = hotcueMode;
          padsFocus.value = deckFocus;
        }
        else
        {
          padsMode.value = disabledMode;
          padsFocus.value = false;
        }
        break;

      case freezeMode:
        if ( hasFreezeMode(focusedDeckType) )
        {
          padsMode.value = freezeMode;
          padsFocus.value = deckFocus;
        }
        else
        {
          padsMode.value = disabledMode;
          padsFocus.value = false;
        }
        break;

      case remixMode:
        if (focusedDeckType == DeckType.Remix)
        {
          padsMode.value = remixMode;
          padsFocus.value = deckFocus;
        }
        else if (unfocusedDeckType == DeckType.Remix)
        {
          padsMode.value = remixMode;
          padsFocus.value = !deckFocus;
        }
        else
        {
          padsMode.value = disabledMode;
          padsFocus.value = false;
        }
        break;

      case stemMode:
        if ( hasStemMode(focusedDeckType) )
        {
          padsMode.value = stemMode;
          padsFocus.value = deckFocus;
        }
        else
        {
          padsMode.value = disabledMode;
          padsFocus.value = false;
        }
        break;

      case disabledMode:
        padsMode.value = disabledMode;
        padsFocus.value = false;
        break;
    }
  }

  function updateDeckPadsMode(deckType, deckPadsMode)
  {
      switch (deckType)
      {
        case DeckType.Track:
          deckPadsMode.value = hotcueMode;
          break;

        case DeckType.Stem:        
          deckPadsMode.value = stemMode;
          break;

        case DeckType.Remix:
          deckPadsMode.value = remixMode;
          break;

        case DeckType.Live:
          deckPadsMode.value = disabledMode;
          break;

        case thruDeckType:
          deckPadsMode.value = disabledMode;
          break;
      }
  }

  function validateDeckPadsMode(thisDeckType, otherDeckType, deckPadsMode)
  {
    var isValid = false;

    switch (deckPadsMode.value)
    {
      case hotcueMode:
        isValid = hasHotcues(thisDeckType);
        break;

      case freezeMode:
        isValid = hasFreezeMode(thisDeckType);
        break;

      case remixMode:
        isValid = hasRemixMode(thisDeckType) || hasRemixMode(otherDeckType);
        break;

      case stemMode:
        isValid = hasStemMode(thisDeckType);
        break;
    }

    if (!isValid)
    {
      updateDeckPadsMode(thisDeckType, deckPadsMode);
    }
  }

  // Freeze modeselektor (when entering or leaving freeze mode all overlays should be hidden)
  AppProperty { id: deckASliceCount;   path: "app.traktor.decks.1.freeze.slice_count" }
  AppProperty { id: deckBSliceCount;   path: "app.traktor.decks.2.freeze.slice_count" }
  AppProperty { id: deckCSliceCount;   path: "app.traktor.decks.3.freeze.slice_count" }
  AppProperty { id: deckDSliceCount;   path: "app.traktor.decks.4.freeze.slice_count" }

  AppProperty
  {
    id: deckAFreezeEnabled
    path: "app.traktor.decks.1.freeze.enabled"

    onValueChanged:
    {
      if (decksAssignment == DecksAssignment.AC)
      {
        if (value)
        {
          deckASliceCount.value = 8;
          screenOverlay.value = Overlay.none;
        }
        else if (topDeckPadsMode.value == freezeMode)
        {
          updateDeckPadsMode(topDeckType, topDeckPadsMode);
        }
      }
    }
  }

  AppProperty
  {
    id: deckBFreezeEnabled
    path: "app.traktor.decks.2.freeze.enabled"

    onValueChanged:
    {
     if (decksAssignment == DecksAssignment.BD)
      {
        if (value)
        {
          deckBSliceCount.value = 8;
          screenOverlay.value = Overlay.none;
        }
        else if (topDeckPadsMode.value == freezeMode)
        {
          updateDeckPadsMode(topDeckType, topDeckPadsMode);
        }
      }
    }
  }

  AppProperty
  {
    id: deckCFreezeEnabled
    path: "app.traktor.decks.3.freeze.enabled"

    onValueChanged:
    {
      if (decksAssignment == DecksAssignment.AC)
      {
        if (value)
        {
          deckCSliceCount.value = 8;
          screenOverlay.value = Overlay.none;
        }
        else if (bottomDeckPadsMode.value == freezeMode)
        {
          updateDeckPadsMode(bottomDeckType, bottomDeckPadsMode);
        }
      }
    }
  }

  AppProperty
  {
    id: deckDFreezeEnabled
    path: "app.traktor.decks.4.freeze.enabled"

    onValueChanged:
    {
      if (decksAssignment == DecksAssignment.BD)
      {
        if (value)
        {
          deckDSliceCount.value = 8;
          screenOverlay.value = Overlay.none;
        }
        else if (bottomDeckPadsMode.value == freezeMode)
        {
          updateDeckPadsMode(bottomDeckType, bottomDeckPadsMode);
        }
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------
  // BROWSER WARNINGS
  // Show informer warnings of the currently focused deck
  //------------------------------------------------------------------------------------------------------------------

  AppProperty   { id: deckALoadingWarning; path: "app.traktor.informer.deck_loading_warnings.1.active" }
  AppProperty   { id: deckBLoadingWarning; path: "app.traktor.informer.deck_loading_warnings.2.active" }
  AppProperty   { id: deckCLoadingWarning; path: "app.traktor.informer.deck_loading_warnings.3.active" }
  AppProperty   { id: deckDLoadingWarning; path: "app.traktor.informer.deck_loading_warnings.4.active" }

  function focusedDeckLoadingWarning(assignment, focus)
  {
    switch (assignment)
    {
      case DecksAssignment.AC: return (focus ? deckCLoadingWarning.value : deckALoadingWarning.value);
      case DecksAssignment.BD: return (focus ? deckDLoadingWarning.value : deckBLoadingWarning.value);
    }
  }

  property bool showBrowserWarning: (screenViewProp.value == ScreenView.browser) && focusedDeckLoadingWarning(decksAssignment, deckFocus)

  onShowBrowserWarningChanged:
  {
    if(showBrowserWarning)
    {
      screenOverlay.value = Overlay.browserWarnings;
    }
    else if(screenOverlay.value == Overlay.browserWarnings)
    {
      screenOverlay.value = Overlay.none;
    }
  }

  //------------------------------------------------------------------------------------------------------------------
  // BEATGRID EDIT MODE
  //------------------------------------------------------------------------------------------------------------------

  readonly property int editModeNone:  0
  readonly property int editModeArmed: 1
  readonly property int editModeUsed:  2
  readonly property int editModeFull:  3

  MappingPropertyDescriptor { id: editMode;  path: propertiesPath + ".edit_mode";  type: MappingPropertyDescriptor.Integer; value: editModeNone; }

  //------------------------------------------------------------------------------------------------------------------
  //  EDIT MODE STATE MACHINE
  //------------------------------------------------------------------------------------------------------------------

  function updateEditMode()
  {
    //Disable editMode if we are not (anymore) in track or stem deck. Other decks don't have edit mode!
    if (editMode != editModeNone && !hasEditMode(focusedDeckType))
    {
      editMode.value = editModeNone;
    }
  }

  readonly property bool isInEditMode: (editMode.value == editModeFull)

  property bool preEditIsSingleDeck: false

  onIsInEditModeChanged:
  {
    if (isInEditMode)
    {
      screenOverlay.value = Overlay.none;
      preEditIsSingleDeck = screenIsSingleDeck.value;
      screenIsSingleDeck.value = true;
    }
    else
    {
      screenIsSingleDeck.value = preEditIsSingleDeck;
    }

    showDisplayButtonArea.value = true;
    showDisplayButtonAreaResetTimer.restart();
    
    updateEncoder();
  }
  
  Wire { from: "%surface%.display.buttons.2"; to: ButtonScriptAdapter { brightness: (isInEditMode ? onBrightness : dimmedBrightness); onPress: onEditPressed(); onRelease: onEditReleased(); } enabled: hasEditMode(focusedDeckType) && module.screenView.value == ScreenView.deck && module.shift }

  function onEditPressed()
  {
    if (editMode.value == editModeNone)
    {
      editMode.value = editModeArmed;
    }
    else if (editMode.value == editModeFull)
    {
      editMode.value = editModeNone;
    }
  }

  function onEditReleased()
  {
    if (editMode.value == editModeArmed)
    {
      zoomedEditView.value = false;
      editMode.value = editModeFull;
    }
    else if (editMode.value == editModeUsed)
    {
      editMode.value = editModeNone;
    }
  }

  function onSyncPressed()
  {
    if (editMode.value == editModeArmed)
    {
      editMode.value = editModeUsed;
    }
  }

  /////////////////////////

  Blinker { name: "ScreenViewBlinker";  cycle: 300; defaultBrightness: onBrightness; blinkBrightness: dimmedBrightness }

  Wire { from: "%surface%.display.buttons.5.value";  to: ButtonScriptAdapter { onPress: handleViewButton(); } }
  Wire { from: "%surface%.display.buttons.5.led";    to: "ScreenViewBlinker"  }
  Wire { from: "ScreenViewBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: (module.screenView.value == ScreenView.deck && screenOverlay.value != Overlay.none) || (module.screenView.value == ScreenView.browser && !browserIsTemporary.value) || isInEditMode }  }

  function handleViewButton()
  {
    if (screenViewProp.value == ScreenView.deck)
    {
      if (screenOverlay.value == Overlay.none && editMode.value != editModeFull)
      {
        screenIsSingleDeck.value = !screenIsSingleDeck.value;
      }
      else
      {
        screenOverlay.value = Overlay.none;
        editMode.value      = editModeNone;
      }
    }
    else if (screenViewProp.value == ScreenView.browser)
    {
      if (browserIsTemporary.value)
      {
        browserIsTemporary.value = false;
      }
      else
      {
        screenViewProp.value = ScreenView.deck;
      }
    }
  }
  /////////////////////////

  AppProperty { id: deckARunning;   path: "app.traktor.decks.1.running" } 
  AppProperty { id: deckBRunning;   path: "app.traktor.decks.2.running" }
  AppProperty { id: deckCRunning;   path: "app.traktor.decks.3.running" }
  AppProperty { id: deckDRunning;   path: "app.traktor.decks.4.running" }

  AppProperty { id: previewIsLoaded;  path: "app.traktor.browser.preview_player.is_loaded" }

  // Shift //
  property alias shift: shiftProp.value
  MappingPropertyDescriptor { id: shiftProp; path: propertiesPath + ".shift"; type: MappingPropertyDescriptor.Boolean; value: false }
  Wire { from: "%surface%.shift";  to: DirectPropertyAdapter { path: propertiesPath + ".shift"  } }

  MappingPropertyDescriptor { id: browserIsContentList;  path: propertiesPath + ".browser.is_content_list";  type: MappingPropertyDescriptor.Boolean; value: false }
  
  // Screen
  KontrolScreen { name: "screen"; side: (decksAssignment == DecksAssignment.AC ? ScreenSide.Left : ScreenSide.Right); flavor: ScreenFlavor.S5; settingsPath: module.settingsPath; propertiesPath: module.propertiesPath }
  Wire { from: "screen.output";   to: "%surface%.display" }
  Wire { from: "screen.screen_view_state";  to: DirectPropertyAdapter { path: propertiesPath + ".screen_view";  input: false } }
  AppProperty { id: unloadPreviewPlayer;  path: "app.traktor.browser.preview_player.unload" }

  property alias screenView: screenViewProp
  MappingPropertyDescriptor
  {
    id: screenViewProp
    path: propertiesPath + ".screen_view"
    type: MappingPropertyDescriptor.Integer
    value: ScreenView.deck

    onValueChanged:
    {
      if (screenViewProp.value != ScreenView.deck)
      {
        editMode.value = editModeNone;
        screenOverlay.value = Overlay.none;
      }
      else if (screenViewProp.value != ScreenView.browser)
      {
        unloadPreviewPlayer.value = true;
      }
    }
  }

  // Button area timer
  MappingPropertyDescriptor
  {
    id: showDisplayButtonArea;
    path: propertiesPath + ".show_display_button_area";
    type: MappingPropertyDescriptor.Boolean;
    value: false;
    onValueChanged:
    {
      if(value)
        showDisplayButtonAreaResetTimer.restart();
    }
  }

  Timer
  {
    id: showDisplayButtonAreaResetTimer
    triggeredOnStart: false
    interval: 1000
    running:  false
    repeat:   false
    onTriggered:
    {
      if (!isInEditMode)
        showDisplayButtonArea.value = false;
    }
  }

  SetPropertyAdapter { name: "ShowDisplayButtonArea_ButtonAdapter";    path: propertiesPath + ".show_display_button_area";  value: true }
  EncoderScriptAdapter { name: "ShowDisplayButtonArea_EncoderAdapter";   onTick: { showDisplayButtonArea.value = true; showDisplayButtonAreaResetTimer.restart(); } }

  Wire
  {
    enabled: (module.screenView.value == ScreenView.deck) && hasButtonArea(focusedDeckType) && !module.shift
    from:
      Or
      {
        inputs:
        [
          "%surface%.display.buttons.2",
          "%surface%.display.buttons.3",
          "%surface%.display.buttons.6",
          "%surface%.display.buttons.7"
        ]
      }
    to: "ShowDisplayButtonArea_ButtonAdapter.input"
  }

  // Browser Pop-outs
  WiresGroup
  {
    enabled: (module.screenView.value == ScreenView.browser) && browserIsContentList

    Wire { to: "ShowDisplayButtonArea_ButtonAdapter.input"; from: "%surface%.display.buttons.6" }
    Wire { to: "ShowDisplayButtonArea_ButtonAdapter.input"; from: "%surface%.display.buttons.7" }
  }

  SwitchTimer { name: "BrowserBackTimer"; setTimeout: 1000 }
  Wire { from: "%surface%.back";                to: "BrowserBackTimer.input" }
  Wire { from: "BrowserBackTimer.output"; to: SetPropertyAdapter { path: propertiesPath + ".screen_view"; value: ScreenView.deck } enabled: module.screenView.value == ScreenView.browser }

  //------------------------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------------------------

  // Browser stuff
  SwitchTimer
  {
    name: "BrowserLeaveTimer"
    resetTimeout: 1000

    onSet:
    {
      if((screenViewProp.value != ScreenView.browser) && (screenOverlay.value == Overlay.none) && showBrowserOnTouch.value)
      {
        browserIsTemporary.value = true;
        screenViewProp.value = ScreenView.browser;
      }
    }

    onReset:
    {
      if((screenViewProp.value == ScreenView.browser) && showBrowserOnTouch.value && browserIsTemporary.value)
      {
        screenViewProp.value = ScreenView.deck;
      }
    }
  }

  WiresGroup
  {
    // open browser
    enabled: encoderMode.value != encoderStemMode;

    Wire { from: "%surface%.browse.push"; to: SetPropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.none } enabled: screenOverlay.value == Overlay.browserWarnings }

    WiresGroup
    {
      enabled: !showBrowserOnTouch.value
      Wire { from: "%surface%.browse.push"; to: ButtonScriptAdapter { onPress: { browserIsTemporary.value = false; module.screenView.value = ScreenView.browser; } } enabled: screenOverlay.value == Overlay.none }
    }

    WiresGroup
    {
      enabled: showBrowserOnTouch.value
      Wire { from: "%surface%.browse.touch"; to: "BrowserLeaveTimer.input";  enabled: module.screenView.value == ScreenView.deck && screenOverlay.value == Overlay.none }
      Wire { from: "%surface%.browse.touch"; to: "BrowserLeaveTimer.input"; enabled: module.screenView.value  == ScreenView.browser; }
    }
  }

  WiresGroup
  {
    //stem control
    enabled: encoderMode.value == encoderStemMode && screenOverlay.value == Overlay.none && screenViewProp.value == ScreenView.deck;
    Wire { from: "%surface%.browse.touch";     to: SetPropertyAdapter { path: propertiesPath + ".top.footer_page";    value: FooterPage.volume } enabled: !footerFocus.value }
    Wire { from: "%surface%.browse.push";      to: SetPropertyAdapter { path: propertiesPath + ".top.footer_page";    value: FooterPage.volume } enabled: !footerFocus.value }
    Wire { from: "%surface%.browse.is_turned"; to: SetPropertyAdapter { path: propertiesPath + ".top.footer_page";    value: FooterPage.volume } enabled: !footerFocus.value }
    Wire { from: "%surface%.browse.touch";     to: SetPropertyAdapter { path: propertiesPath + ".bottom.footer_page"; value: FooterPage.volume } enabled:  footerFocus.value }
    Wire { from: "%surface%.browse.push";      to: SetPropertyAdapter { path: propertiesPath + ".bottom.footer_page"; value: FooterPage.volume } enabled:  footerFocus.value }
    Wire { from: "%surface%.browse.is_turned"; to: SetPropertyAdapter { path: propertiesPath + ".bottom.footer_page"; value: FooterPage.volume } enabled:  footerFocus.value }

    //A
    WiresGroup
    {
      enabled: (focusedDeckId == 1)
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.1.stems.1.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode1.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.1.stems.2.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode2.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.1.stems.3.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode3.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.1.stems.4.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode4.value  }
    }

    //C
    WiresGroup
    {
      enabled: (focusedDeckId == 3)
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.3.stems.1.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode1.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.3.stems.2.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode2.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.3.stems.3.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode3.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.3.stems.4.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode4.value  }
    }

    //B
    WiresGroup
    {
      enabled: (focusedDeckId == 2)
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.2.stems.1.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode1.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.2.stems.2.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode2.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.2.stems.3.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode3.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.2.stems.4.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode4.value  }
    }

    //D
    WiresGroup
    {
      enabled: (focusedDeckId == 4)
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.4.stems.1.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode1.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.4.stems.2.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode2.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.4.stems.3.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode3.value  }
      Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.4.stems.4.volume"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode4.value  }
    }
  }

      //------------------------------------------------------------------------------------------------------------------
      // Browser
      //------------------------------------------------------------------------------------------------------------------

      AppProperty { id: browserSortId;   path: "app.traktor.browser.sort_id" }
      ButtonScriptAdapter { name: "back_button_color_adapter"; color: (deckFocus ? Color.White : Color.Blue); }

      WiresGroup
      {
        enabled: module.screenView.value == ScreenView.browser

        Wire { from: "%surface%.back";         to: "screen.exit_browser_node" }
        Wire { from: "%surface%.back.color1";  to: "back_button_color_adapter.color" }

        Wire { from: "%surface%.browse.push";  to: "screen.open_browser_node";   enabled: screenOverlay.value == Overlay.none }
        Wire { from: "%surface%.browse.turn";  to: "screen.scroll_browser_row";  enabled: !module.shift }
        Wire { from: "%surface%.browse.turn";  to: "screen.scroll_browser_page"; enabled:  module.shift }

        WiresGroup
        {
          enabled: browserIsContentList.value

          Wire { from: "%surface%.display.buttons.6";   to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.append" } }
          Wire { from: "%surface%.display.buttons.7";   to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.jump_to_list" } }
          
          WiresGroup
          {
            enabled: (selectedFooterItem.value % 2) == 1  // selectedFooterItem.value goes from 1 to 4, this maps it to [1,2]
            Wire { from: "%surface%.encoder";             to: "screen.browser_sorting"    }
            Wire { from: "%surface%.encoder.push";        to: TriggerPropertyAdapter  { path:"app.traktor.browser.flip_sort_up_down"  } enabled: (browserSortId.value > 0) }
          }
        }
        
        WiresGroup
        {
          enabled: (selectedFooterItem.value % 2) == 0  // selectedFooterItem.value goes from 1 to 4, this maps it to [1,2]
          Wire { from: "%surface%.encoder";           to: RelativePropertyAdapter { path: "app.traktor.browser.preview_player.seek"; step: 0.01; mode: RelativeMode.Stepped } }
          Wire { from: "%surface%.encoder.push";      to: TriggerPropertyAdapter   { path: "app.traktor.browser.preview_player.load_or_play" } }
        }
      }

      //------------------------------------------------------------------------------------------------------------------
      // Center Overlays
      //------------------------------------------------------------------------------------------------------------------
    
      
      
      WiresGroup
      {
        enabled: module.screenView.value == ScreenView.deck

        WiresGroup
        {
          enabled: !isInEditMode && !module.shift

          Wire { from: "%surface%.display.buttons.2";  to: TogglePropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.bpm }      enabled: hasBpmAdjust(focusedDeckType) }
          Wire { from: "%surface%.display.buttons.3";  to: TogglePropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.key }      enabled: hasKeylock(focusedDeckType)   }
          Wire { from: "%surface%.display.buttons.3";  to: TogglePropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.quantize } enabled: hasRemixMode(focusedDeckType) }
        }
      }

      Group
      {
        name: "decks"

        Group
        {
          name: "1"

          DeckTempo       { name: "tempo";            channel: 1 }
          KeyControl      { name: "key_control";      channel: 1 }
          QuantizeControl { name: "quantize_control"; channel: 1 }

          Hotcues      { name: "hotcues";       channel: 1 }
          FreezeSlicer { name: "freeze_slicer"; channel: 1; numberOfSlices: 8 }

          TransportSection { name: "transport"; channel: 1 }
          Scratch     { name: "scratch";    channel: 1; ledBarSize: touchstripLedBarSize }
          TouchstripTempoBend   { name: "tempo_bend"; channel: 1; ledBarSize: touchstripLedBarSize }
          TouchstripTrackSeek   { name: "track_seek"; channel: 1; ledBarSize: touchstripLedBarSize }

          Loop { name: "loop";  channel: 1; numberOfLeds: 1; color: Color.Blue }

          RemixDeck   { name: "remix"; channel: 1; size: RemixDeck.Small; }
          RemixDeckSlots { name: "remix_slots"; channel: 1 }

          StemDeckStreams { name: "stems"; channel: 1 }

          Group
          {
            name: "reset_stems"

            Group
            {
              name: "1"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.1.stems.1.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.1.stems.1.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.1.stems.1.filter_on"; value: false }
            }

            Group
            {
              name: "2"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.1.stems.2.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.1.stems.2.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.1.stems.2.filter_on"; value: false }
            }

            Group
            {
              name: "3"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.1.stems.3.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.1.stems.3.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.1.stems.3.filter_on"; value: false }
            }

            Group
            {
              name: "4"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.1.stems.4.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.1.stems.4.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.1.stems.4.filter_on"; value: false }
            }
          }
        }

        Group
        {
          name: "2"

          DeckTempo       { name: "tempo";            channel: 2 }
          KeyControl      { name: "key_control";      channel: 2 }
          QuantizeControl { name: "quantize_control"; channel: 2 }

          Hotcues      { name: "hotcues";       channel: 2 }
          FreezeSlicer { name: "freeze_slicer"; channel: 2; numberOfSlices: 8 }

          TransportSection { name: "transport"; channel: 2 }
          Scratch     { name: "scratch";    channel: 2; ledBarSize: touchstripLedBarSize }
          TouchstripTempoBend   { name: "tempo_bend"; channel: 2; ledBarSize: touchstripLedBarSize }
          TouchstripTrackSeek   { name: "track_seek"; channel: 2; ledBarSize: touchstripLedBarSize }

          Loop { name: "loop";  channel: 2; numberOfLeds: 1; color: Color.Blue }

          RemixDeck   { name: "remix"; channel: 2; size: RemixDeck.Small }
          RemixDeckSlots { name: "remix_slots"; channel: 2 }

          StemDeckStreams { name: "stems"; channel: 2 }

          Group
          {
            name: "reset_stems"

            Group
            {
              name: "1"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.2.stems.1.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.2.stems.1.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.2.stems.1.filter_on"; value: false }
            }

            Group
            {
              name: "2"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.2.stems.2.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.2.stems.2.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.2.stems.2.filter_on"; value: false }
            }

            Group
            {
              name: "3"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.2.stems.3.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.2.stems.3.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.2.stems.3.filter_on"; value: false }
            }

            Group
            {
              name: "4"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.2.stems.4.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.2.stems.4.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.2.stems.4.filter_on"; value: false }
            }
          }
        }

        Group
        {
          name: "3"

          DeckTempo       { name: "tempo";            channel: 3 }
          KeyControl      { name: "key_control";      channel: 3 }
          QuantizeControl { name: "quantize_control"; channel: 3 }

          Hotcues      { name: "hotcues";       channel: 3 }
          FreezeSlicer { name: "freeze_slicer"; channel: 3; numberOfSlices: 8 }

          TransportSection { name: "transport"; channel: 3 }
          Scratch     { name: "scratch";    channel: 3; ledBarSize: touchstripLedBarSize }
          TouchstripTempoBend   { name: "tempo_bend"; channel: 3; ledBarSize: touchstripLedBarSize }
          TouchstripTrackSeek   { name: "track_seek"; channel: 3; ledBarSize: touchstripLedBarSize }

          Loop { name: "loop";  channel: 3; numberOfLeds: 1; color: Color.White }

          RemixDeck   { name: "remix"; channel: 3; size: RemixDeck.Small }
          RemixDeckSlots { name: "remix_slots"; channel: 3 }

          StemDeckStreams { name: "stems"; channel: 3 }

          Group
          {
            name: "reset_stems"

            Group
            {
              name: "1"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.3.stems.1.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.3.stems.1.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.3.stems.1.filter_on"; value: false }
            }

            Group
            {
              name: "2"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.3.stems.2.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.3.stems.2.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.3.stems.2.filter_on"; value: false }
            }

            Group
            {
              name: "3"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.3.stems.3.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.3.stems.3.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.3.stems.3.filter_on"; value: false }
            }

            Group
            {
              name: "4"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.3.stems.4.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.3.stems.4.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.3.stems.4.filter_on"; value: false }
            }
          }
        }

        Group
        {
          name: "4"

          DeckTempo       { name: "tempo";            channel: 4 }
          KeyControl      { name: "key_control";      channel: 4 }
          QuantizeControl { name: "quantize_control"; channel: 4 }

          Hotcues      { name: "hotcues";       channel: 4 }
          FreezeSlicer { name: "freeze_slicer"; channel: 4; numberOfSlices: 8 }

          TransportSection { name: "transport"; channel: 4 }
          Scratch     { name: "scratch";    channel: 4; ledBarSize: touchstripLedBarSize }
          TouchstripTempoBend   { name: "tempo_bend"; channel: 4; ledBarSize: touchstripLedBarSize }
          TouchstripTrackSeek   { name: "track_seek"; channel: 4; ledBarSize: touchstripLedBarSize }

          Loop { name: "loop";  channel: 4; numberOfLeds: 1; color: Color.White }

          RemixDeck   { name: "remix"; channel: 4; size: RemixDeck.Small; }
          RemixDeckSlots { name: "remix_slots"; channel: 4 }

          StemDeckStreams { name: "stems"; channel: 4 }

          Group
          {
            name: "reset_stems"

            Group
            {
              name: "1"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.4.stems.1.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.4.stems.1.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.4.stems.1.filter_on"; value: false }
            }

            Group
            {
              name: "2"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.4.stems.2.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.4.stems.2.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.4.stems.2.filter_on"; value: false }
            }

            Group
            {
              name: "3"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.4.stems.3.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.4.stems.3.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.4.stems.3.filter_on"; value: false }
            }

            Group
            {
              name: "4"

              SetPropertyAdapter { name: "volume"; path: "app.traktor.decks.4.stems.4.volume";       value: 1.0   }
              SetPropertyAdapter { name: "filter"; path: "app.traktor.decks.4.stems.4.filter_value"; value: 0.5   }
              SetPropertyAdapter { name: "filter_on"; path: "app.traktor.decks.4.stems.4.filter_on"; value: false }
            }
          }
        }
      }

      //------------------------------------------------------------------------------------------------------------------
      // BPM/Tempo Overlay
      //------------------------------------------------------------------------------------------------------------------

      WiresGroup
      {
        enabled: screenOverlay.value == Overlay.bpm

        // Deck A
        WiresGroup
        {
          enabled: focusedDeckId == 1

          Wire { from: "%surface%.back";   to: "decks.1.tempo.reset" }
          Wire { from: "%surface%.browse"; to: "decks.1.tempo.fine";   enabled: !module.shift }
          Wire { from: "%surface%.browse"; to: "decks.1.tempo.coarse"; enabled:  module.shift }
        }

        // Deck B
        WiresGroup
        {
          enabled: focusedDeckId == 2

          Wire { from: "%surface%.back";   to: "decks.2.tempo.reset" }
          Wire { from: "%surface%.browse"; to: "decks.2.tempo.fine";   enabled: !module.shift }
          Wire { from: "%surface%.browse"; to: "decks.2.tempo.coarse"; enabled:  module.shift }
        }

        // Deck C
        WiresGroup
        {
          enabled: focusedDeckId == 3

          Wire { from: "%surface%.back";   to: "decks.3.tempo.reset" }
          Wire { from: "%surface%.browse"; to: "decks.3.tempo.fine";   enabled: !module.shift }
          Wire { from: "%surface%.browse"; to: "decks.3.tempo.coarse"; enabled:  module.shift }
        }

        // Deck D
        WiresGroup
        {
          enabled: focusedDeckId == 4

          Wire { from: "%surface%.back";   to: "decks.4.tempo.reset" }
          Wire { from: "%surface%.browse"; to: "decks.4.tempo.fine";   enabled: !module.shift }
          Wire { from: "%surface%.browse"; to: "decks.4.tempo.coarse"; enabled:  module.shift }
        }
      }

      //------------------------------------------------------------------------------------------------------------------
      // Key Overlay
      //------------------------------------------------------------------------------------------------------------------

      WiresGroup
      {
        enabled: screenOverlay.value == Overlay.key

        // Deck A
        WiresGroup
        {
          enabled: focusedDeckId == 1

          Wire { from: "%surface%.back";    to: "decks.1.key_control.reset" }
          Wire { from: "%surface%.browse";  to: "decks.1.key_control.fine";   enabled:  module.shift }
          Wire { from: "%surface%.browse";  to: "decks.1.key_control.coarse"; enabled: !module.shift }
        }

        // Deck B
        WiresGroup
        {
          enabled: focusedDeckId == 2

          Wire { from: "%surface%.back";    to: "decks.2.key_control.reset" }
          Wire { from: "%surface%.browse";  to: "decks.2.key_control.fine";   enabled:  module.shift }
          Wire { from: "%surface%.browse";  to: "decks.2.key_control.coarse"; enabled: !module.shift }
        }

        // Deck C
        WiresGroup
        {
          enabled: focusedDeckId == 3

          Wire { from: "%surface%.back";    to: "decks.3.key_control.reset" }
          Wire { from: "%surface%.browse";  to: "decks.3.key_control.fine";   enabled:  module.shift }
          Wire { from: "%surface%.browse";  to: "decks.3.key_control.coarse"; enabled: !module.shift }
        }

        // Deck D
        WiresGroup
        {
          enabled: focusedDeckId == 4

          Wire { from: "%surface%.back";    to: "decks.4.key_control.reset" }
          Wire { from: "%surface%.browse";  to: "decks.4.key_control.fine";   enabled:  module.shift }
          Wire { from: "%surface%.browse";  to: "decks.4.key_control.coarse"; enabled: !module.shift }
        }
      }

      //------------------------------------------------------------------------------------------------------------------
      // Quantize Overlay
      //------------------------------------------------------------------------------------------------------------------

      WiresGroup
      {
        enabled: screenOverlay.value == Overlay.quantize

        Wire { from: "%surface%.browse"; to: "decks.1.quantize_control"; enabled: focusedDeckId == 1 }
        Wire { from: "%surface%.browse"; to: "decks.2.quantize_control"; enabled: focusedDeckId == 2 }
        Wire { from: "%surface%.browse"; to: "decks.3.quantize_control"; enabled: focusedDeckId == 3 }
        Wire { from: "%surface%.browse"; to: "decks.4.quantize_control"; enabled: focusedDeckId == 4 }
      }

      //------------------------------------------------------------------------------------------------------------------
      //  PERFORMANCE CONTROLS PAGES
      //------------------------------------------------------------------------------------------------------------------

      function validateFooterPage(footerFocusDeckType, page)
      {
        switch (page)
        {
          case FooterPage.volume:
          case FooterPage.filter:
            return (footerFocusDeckType == DeckType.Stem);

          default:
            return false;
        }
      }

      function footerPageInc(footerFocusDeckType, footerPage)
      {
        if (footerHasDetails)
        {
          var tempPage = footerPage.value;

          while (true)
          {
            // Go to the next footer page...
            switch (tempPage)
            {
              case FooterPage.volume:
                tempPage = FooterPage.filter;
                break;

              case FooterPage.filter:
                tempPage = FooterPage.volume;
                break;
          }

          // Validate the page and eventually switch to it!
          if (validateFooterPage(footerFocusDeckType, tempPage))
          {
            footerPage.value = tempPage;
            return;
          }
        }
      }
      else
      {
        footerPage.value = FooterPage.empty;
      }
    }

    function footerPageDec( footerFocusDeckType, footerPage )
    {
      if (footerHasDetails)
      {
        var tempPage = footerPage.value;

        while (true)
        {
          // Go to the next footer page...
          switch (tempPage)
          {
            case FooterPage.volume:
              tempPage = FooterPage.filter;
              break;

            case FooterPage.filter:
              tempPage = FooterPage.volume;
              break;
          }

          // Validate the page and eventually switch to it!
          if (validateFooterPage(footerFocusDeckType, tempPage))
          {
            footerPage.value = tempPage;
            return;
          }
        }
      }
      else
      {
        footerPage.value = FooterPage.empty;
      }
    }

      WiresGroup
      {
        enabled: !isInEditMode && module.screenView.value == ScreenView.deck

        Wire { from: "%surface%.display.buttons.8";  to: ButtonScriptAdapter { onPress: { footerPageInc(footerFocus.value ? bottomDeckType : topDeckType, (footerFocus.value ? bottomDeckFooterPage : topDeckFooterPage));  } brightness: onBrightness; } }
        Wire { from: "%surface%.display.buttons.4";  to: ButtonScriptAdapter { onPress: { footerPageDec(footerFocus.value ? bottomDeckType : topDeckType, (footerFocus.value ? bottomDeckFooterPage : topDeckFooterPage));  } brightness: onBrightness; } }
      }

      //------------------------------------------------------------------------------------------------------------------
      // Effects Overlay
      //------------------------------------------------------------------------------------------------------------------

      MappingPropertyDescriptor { id: fxButtonSelection; path: propertiesPath + ".fx_button_selection"; type: MappingPropertyDescriptor.Integer; value: FxOverlay.upper_button_2 }

      WiresGroup
      {
        enabled: (screenOverlay.value != Overlay.fx) && module.shift

        // enter fx overlay
        Wire { from: "%surface%.fx.buttons.1"; to: SetPropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.fx; output: false } }
        Wire { from: "%surface%.fx.buttons.2"; to: SetPropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.fx; output: false } } 
        Wire { from: "%surface%.fx.buttons.3"; to: SetPropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.fx; output: false } } 
        Wire { from: "%surface%.fx.buttons.4"; to: SetPropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.fx; output: false } } 

        // set correct selection when entering fx select overlay
        Wire { from: "%surface%.fx.buttons.1"; to: SetPropertyAdapter { path: propertiesPath + ".fx_button_selection"; value: FxOverlay.upper_button_1; } }
        Wire { from: "%surface%.fx.buttons.2"; to: SetPropertyAdapter { path: propertiesPath + ".fx_button_selection"; value: FxOverlay.upper_button_2; } }
        Wire { from: "%surface%.fx.buttons.3"; to: SetPropertyAdapter { path: propertiesPath + ".fx_button_selection"; value: FxOverlay.upper_button_3; } }
        Wire { from: "%surface%.fx.buttons.4"; to: SetPropertyAdapter { path: propertiesPath + ".fx_button_selection"; value: FxOverlay.upper_button_4; } }
      }

      WiresGroup
      {
        enabled: screenOverlay.value == Overlay.fx

        // set correct selection while in fx select overlay
        Wire { from: "%surface%.browse";       to: "screen.fx_selection" }
        Wire { from: "%surface%.fx.buttons.1"; to: SetPropertyAdapter { path: propertiesPath + ".fx_button_selection"; value: FxOverlay.upper_button_1 } }
        Wire { from: "%surface%.fx.buttons.2"; to: SetPropertyAdapter { path: propertiesPath + ".fx_button_selection"; value: FxOverlay.upper_button_2 } }
        Wire { from: "%surface%.fx.buttons.3"; to: SetPropertyAdapter { path: propertiesPath + ".fx_button_selection"; value: FxOverlay.upper_button_3 } }
        Wire { from: "%surface%.fx.buttons.4"; to: SetPropertyAdapter { path: propertiesPath + ".fx_button_selection"; value: FxOverlay.upper_button_4 } }

        WiresGroup
        {
          enabled: module.shift

          // leave fx select overlay when toggling current fx selection
          Wire { from: "%surface%.fx.buttons.1"; to: SetPropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.none; output: false } enabled: fxButtonSelection.value == FxOverlay.upper_button_1; }
          Wire { from: "%surface%.fx.buttons.2"; to: SetPropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.none; output: false } enabled: fxButtonSelection.value == FxOverlay.upper_button_2; } 
          Wire { from: "%surface%.fx.buttons.3"; to: SetPropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.none; output: false } enabled: fxButtonSelection.value == FxOverlay.upper_button_3; } 
          Wire { from: "%surface%.fx.buttons.4"; to: SetPropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.none; output: false } enabled: fxButtonSelection.value == FxOverlay.upper_button_4; } 
        }
      }

      //------------------------------------------------------------------------------------------------------------------
      // Capture Overlay
      //------------------------------------------------------------------------------------------------------------------

      Wire
      {
        enabled: (encoderMode.value == encoderCaptureMode) && ((topDeckType == DeckType.Remix) || (bottomDeckType == DeckType.Remix))
        from: Or
        {
          inputs:
          [
            "%surface%.encoder.touch",
            "%surface%.encoder.is_turned"
          ]
        }
        to: HoldPropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.capture }
      }

      //------------------------------------------------------------------------------------------------------------------
      // MODESELEKTOR
      //------------------------------------------------------------------------------------------------------------------

      property bool deckAExitFreeze:  false
      property bool deckBExitFreeze:  false
      property bool deckCExitFreeze:  false
      property bool deckDExitFreeze:  false

      function onFreezeButtonPress(padsMode, deckIsLoaded)
      {
        var exitFreeze = false;

        if (padsMode.value == freezeMode)
        {
          exitFreeze = true;
        }
        else if (deckIsLoaded)
        {
          exitFreeze = false;
          padsMode.value = freezeMode;
        }
        return exitFreeze;
      }

      function onFreezeButtonRelease(padsMode, exitFreeze, deckType)
      {
        if (exitFreeze)
        {
          updateDeckPadsMode(deckType, padsMode);
        }
      }

      // Deck A
      WiresGroup
      {
        enabled: (focusedDeckId == 1)

        Wire { from: "%surface%.hotcue";  to: SetPropertyAdapter { path: propertiesPath + ".top.pads_mode"; value: hotcueMode;  color: Color.Blue } enabled: hasHotcues(deckAType) }
        Wire { from: "%surface%.freeze";  to: ButtonScriptAdapter { brightness: ((topDeckPadsMode.value == freezeMode) ? onBrightness : dimmedBrightness); color: Color.Blue; onPress: { deckAExitFreeze = onFreezeButtonPress(topDeckPadsMode, deckAIsLoaded.value);  } onRelease: { onFreezeButtonRelease(topDeckPadsMode, deckAExitFreeze, deckAType); } } enabled: hasFreezeMode(deckAType) }
        Wire { from: "%surface%.remix";   to: SetPropertyAdapter { path: propertiesPath + ".top.pads_mode"; value: remixMode;   color: (hasRemixMode(deckAType) ? Color.Blue : Color.White) } enabled: !hasStemMode(deckAType) && (hasRemixMode(deckAType) || hasRemixMode(deckCType))  }
        Wire { from: "%surface%.remix";   to: SetPropertyAdapter { path: propertiesPath + ".top.pads_mode"; value: stemMode;    color: Color.Blue } enabled:  hasStemMode(deckAType) }
      }

      // Deck C
      WiresGroup
      {
        enabled: (focusedDeckId == 3)

        Wire { from: "%surface%.hotcue";  to: SetPropertyAdapter { path: propertiesPath + ".bottom.pads_mode"; value: hotcueMode;  color: Color.White } enabled: hasHotcues(deckCType) }
        Wire { from: "%surface%.freeze";  to: ButtonScriptAdapter  { brightness: ((bottomDeckPadsMode.value == freezeMode) ? onBrightness : dimmedBrightness); color: Color.White; onPress: { deckCExitFreeze = onFreezeButtonPress(bottomDeckPadsMode, deckCIsLoaded.value);  } onRelease: { onFreezeButtonRelease(bottomDeckPadsMode, deckCExitFreeze, deckCType); } } enabled: hasFreezeMode(deckCType) }
        Wire { from: "%surface%.remix";   to: SetPropertyAdapter { path: propertiesPath + ".bottom.pads_mode"; value: remixMode;   color: (hasRemixMode(deckCType) ? Color.White : Color.Blue) } enabled: !hasStemMode(deckCType) && (hasRemixMode(deckAType) || hasRemixMode(deckCType )) }
        Wire { from: "%surface%.remix";   to: SetPropertyAdapter { path: propertiesPath + ".bottom.pads_mode"; value: stemMode;    color: Color.White } enabled:  hasStemMode(deckCType) }
      }

      // Deck B
      WiresGroup
      {
        enabled: (focusedDeckId == 2)

        Wire { from: "%surface%.hotcue"; to: SetPropertyAdapter { path: propertiesPath + ".top.pads_mode"; value: hotcueMode;  color: Color.Blue } enabled: hasHotcues(deckBType)}
        Wire { from: "%surface%.freeze"; to: ButtonScriptAdapter  { brightness: ((topDeckPadsMode.value == freezeMode) ? onBrightness : dimmedBrightness); color: Color.Blue; onPress: { deckBExitFreeze = onFreezeButtonPress(topDeckPadsMode, deckBIsLoaded.value);  } onRelease: { onFreezeButtonRelease(topDeckPadsMode, deckBExitFreeze, deckBType); } } enabled: hasFreezeMode(deckBType) }
        Wire { from: "%surface%.remix";  to: SetPropertyAdapter { path: propertiesPath + ".top.pads_mode"; value: remixMode;   color: (hasRemixMode(deckBType)? Color.Blue : Color.White) } enabled: !hasStemMode(deckBType) && (hasRemixMode(deckBType) || hasRemixMode(deckDType)) }
        Wire { from: "%surface%.remix";  to: SetPropertyAdapter { path: propertiesPath + ".top.pads_mode"; value: stemMode;    color: Color.Blue } enabled:  hasStemMode(deckBType) }
      }

      // Deck D
      WiresGroup
      {
        enabled: (focusedDeckId == 4)

        Wire { from: "%surface%.hotcue"; to: SetPropertyAdapter { path: propertiesPath + ".bottom.pads_mode"; value: hotcueMode;  color: Color.White } enabled: hasHotcues(deckDType) }
        Wire { from: "%surface%.freeze"; to: ButtonScriptAdapter  { brightness: ((bottomDeckPadsMode.value == freezeMode) ? onBrightness : dimmedBrightness); color: Color.White; onPress: { deckDExitFreeze = onFreezeButtonPress(bottomDeckPadsMode, deckDIsLoaded.value);  } onRelease: { onFreezeButtonRelease(bottomDeckPadsMode, deckDExitFreeze, deckDType); } } enabled: hasFreezeMode(deckDType) }
        Wire { from: "%surface%.remix";  to: SetPropertyAdapter { path: propertiesPath + ".bottom.pads_mode"; value: remixMode;   color: (hasRemixMode(deckDType)? Color.White : Color.Blue) } enabled: !hasStemMode(deckDType) && (hasRemixMode(deckBType) || hasRemixMode(deckDType)) }
        Wire { from: "%surface%.remix";  to: SetPropertyAdapter { path: propertiesPath + ".bottom.pads_mode"; value: stemMode;    color: Color.White } enabled:  hasStemMode(deckDType) }
      }

      //------------------------------------------------------------------------------------------------------------------
      // PADS
      //------------------------------------------------------------------------------------------------------------------

      readonly property int stem_selector_color : (padsFocusedDeckId == 1) || (padsFocusedDeckId == 2) ? Color.Blue : Color.White
      
      function newValueForStemSelectorModeOnPress(oldValue)
      {
        var newValue = false
        if(stemSelectorModeHold){
          newValue = true
        } else {
          newValue = !oldValue
        }
        
        return newValue
      }
      
      function newValueForStemSelectorModeOnRelease(oldValue)
      {
        var newValue = oldValue
        if(stemSelectorModeHold){
          newValue = false
        }
        
        return newValue
      }
      
      property bool stemSelectorBlinkState: false

      Timer
      {
        id: stemSelectorTimer
        interval: 500
        running:  true
        repeat:   true
        onTriggered:
        {
          stemSelectorBlinkState = !stemSelectorBlinkState;
        }
      }

      function restartStemSelectorTimer(enable)
      {
        if (enable)
        {
          stemSelectorBlinkState = true;
          stemSelectorTimer.restart();
        }
      }

      ButtonScriptAdapter 
      {
        name: "stem_selector_mode_adapter_1"
        onPress: 
        { 
          stemSelectorMode1.value = newValueForStemSelectorModeOnPress(stemSelectorMode1.value)
          restartStemSelectorTimer(stemSelectorMode1.value);
          stemSelectorModeAny.value = (stemSelectorMode1.value || stemSelectorMode2.value || stemSelectorMode3.value || stemSelectorMode4.value)
        }
        onRelease:
        {
          stemSelectorMode1.value = newValueForStemSelectorModeOnRelease(stemSelectorMode1.value)
          stemSelectorModeAny.value = (stemSelectorMode1.value || stemSelectorMode2.value || stemSelectorMode3.value || stemSelectorMode4.value)
        }
        brightness: stemSelectorMode1.value && stemSelectorBlinkState;
        color: stem_selector_color
      }
      ButtonScriptAdapter 
      {
        name: "stem_selector_mode_adapter_2"
        onPress: 
        { 
          stemSelectorMode2.value = newValueForStemSelectorModeOnPress(stemSelectorMode2.value)
          restartStemSelectorTimer(stemSelectorMode2.value);
          stemSelectorModeAny.value = (stemSelectorMode1.value || stemSelectorMode2.value || stemSelectorMode3.value || stemSelectorMode4.value)
        }
        onRelease:
        {
          stemSelectorMode2.value = newValueForStemSelectorModeOnRelease(stemSelectorMode2.value)
          stemSelectorModeAny.value = (stemSelectorMode1.value || stemSelectorMode2.value || stemSelectorMode3.value || stemSelectorMode4.value)
        }
        brightness: stemSelectorMode2.value && stemSelectorBlinkState;
        color: stem_selector_color
      }
      ButtonScriptAdapter 
      {
        name: "stem_selector_mode_adapter_3"
        onPress: 
        { 
          stemSelectorMode3.value = newValueForStemSelectorModeOnPress(stemSelectorMode3.value)
          restartStemSelectorTimer(stemSelectorMode3.value);
          stemSelectorModeAny.value = (stemSelectorMode1.value || stemSelectorMode2.value || stemSelectorMode3.value || stemSelectorMode4.value)
        }
        onRelease:
        {
          stemSelectorMode3.value = newValueForStemSelectorModeOnRelease(stemSelectorMode3.value)
          stemSelectorModeAny.value = (stemSelectorMode1.value || stemSelectorMode2.value || stemSelectorMode3.value || stemSelectorMode4.value)
        }
        brightness: stemSelectorMode3.value && stemSelectorBlinkState;
        color: stem_selector_color
      }
      ButtonScriptAdapter 
      {
        name: "stem_selector_mode_adapter_4"
        onPress: 
        { 
          stemSelectorMode4.value = newValueForStemSelectorModeOnPress(stemSelectorMode4.value)
          restartStemSelectorTimer(stemSelectorMode4.value);
          stemSelectorModeAny.value = (stemSelectorMode1.value || stemSelectorMode2.value || stemSelectorMode3.value || stemSelectorMode4.value)
        }
        onRelease:
        {
          stemSelectorMode4.value = newValueForStemSelectorModeOnRelease(stemSelectorMode4.value)
          stemSelectorModeAny.value = (stemSelectorMode1.value || stemSelectorMode2.value || stemSelectorMode3.value || stemSelectorMode4.value)
        }
        brightness: stemSelectorMode4.value && stemSelectorBlinkState;
        color: stem_selector_color
      }

      // Deck A
      WiresGroup
      {
        enabled: padsFocusedDeckId == 1

        // Hotcues
        WiresGroup
        {
          enabled: padsMode.value == hotcueMode

          WiresGroup
          {
            enabled: !module.shift

            Wire { from: "%surface%.pads.1";   to: "decks.1.hotcues.1.trigger" }
            Wire { from: "%surface%.pads.2";   to: "decks.1.hotcues.2.trigger" }
            Wire { from: "%surface%.pads.3";   to: "decks.1.hotcues.3.trigger" }
            Wire { from: "%surface%.pads.4";   to: "decks.1.hotcues.4.trigger" }
            Wire { from: "%surface%.pads.5";   to: "decks.1.hotcues.5.trigger" }
            Wire { from: "%surface%.pads.6";   to: "decks.1.hotcues.6.trigger" }
            Wire { from: "%surface%.pads.7";   to: "decks.1.hotcues.7.trigger" }
            Wire { from: "%surface%.pads.8";   to: "decks.1.hotcues.8.trigger" }
          }

          WiresGroup
          {
            enabled: module.shift

            Wire { from: "%surface%.pads.1";   to: "decks.1.hotcues.1.delete" }
            Wire { from: "%surface%.pads.2";   to: "decks.1.hotcues.2.delete" }
            Wire { from: "%surface%.pads.3";   to: "decks.1.hotcues.3.delete" }
            Wire { from: "%surface%.pads.4";   to: "decks.1.hotcues.4.delete" }
            Wire { from: "%surface%.pads.5";   to: "decks.1.hotcues.5.delete" }
            Wire { from: "%surface%.pads.6";   to: "decks.1.hotcues.6.delete" }
            Wire { from: "%surface%.pads.7";   to: "decks.1.hotcues.7.delete" }
            Wire { from: "%surface%.pads.8";   to: "decks.1.hotcues.8.delete" }
          }
        }

        // Freeze/Slicer
        WiresGroup
        {
          enabled: padsMode.value == freezeMode

          Wire { from: "%surface%.pads.1";   to: "decks.1.freeze_slicer.slice1" }
          Wire { from: "%surface%.pads.2";   to: "decks.1.freeze_slicer.slice2" }
          Wire { from: "%surface%.pads.3";   to: "decks.1.freeze_slicer.slice3" }
          Wire { from: "%surface%.pads.4";   to: "decks.1.freeze_slicer.slice4" }
          Wire { from: "%surface%.pads.5";   to: "decks.1.freeze_slicer.slice5" }
          Wire { from: "%surface%.pads.6";   to: "decks.1.freeze_slicer.slice6" }
          Wire { from: "%surface%.pads.7";   to: "decks.1.freeze_slicer.slice7" }
          Wire { from: "%surface%.pads.8";   to: "decks.1.freeze_slicer.slice8" }
        }

        // Remix
        WiresGroup
        {
          enabled: padsMode.value == remixMode

          Wire { from: "decks.1.remix.capture_mode.input";  to: DirectPropertyAdapter { path: propertiesPath + ".capture"; input: false } }

          WiresGroup
          {
            enabled: !module.shift && !remixState.value

            Wire { from: "%surface%.pads.1"; to: "decks.1.remix.1_1.primary" }
            Wire { from: "%surface%.pads.2"; to: "decks.1.remix.2_1.primary" }
            Wire { from: "%surface%.pads.3"; to: "decks.1.remix.3_1.primary" }
            Wire { from: "%surface%.pads.4"; to: "decks.1.remix.4_1.primary" }
            Wire { from: "%surface%.pads.5"; to: "decks.1.remix.1_2.primary" }
            Wire { from: "%surface%.pads.6"; to: "decks.1.remix.2_2.primary" }
            Wire { from: "%surface%.pads.7"; to: "decks.1.remix.3_2.primary" }
            Wire { from: "%surface%.pads.8"; to: "decks.1.remix.4_2.primary" }
          }

          WiresGroup
          {
            enabled: module.shift && !remixState.value

            Wire { from: "%surface%.pads.1"; to: "decks.1.remix.1_1.secondary"  }
            Wire { from: "%surface%.pads.2"; to: "decks.1.remix.2_1.secondary"  }
            Wire { from: "%surface%.pads.3"; to: "decks.1.remix.3_1.secondary"  }
            Wire { from: "%surface%.pads.4"; to: "decks.1.remix.4_1.secondary"  }
            Wire { from: "%surface%.pads.5"; to: "decks.1.remix.1_2.secondary"  }
            Wire { from: "%surface%.pads.6"; to: "decks.1.remix.2_2.secondary"  }
            Wire { from: "%surface%.pads.7"; to: "decks.1.remix.3_2.secondary"  }
            Wire { from: "%surface%.pads.8"; to: "decks.1.remix.4_2.secondary"  }
          }
          
          WiresGroup
          {
            enabled: remixState.value

            Wire { from: "%surface%.pads.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.1.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.2.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.3.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.4.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.5"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.1.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.6"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.2.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.7"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.3.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.8"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.4.muted"; color: Color.Blue; invertBrightness: true }  }
          }

          WiresGroup
          {
            enabled: !remixState.value
            
            Wire { from: "decks.1.remix.1_1";     to: "%surface%.pads.1.led" }
            Wire { from: "decks.1.remix.2_1";     to: "%surface%.pads.2.led" }
            Wire { from: "decks.1.remix.3_1";     to: "%surface%.pads.3.led" }
            Wire { from: "decks.1.remix.4_1";     to: "%surface%.pads.4.led" }
            Wire { from: "decks.1.remix.1_2";     to: "%surface%.pads.5.led" }
            Wire { from: "decks.1.remix.2_2";     to: "%surface%.pads.6.led" }
            Wire { from: "decks.1.remix.3_2";     to: "%surface%.pads.7.led" }
            Wire { from: "decks.1.remix.4_2";     to: "%surface%.pads.8.led" }
          }
        }

        // Stem
        WiresGroup
        {
          enabled: padsMode.value == stemMode

          WiresGroup
          {
            enabled: !module.shift
            Wire { from: "%surface%.pads.1"; to: "decks.1.stems.1.muted" }
            Wire { from: "%surface%.pads.2"; to: "decks.1.stems.2.muted" }
            Wire { from: "%surface%.pads.3"; to: "decks.1.stems.3.muted" }
            Wire { from: "%surface%.pads.4"; to: "decks.1.stems.4.muted" }
          }
          
          WiresGroup
          {
            enabled: module.shift
            Wire { from: "%surface%.pads.1"; to: "decks.1.stems.1.fx_send_on" }
            Wire { from: "%surface%.pads.2"; to: "decks.1.stems.2.fx_send_on" }
            Wire { from: "%surface%.pads.3"; to: "decks.1.stems.3.fx_send_on" }
            Wire { from: "%surface%.pads.4"; to: "decks.1.stems.4.fx_send_on" }
          }

          WiresGroup
          {
            enabled: screenOverlay.value == Overlay.none && screenViewProp.value == ScreenView.deck 

            WiresGroup
            {
              enabled: !module.shift
              Wire { from: "%surface%.pads.5"; to: "stem_selector_mode_adapter_1" }
              Wire { from: "%surface%.pads.6"; to: "stem_selector_mode_adapter_2" }
              Wire { from: "%surface%.pads.7"; to: "stem_selector_mode_adapter_3" }
              Wire { from: "%surface%.pads.8"; to: "stem_selector_mode_adapter_4" }
            }

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.pads.5";      to: "decks.1.reset_stems.1.volume"    }
              Wire { from: "%surface%.pads.5";      to: "decks.1.reset_stems.1.filter"    }
              Wire { from: "%surface%.pads.5";      to: "decks.1.reset_stems.1.filter_on" }

              Wire { from: "%surface%.pads.6";      to: "decks.1.reset_stems.2.volume"    }
              Wire { from: "%surface%.pads.6";      to: "decks.1.reset_stems.2.filter"    }
              Wire { from: "%surface%.pads.6";      to: "decks.1.reset_stems.2.filter_on" }

              Wire { from: "%surface%.pads.7";      to: "decks.1.reset_stems.3.volume"    }
              Wire { from: "%surface%.pads.7";      to: "decks.1.reset_stems.3.filter"    }
              Wire { from: "%surface%.pads.7";      to: "decks.1.reset_stems.3.filter_on" }

              Wire { from: "%surface%.pads.8";      to: "decks.1.reset_stems.4.volume"    }
              Wire { from: "%surface%.pads.8";      to: "decks.1.reset_stems.4.filter"    }
              Wire { from: "%surface%.pads.8";      to: "decks.1.reset_stems.4.filter_on" }
            }
          }
          
          Wire { from: "%surface%.browse.push";      to: "decks.1.reset_stems.1.volume";   enabled: stemSelectorMode1.value }
          Wire { from: "%surface%.browse.push";      to: "decks.1.reset_stems.2.volume";   enabled: stemSelectorMode2.value }
          Wire { from: "%surface%.browse.push";      to: "decks.1.reset_stems.3.volume";   enabled: stemSelectorMode3.value }
          Wire { from: "%surface%.browse.push";      to: "decks.1.reset_stems.4.volume";   enabled: stemSelectorMode4.value }
        }
      }

      // Deck C
      WiresGroup
      {
        enabled: (padsFocusedDeckId == 3)

        // Hotcues
        WiresGroup
        {
          enabled: padsMode.value == hotcueMode

          WiresGroup
          {
            enabled: !module.shift

            Wire { from: "%surface%.pads.1";   to: "decks.3.hotcues.1.trigger" }
            Wire { from: "%surface%.pads.2";   to: "decks.3.hotcues.2.trigger" }
            Wire { from: "%surface%.pads.3";   to: "decks.3.hotcues.3.trigger" }
            Wire { from: "%surface%.pads.4";   to: "decks.3.hotcues.4.trigger" }
            Wire { from: "%surface%.pads.5";   to: "decks.3.hotcues.5.trigger" }
            Wire { from: "%surface%.pads.6";   to: "decks.3.hotcues.6.trigger" }
            Wire { from: "%surface%.pads.7";   to: "decks.3.hotcues.7.trigger" }
            Wire { from: "%surface%.pads.8";   to: "decks.3.hotcues.8.trigger" }
          }

          WiresGroup
          {
            enabled: module.shift

            Wire { from: "%surface%.pads.1";   to: "decks.3.hotcues.1.delete" }
            Wire { from: "%surface%.pads.2";   to: "decks.3.hotcues.2.delete" }
            Wire { from: "%surface%.pads.3";   to: "decks.3.hotcues.3.delete" }
            Wire { from: "%surface%.pads.4";   to: "decks.3.hotcues.4.delete" }
            Wire { from: "%surface%.pads.5";   to: "decks.3.hotcues.5.delete" }
            Wire { from: "%surface%.pads.6";   to: "decks.3.hotcues.6.delete" }
            Wire { from: "%surface%.pads.7";   to: "decks.3.hotcues.7.delete" }
            Wire { from: "%surface%.pads.8";   to: "decks.3.hotcues.8.delete" }
          }
        }

        // Freeze/Slicer
        WiresGroup
        {
          enabled: padsMode.value == freezeMode

          Wire { from: "%surface%.pads.1";   to: "decks.3.freeze_slicer.slice1" }
          Wire { from: "%surface%.pads.2";   to: "decks.3.freeze_slicer.slice2" }
          Wire { from: "%surface%.pads.3";   to: "decks.3.freeze_slicer.slice3" }
          Wire { from: "%surface%.pads.4";   to: "decks.3.freeze_slicer.slice4" }
          Wire { from: "%surface%.pads.5";   to: "decks.3.freeze_slicer.slice5" }
          Wire { from: "%surface%.pads.6";   to: "decks.3.freeze_slicer.slice6" }
          Wire { from: "%surface%.pads.7";   to: "decks.3.freeze_slicer.slice7" }
          Wire { from: "%surface%.pads.8";   to: "decks.3.freeze_slicer.slice8" }
        }

        // Remix
        WiresGroup
        {
          enabled: padsMode.value == remixMode

          Wire { from: "decks.3.remix.capture_mode.input";  to: DirectPropertyAdapter { path: propertiesPath + ".capture"; input: false } }

          WiresGroup
          {
            enabled: !module.shift && !remixState.value

            Wire { from: "%surface%.pads.1"; to: "decks.3.remix.1_1.primary" }
            Wire { from: "%surface%.pads.2"; to: "decks.3.remix.2_1.primary" }
            Wire { from: "%surface%.pads.3"; to: "decks.3.remix.3_1.primary" }
            Wire { from: "%surface%.pads.4"; to: "decks.3.remix.4_1.primary" }
            Wire { from: "%surface%.pads.5"; to: "decks.3.remix.1_2.primary" }
            Wire { from: "%surface%.pads.6"; to: "decks.3.remix.2_2.primary" }
            Wire { from: "%surface%.pads.7"; to: "decks.3.remix.3_2.primary" }
            Wire { from: "%surface%.pads.8"; to: "decks.3.remix.4_2.primary" }
          }

          WiresGroup
          {
            enabled: module.shift && !remixState.value

            Wire { from: "%surface%.pads.1"; to: "decks.3.remix.1_1.secondary"  }
            Wire { from: "%surface%.pads.2"; to: "decks.3.remix.2_1.secondary"  }
            Wire { from: "%surface%.pads.3"; to: "decks.3.remix.3_1.secondary"  }
            Wire { from: "%surface%.pads.4"; to: "decks.3.remix.4_1.secondary"  }
            Wire { from: "%surface%.pads.5"; to: "decks.3.remix.1_2.secondary"  }
            Wire { from: "%surface%.pads.6"; to: "decks.3.remix.2_2.secondary"  }
            Wire { from: "%surface%.pads.7"; to: "decks.3.remix.3_2.secondary"  }
            Wire { from: "%surface%.pads.8"; to: "decks.3.remix.4_2.secondary"  }
          }
          
          WiresGroup
          {
            enabled: remixState.value

            Wire { from: "%surface%.pads.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.1.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.2.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.3.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.4.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.5"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.1.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.6"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.2.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.7"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.3.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.8"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.4.muted"; color: Color.White; invertBrightness: true }  }
          }

          WiresGroup
          {
            enabled: !remixState.value
            
            Wire { from: "decks.3.remix.1_1";     to: "%surface%.pads.1.led" }
            Wire { from: "decks.3.remix.2_1";     to: "%surface%.pads.2.led" }
            Wire { from: "decks.3.remix.3_1";     to: "%surface%.pads.3.led" }
            Wire { from: "decks.3.remix.4_1";     to: "%surface%.pads.4.led" }
            Wire { from: "decks.3.remix.1_2";     to: "%surface%.pads.5.led" }
            Wire { from: "decks.3.remix.2_2";     to: "%surface%.pads.6.led" }
            Wire { from: "decks.3.remix.3_2";     to: "%surface%.pads.7.led" }
            Wire { from: "decks.3.remix.4_2";     to: "%surface%.pads.8.led" }
          }
        }

        // Stem
        WiresGroup
        {
          enabled: padsMode.value == stemMode

          WiresGroup
          {
            enabled: !module.shift
            Wire { from: "%surface%.pads.1"; to: "decks.3.stems.1.muted" }
            Wire { from: "%surface%.pads.2"; to: "decks.3.stems.2.muted" }
            Wire { from: "%surface%.pads.3"; to: "decks.3.stems.3.muted" }
            Wire { from: "%surface%.pads.4"; to: "decks.3.stems.4.muted" }
          }
          
          WiresGroup
          {
            enabled: module.shift
            Wire { from: "%surface%.pads.1"; to: "decks.3.stems.1.fx_send_on" }
            Wire { from: "%surface%.pads.2"; to: "decks.3.stems.2.fx_send_on" }
            Wire { from: "%surface%.pads.3"; to: "decks.3.stems.3.fx_send_on" }
            Wire { from: "%surface%.pads.4"; to: "decks.3.stems.4.fx_send_on" }
          }

          WiresGroup
          {
            enabled: screenOverlay.value == Overlay.none && screenViewProp.value == ScreenView.deck 

            WiresGroup
            {
              enabled: !module.shift
              Wire { from: "%surface%.pads.5"; to: "stem_selector_mode_adapter_1" }
              Wire { from: "%surface%.pads.6"; to: "stem_selector_mode_adapter_2" }
              Wire { from: "%surface%.pads.7"; to: "stem_selector_mode_adapter_3" }
              Wire { from: "%surface%.pads.8"; to: "stem_selector_mode_adapter_4" }
            }

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.pads.5";      to: "decks.3.reset_stems.1.volume"    }
              Wire { from: "%surface%.pads.5";      to: "decks.3.reset_stems.1.filter"    }
              Wire { from: "%surface%.pads.5";      to: "decks.3.reset_stems.1.filter_on" }

              Wire { from: "%surface%.pads.6";      to: "decks.3.reset_stems.2.volume"    }
              Wire { from: "%surface%.pads.6";      to: "decks.3.reset_stems.2.filter"    }
              Wire { from: "%surface%.pads.6";      to: "decks.3.reset_stems.2.filter_on" }

              Wire { from: "%surface%.pads.7";      to: "decks.3.reset_stems.3.volume"    }
              Wire { from: "%surface%.pads.7";      to: "decks.3.reset_stems.3.filter"    }
              Wire { from: "%surface%.pads.7";      to: "decks.3.reset_stems.3.filter_on" }

              Wire { from: "%surface%.pads.8";      to: "decks.3.reset_stems.4.volume"    }
              Wire { from: "%surface%.pads.8";      to: "decks.3.reset_stems.4.filter"    }
              Wire { from: "%surface%.pads.8";      to: "decks.3.reset_stems.4.filter_on" }
            }
          }
          
          Wire { from: "%surface%.browse.push";      to: "decks.3.reset_stems.1.volume";   enabled: stemSelectorMode1.value }
          Wire { from: "%surface%.browse.push";      to: "decks.3.reset_stems.2.volume";   enabled: stemSelectorMode2.value }
          Wire { from: "%surface%.browse.push";      to: "decks.3.reset_stems.3.volume";   enabled: stemSelectorMode3.value }
          Wire { from: "%surface%.browse.push";      to: "decks.3.reset_stems.4.volume";   enabled: stemSelectorMode4.value }
        }
      }

      // Deck B
      WiresGroup
      {
        enabled: (padsFocusedDeckId == 2)

        // Hotcues
        WiresGroup
        {
          enabled: padsMode.value == hotcueMode

          WiresGroup
          {
            enabled: !module.shift

            Wire { from: "%surface%.pads.1";    to: "decks.2.hotcues.1.trigger" }
            Wire { from: "%surface%.pads.2";    to: "decks.2.hotcues.2.trigger" }
            Wire { from: "%surface%.pads.3";    to: "decks.2.hotcues.3.trigger" }
            Wire { from: "%surface%.pads.4";    to: "decks.2.hotcues.4.trigger" }
            Wire { from: "%surface%.pads.5";    to: "decks.2.hotcues.5.trigger" }
            Wire { from: "%surface%.pads.6";    to: "decks.2.hotcues.6.trigger" }
            Wire { from: "%surface%.pads.7";    to: "decks.2.hotcues.7.trigger" }
            Wire { from: "%surface%.pads.8";    to: "decks.2.hotcues.8.trigger" }
          }

          WiresGroup
          {
            enabled: module.shift

            Wire { from: "%surface%.pads.1";    to: "decks.2.hotcues.1.delete" }
            Wire { from: "%surface%.pads.2";    to: "decks.2.hotcues.2.delete" }
            Wire { from: "%surface%.pads.3";    to: "decks.2.hotcues.3.delete" }
            Wire { from: "%surface%.pads.4";    to: "decks.2.hotcues.4.delete" }
            Wire { from: "%surface%.pads.5";    to: "decks.2.hotcues.5.delete" }
            Wire { from: "%surface%.pads.6";    to: "decks.2.hotcues.6.delete" }
            Wire { from: "%surface%.pads.7";    to: "decks.2.hotcues.7.delete" }
            Wire { from: "%surface%.pads.8";    to: "decks.2.hotcues.8.delete" }
          }
        }

        // Freeze/Slicer
        WiresGroup
        {
          enabled: padsMode.value == freezeMode

          Wire { from: "%surface%.pads.1";   to: "decks.2.freeze_slicer.slice1" }
          Wire { from: "%surface%.pads.2";   to: "decks.2.freeze_slicer.slice2" }
          Wire { from: "%surface%.pads.3";   to: "decks.2.freeze_slicer.slice3" }
          Wire { from: "%surface%.pads.4";   to: "decks.2.freeze_slicer.slice4" }
          Wire { from: "%surface%.pads.5";   to: "decks.2.freeze_slicer.slice5" }
          Wire { from: "%surface%.pads.6";   to: "decks.2.freeze_slicer.slice6" }
          Wire { from: "%surface%.pads.7";   to: "decks.2.freeze_slicer.slice7" }
          Wire { from: "%surface%.pads.8";   to: "decks.2.freeze_slicer.slice8" }
        }
        // Remix
        WiresGroup
        {
          enabled: padsMode.value == remixMode

          Wire { from: "decks.2.remix.capture_mode.input";  to: DirectPropertyAdapter { path: propertiesPath + ".capture"; input: false } }

          WiresGroup
          {
            enabled: !module.shift && !remixState.value

            Wire { from: "%surface%.pads.1"; to: "decks.2.remix.1_1.primary" }
            Wire { from: "%surface%.pads.2"; to: "decks.2.remix.2_1.primary" }
            Wire { from: "%surface%.pads.3"; to: "decks.2.remix.3_1.primary" }
            Wire { from: "%surface%.pads.4"; to: "decks.2.remix.4_1.primary" }
            Wire { from: "%surface%.pads.5"; to: "decks.2.remix.1_2.primary" }
            Wire { from: "%surface%.pads.6"; to: "decks.2.remix.2_2.primary" }
            Wire { from: "%surface%.pads.7"; to: "decks.2.remix.3_2.primary" }
            Wire { from: "%surface%.pads.8"; to: "decks.2.remix.4_2.primary" }
          }

          WiresGroup
          {
            enabled: module.shift && !remixState.value

            Wire { from: "%surface%.pads.1"; to: "decks.2.remix.1_1.secondary"  }
            Wire { from: "%surface%.pads.2"; to: "decks.2.remix.2_1.secondary"  }
            Wire { from: "%surface%.pads.3"; to: "decks.2.remix.3_1.secondary"  }
            Wire { from: "%surface%.pads.4"; to: "decks.2.remix.4_1.secondary"  }
            Wire { from: "%surface%.pads.5"; to: "decks.2.remix.1_2.secondary"  }
            Wire { from: "%surface%.pads.6"; to: "decks.2.remix.2_2.secondary"  }
            Wire { from: "%surface%.pads.7"; to: "decks.2.remix.3_2.secondary"  }
            Wire { from: "%surface%.pads.8"; to: "decks.2.remix.4_2.secondary"  }
          }
          
          WiresGroup
          {
            enabled: remixState.value

            Wire { from: "%surface%.pads.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.1.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.2.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.3.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.4.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.5"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.1.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.6"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.2.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.7"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.3.muted"; color: Color.Blue; invertBrightness: true }  }
            Wire { from: "%surface%.pads.8"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.4.muted"; color: Color.Blue; invertBrightness: true }  }
          }

          WiresGroup
          {
            enabled: !remixState.value
            
            Wire { from: "decks.2.remix.1_1";     to: "%surface%.pads.1.led" }
            Wire { from: "decks.2.remix.2_1";     to: "%surface%.pads.2.led" }
            Wire { from: "decks.2.remix.3_1";     to: "%surface%.pads.3.led" }
            Wire { from: "decks.2.remix.4_1";     to: "%surface%.pads.4.led" }
            Wire { from: "decks.2.remix.1_2";     to: "%surface%.pads.5.led" }
            Wire { from: "decks.2.remix.2_2";     to: "%surface%.pads.6.led" }
            Wire { from: "decks.2.remix.3_2";     to: "%surface%.pads.7.led" }
            Wire { from: "decks.2.remix.4_2";     to: "%surface%.pads.8.led" }
          }
        }

        // Stem
        WiresGroup
        {
        enabled: padsMode.value == stemMode

          WiresGroup
          {
            enabled: !module.shift
            Wire { from: "%surface%.pads.1"; to: "decks.2.stems.1.muted" }
            Wire { from: "%surface%.pads.2"; to: "decks.2.stems.2.muted" }
            Wire { from: "%surface%.pads.3"; to: "decks.2.stems.3.muted" }
            Wire { from: "%surface%.pads.4"; to: "decks.2.stems.4.muted" }
          }
          
          WiresGroup
          {
            enabled: module.shift
            Wire { from: "%surface%.pads.1"; to: "decks.2.stems.1.fx_send_on" }
            Wire { from: "%surface%.pads.2"; to: "decks.2.stems.2.fx_send_on" }
            Wire { from: "%surface%.pads.3"; to: "decks.2.stems.3.fx_send_on" }
            Wire { from: "%surface%.pads.4"; to: "decks.2.stems.4.fx_send_on" }
          }

          WiresGroup
          {
            enabled: screenOverlay.value == Overlay.none && screenViewProp.value == ScreenView.deck 

            WiresGroup
            {
              enabled: !module.shift
              Wire { from: "%surface%.pads.5"; to: "stem_selector_mode_adapter_1" }
              Wire { from: "%surface%.pads.6"; to: "stem_selector_mode_adapter_2" }
              Wire { from: "%surface%.pads.7"; to: "stem_selector_mode_adapter_3" }
              Wire { from: "%surface%.pads.8"; to: "stem_selector_mode_adapter_4" }
            }

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.pads.5";      to: "decks.2.reset_stems.1.volume"    }
              Wire { from: "%surface%.pads.5";      to: "decks.2.reset_stems.1.filter"    }
              Wire { from: "%surface%.pads.5";      to: "decks.2.reset_stems.1.filter_on" }

              Wire { from: "%surface%.pads.6";      to: "decks.2.reset_stems.2.volume"    }
              Wire { from: "%surface%.pads.6";      to: "decks.2.reset_stems.2.filter"    }
              Wire { from: "%surface%.pads.6";      to: "decks.2.reset_stems.2.filter_on" }

              Wire { from: "%surface%.pads.7";      to: "decks.2.reset_stems.3.volume"    }
              Wire { from: "%surface%.pads.7";      to: "decks.2.reset_stems.3.filter"    }
              Wire { from: "%surface%.pads.7";      to: "decks.2.reset_stems.3.filter_on" }

              Wire { from: "%surface%.pads.8";      to: "decks.2.reset_stems.4.volume"    }
              Wire { from: "%surface%.pads.8";      to: "decks.2.reset_stems.4.filter"    }
              Wire { from: "%surface%.pads.8";      to: "decks.2.reset_stems.4.filter_on" }
            }
          }
          
          Wire { from: "%surface%.browse.push";      to: "decks.2.reset_stems.1.volume";   enabled: stemSelectorMode1.value }
          Wire { from: "%surface%.browse.push";      to: "decks.2.reset_stems.2.volume";   enabled: stemSelectorMode2.value }
          Wire { from: "%surface%.browse.push";      to: "decks.2.reset_stems.3.volume";   enabled: stemSelectorMode3.value }
          Wire { from: "%surface%.browse.push";      to: "decks.2.reset_stems.4.volume";   enabled: stemSelectorMode4.value }
        }
      }

      // Deck D
      WiresGroup
      {
        enabled: (padsFocusedDeckId == 4)

        // Hotcues
        WiresGroup
        {
          enabled: padsMode.value == hotcueMode

          WiresGroup
          {
            enabled: !module.shift

            Wire { from: "%surface%.pads.1";    to: "decks.4.hotcues.1.trigger" }
            Wire { from: "%surface%.pads.2";    to: "decks.4.hotcues.2.trigger" }
            Wire { from: "%surface%.pads.3";    to: "decks.4.hotcues.3.trigger" }
            Wire { from: "%surface%.pads.4";    to: "decks.4.hotcues.4.trigger" }
            Wire { from: "%surface%.pads.5";    to: "decks.4.hotcues.5.trigger" }
            Wire { from: "%surface%.pads.6";    to: "decks.4.hotcues.6.trigger" }
            Wire { from: "%surface%.pads.7";    to: "decks.4.hotcues.7.trigger" }
            Wire { from: "%surface%.pads.8";    to: "decks.4.hotcues.8.trigger" }
          }

          WiresGroup
          {
            enabled: module.shift

            Wire { from: "%surface%.pads.1";    to: "decks.4.hotcues.1.delete" }
            Wire { from: "%surface%.pads.2";    to: "decks.4.hotcues.2.delete" }
            Wire { from: "%surface%.pads.3";    to: "decks.4.hotcues.3.delete" }
            Wire { from: "%surface%.pads.4";    to: "decks.4.hotcues.4.delete" }
            Wire { from: "%surface%.pads.5";    to: "decks.4.hotcues.5.delete" }
            Wire { from: "%surface%.pads.6";    to: "decks.4.hotcues.6.delete" }
            Wire { from: "%surface%.pads.7";    to: "decks.4.hotcues.7.delete" }
            Wire { from: "%surface%.pads.8";    to: "decks.4.hotcues.8.delete" }
          }
        }

        // Freeze/Slicer
        WiresGroup
        {
          enabled: padsMode.value == freezeMode

          Wire { from: "%surface%.pads.1";   to: "decks.4.freeze_slicer.slice1" }
          Wire { from: "%surface%.pads.2";   to: "decks.4.freeze_slicer.slice2" }
          Wire { from: "%surface%.pads.3";   to: "decks.4.freeze_slicer.slice3" }
          Wire { from: "%surface%.pads.4";   to: "decks.4.freeze_slicer.slice4" }
          Wire { from: "%surface%.pads.5";   to: "decks.4.freeze_slicer.slice5" }
          Wire { from: "%surface%.pads.6";   to: "decks.4.freeze_slicer.slice6" }
          Wire { from: "%surface%.pads.7";   to: "decks.4.freeze_slicer.slice7" }
          Wire { from: "%surface%.pads.8";   to: "decks.4.freeze_slicer.slice8" }
        }

        // Remix
        WiresGroup
        {
          enabled: padsMode.value == remixMode

          Wire { from: "decks.4.remix.capture_mode.input";  to: DirectPropertyAdapter { path: propertiesPath + ".capture"; input: false } }

          WiresGroup
          {
            enabled: !module.shift && !remixState.value

            Wire { from: "%surface%.pads.1"; to: "decks.4.remix.1_1.primary" }
            Wire { from: "%surface%.pads.2"; to: "decks.4.remix.2_1.primary" }
            Wire { from: "%surface%.pads.3"; to: "decks.4.remix.3_1.primary" }
            Wire { from: "%surface%.pads.4"; to: "decks.4.remix.4_1.primary" }
            Wire { from: "%surface%.pads.5"; to: "decks.4.remix.1_2.primary" }
            Wire { from: "%surface%.pads.6"; to: "decks.4.remix.2_2.primary" }
            Wire { from: "%surface%.pads.7"; to: "decks.4.remix.3_2.primary" }
            Wire { from: "%surface%.pads.8"; to: "decks.4.remix.4_2.primary" }
          }

          WiresGroup
          {
            enabled: module.shift && !remixState.value

            Wire { from: "%surface%.pads.1"; to: "decks.4.remix.1_1.secondary"  }
            Wire { from: "%surface%.pads.2"; to: "decks.4.remix.2_1.secondary"  }
            Wire { from: "%surface%.pads.3"; to: "decks.4.remix.3_1.secondary"  }
            Wire { from: "%surface%.pads.4"; to: "decks.4.remix.4_1.secondary"  }
            Wire { from: "%surface%.pads.5"; to: "decks.4.remix.1_2.secondary"  }
            Wire { from: "%surface%.pads.6"; to: "decks.4.remix.2_2.secondary"  }
            Wire { from: "%surface%.pads.7"; to: "decks.4.remix.3_2.secondary"  }
            Wire { from: "%surface%.pads.8"; to: "decks.4.remix.4_2.secondary"  }
          }
          
          WiresGroup
          {
            enabled: remixState.value

            Wire { from: "%surface%.pads.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.1.muted"; color: Color.White; invertBrightness: true } }
            Wire { from: "%surface%.pads.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.2.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.3.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.4.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.5"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.1.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.6"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.2.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.7"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.3.muted"; color: Color.White; invertBrightness: true }  }
            Wire { from: "%surface%.pads.8"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.4.muted"; color: Color.White; invertBrightness: true }  }
          }

          WiresGroup
          {
            enabled: !remixState.value
            
            Wire { from: "decks.4.remix.1_1";     to: "%surface%.pads.1.led" }
            Wire { from: "decks.4.remix.2_1";     to: "%surface%.pads.2.led" }
            Wire { from: "decks.4.remix.3_1";     to: "%surface%.pads.3.led" }
            Wire { from: "decks.4.remix.4_1";     to: "%surface%.pads.4.led" }
            Wire { from: "decks.4.remix.1_2";     to: "%surface%.pads.5.led" }
            Wire { from: "decks.4.remix.2_2";     to: "%surface%.pads.6.led" }
            Wire { from: "decks.4.remix.3_2";     to: "%surface%.pads.7.led" }
            Wire { from: "decks.4.remix.4_2";     to: "%surface%.pads.8.led" }
          }
        }

        // Stem
        WiresGroup
        {
        enabled: padsMode.value == stemMode

          WiresGroup
          {
            enabled: !module.shift
            Wire { from: "%surface%.pads.1"; to: "decks.4.stems.1.muted" }
            Wire { from: "%surface%.pads.2"; to: "decks.4.stems.2.muted" }
            Wire { from: "%surface%.pads.3"; to: "decks.4.stems.3.muted" }
            Wire { from: "%surface%.pads.4"; to: "decks.4.stems.4.muted" }
          }
          
          WiresGroup
          {
            enabled: module.shift
            Wire { from: "%surface%.pads.1"; to: "decks.4.stems.1.fx_send_on" }
            Wire { from: "%surface%.pads.2"; to: "decks.4.stems.2.fx_send_on" }
            Wire { from: "%surface%.pads.3"; to: "decks.4.stems.3.fx_send_on" }
            Wire { from: "%surface%.pads.4"; to: "decks.4.stems.4.fx_send_on" }
          }

          WiresGroup
          {
            enabled: screenOverlay.value == Overlay.none && screenViewProp.value == ScreenView.deck 

            WiresGroup
            {
              enabled: !module.shift
              Wire { from: "%surface%.pads.5"; to: "stem_selector_mode_adapter_1" }
              Wire { from: "%surface%.pads.6"; to: "stem_selector_mode_adapter_2" }
              Wire { from: "%surface%.pads.7"; to: "stem_selector_mode_adapter_3" }
              Wire { from: "%surface%.pads.8"; to: "stem_selector_mode_adapter_4" }
            }

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.pads.5";      to: "decks.4.reset_stems.1.volume"    }
              Wire { from: "%surface%.pads.5";      to: "decks.4.reset_stems.1.filter"    }
              Wire { from: "%surface%.pads.5";      to: "decks.4.reset_stems.1.filter_on" }

              Wire { from: "%surface%.pads.6";      to: "decks.4.reset_stems.2.volume"    }
              Wire { from: "%surface%.pads.6";      to: "decks.4.reset_stems.2.filter"    }
              Wire { from: "%surface%.pads.6";      to: "decks.4.reset_stems.2.filter_on" }

              Wire { from: "%surface%.pads.7";      to: "decks.4.reset_stems.3.volume"    }
              Wire { from: "%surface%.pads.7";      to: "decks.4.reset_stems.3.filter"    }
              Wire { from: "%surface%.pads.7";      to: "decks.4.reset_stems.3.filter_on" }

              Wire { from: "%surface%.pads.8";      to: "decks.4.reset_stems.4.volume"    }
              Wire { from: "%surface%.pads.8";      to: "decks.4.reset_stems.4.filter"    }
              Wire { from: "%surface%.pads.8";      to: "decks.4.reset_stems.4.filter_on" }
            }
          }
          
          Wire { from: "%surface%.browse.push";      to: "decks.4.reset_stems.1.volume";   enabled: stemSelectorMode1.value }
          Wire { from: "%surface%.browse.push";      to: "decks.4.reset_stems.2.volume";   enabled: stemSelectorMode2.value }
          Wire { from: "%surface%.browse.push";      to: "decks.4.reset_stems.3.volume";   enabled: stemSelectorMode3.value }
          Wire { from: "%surface%.browse.push";      to: "decks.4.reset_stems.4.volume";   enabled: stemSelectorMode4.value }
        }
      }

      // Freeze
      Wire { from: "%surface%.freeze"; to: DirectPropertyAdapter { path: propertiesPath + ".freeze"; output: false } enabled: hasFreezeMode(focusedDeckType) }

      SwitchTimer { name: "RemixHoldTimer";  setTimeout: 250 }

      WiresGroup
      {
        enabled: ((topDeckType == DeckType.Remix) || (bottomDeckType == DeckType.Remix))

        Wire { from: "%surface%.remix.value";  to: "RemixHoldTimer.input"  }
        Wire { from: "RemixHoldTimer.output";  to: DirectPropertyAdapter { path: propertiesPath + ".remix"; output: false } }
      }

      //------------------------------------------------------------------------------------------------------------------
      //  LOOP ENCODER
      //------------------------------------------------------------------------------------------------------------------

      HoldPropertyAdapter  { name: "ShowSliceOverlay";    path: propertiesPath + ".overlay";  value: Overlay.slice   }

      DirectPropertyAdapter { name: "Top_ShowLoopSize";    path: propertiesPath + ".top.show_loop_size" }
      DirectPropertyAdapter { name: "Bottom_ShowLoopSize"; path: propertiesPath + ".bottom.show_loop_size" }

      Blinker { name: "loop_encoder_blinker_blue";  autorun: true; color: Color.Blue  }
      Blinker { name: "loop_encoder_blinker_white"; autorun: true; color: Color.White }

      WiresGroup
      {
        enabled: encoderMode.value == encoderStemMode

        Wire { from: "%surface%.encoder.touch";     to: SetPropertyAdapter { path: propertiesPath + ".top.footer_page";    value: FooterPage.filter } enabled: !footerFocus.value }
        Wire { from: "%surface%.encoder.push";      to: SetPropertyAdapter { path: propertiesPath + ".top.footer_page";    value: FooterPage.filter } enabled: !footerFocus.value }
        Wire { from: "%surface%.encoder.is_turned"; to: SetPropertyAdapter { path: propertiesPath + ".top.footer_page";    value: FooterPage.filter } enabled: !footerFocus.value }
        Wire { from: "%surface%.encoder.touch";     to: SetPropertyAdapter { path: propertiesPath + ".bottom.footer_page"; value: FooterPage.filter } enabled:  footerFocus.value }
        Wire { from: "%surface%.encoder.push";      to: SetPropertyAdapter { path: propertiesPath + ".bottom.footer_page"; value: FooterPage.filter } enabled:  footerFocus.value }
        Wire { from: "%surface%.encoder.is_turned"; to: SetPropertyAdapter { path: propertiesPath + ".bottom.footer_page"; value: FooterPage.filter } enabled:  footerFocus.value }
      }
      
      // Deck A
      SwitchTimer { name: "DeckA_ShowLoopSizeTouchTimer"; setTimeout: 500 }

      WiresGroup
      {
        enabled: (encoderFocusedDeckId == 1)

        // Loop and Freeze modes
        WiresGroup
        {
          enabled: hasLoopMode(deckAType)

          WiresGroup
          {
            enabled: encoderMode.value == encoderLoopMode

            Wire { from: "%surface%.encoder";       to: "decks.1.loop.autoloop";     enabled: !module.shift }
            Wire { from: "%surface%.encoder";       to: "decks.1.loop.move";         enabled:  module.shift }
            Wire { from: "decks.1.loop.active";     to: "%surface%.loop.led";                              }
            Wire { from: "%surface%.encoder.touch"; to: "DeckA_ShowLoopSizeTouchTimer.input"                 }

            Wire
            {
              enabled: !module.shift
              from: Or
              {
                inputs:
                [
                  "DeckA_ShowLoopSizeTouchTimer.output",
                  "%surface%.encoder.is_turned"
                ]
              }
              to: "Top_ShowLoopSize.input"
            }

          }

          WiresGroup
          {
            enabled: encoderMode.value == encoderSlicerMode

            Wire
            {
              from: Or
              {
                inputs:
                [
                  "%surface%.encoder.touch",
                  "%surface%.encoder.is_turned"
                ]
              }
              to: "ShowSliceOverlay"
            }

            Wire { from: "%surface%.encoder.touch";   to: ButtonScriptAdapter  { onPress: { deckAExitFreeze = false; } } }
            Wire { from: "%surface%.loop.led"; to: "loop_encoder_blinker_blue" }

            Wire { from: "%surface%.encoder.turn"; to: "decks.1.freeze_slicer.slice_size"; enabled: !deckALoopActive.value }
            Wire { from: "%surface%.encoder.turn"; to: "decks.1.loop.autoloop";          enabled:  deckALoopActive.value }
          }
        }

        // Remix pages scrolling
        WiresGroup
        {
          enabled: (deckAType == DeckType.Remix) && (encoderMode.value == encoderRemixMode)

          Wire { from: "%surface%.encoder";         to: "decks.1.remix.page" }
          Wire { from: "%surface%.encoder";         to: "ShowDisplayButtonArea_EncoderAdapter"; enabled: !deckFocus }
          Wire { from: "loop_encoder_blinker_blue"; to: "%surface%.loop.led" }
        }

        // Remix capture source
        WiresGroup
        {
          enabled: (encoderMode.value == encoderCaptureMode)

          Wire { from: "%surface%.encoder.turn"; to: "decks.1.remix.capture_source" }
          Wire { from: "loop_encoder_blinker_blue"; to: "%surface%.loop.led" }
        }

        // Stem filter control
        WiresGroup
        {
          enabled: encoderMode.value == encoderStemMode && screenOverlay.value == Overlay.none && screenViewProp.value == ScreenView.deck
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.1.stems.1.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode1.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.1.stems.2.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode2.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.1.stems.3.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode3.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.1.stems.4.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode4.value  }

          WiresGroup
          {
            enabled: stemSelectorMode1.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.1.reset_stems.1.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.1.reset_stems.1.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.1.stems.1.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode2.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.1.reset_stems.2.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.1.reset_stems.2.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.1.stems.2.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode3.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.1.reset_stems.3.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.1.reset_stems.3.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.1.stems.3.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode4.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.1.reset_stems.4.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.1.reset_stems.4.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.1.stems.4.filter_on" } enabled: !module.shift }
          }
        }
      }

      // Deck C
      SwitchTimer { name: "DeckC_ShowLoopSizeTouchTimer"; setTimeout: 500 }

      WiresGroup
      {
        enabled: (encoderFocusedDeckId == 3)

        // Loop and Freeze modes
        WiresGroup
        {
          enabled: hasLoopMode(deckCType)

          WiresGroup
          {
            enabled: encoderMode.value == encoderLoopMode

            Wire { from: "%surface%.encoder";       to: "decks.3.loop.autoloop";     enabled: !module.shift }
            Wire { from: "%surface%.encoder";       to: "decks.3.loop.move";         enabled:  module.shift }
            Wire { from: "decks.3.loop.active";     to: "%surface%.loop.led";                              }
            Wire { from: "%surface%.encoder.touch"; to: "DeckC_ShowLoopSizeTouchTimer.input"                 }

            Wire
            {
              enabled: !module.shift
              from: Or
              {
                inputs:
                [
                  "DeckC_ShowLoopSizeTouchTimer.output",
                  "%surface%.encoder.is_turned"
                ]
              }
              to: "Bottom_ShowLoopSize.input"
            }
          }

          WiresGroup
          {
            enabled: encoderMode.value == encoderSlicerMode

            Wire
            {
              from: Or
              {
                inputs:
                [
                  "%surface%.encoder.touch",
                  "%surface%.encoder.is_turned"
                ]
              }
              to: "ShowSliceOverlay"
            }

            Wire { from: "%surface%.encoder.touch";   to: ButtonScriptAdapter  { onPress: { deckCExitFreeze = false; } } }
            Wire { from: "%surface%.loop.led"; to: "loop_encoder_blinker_white" }

            Wire { from: "%surface%.encoder.turn"; to: "decks.3.freeze_slicer.slice_size"; enabled: !deckCLoopActive.value }
            Wire { from: "%surface%.encoder.turn"; to: "decks.3.loop.autoloop";          enabled:  deckCLoopActive.value }
          }
        }

        // Remix pages scrolling
        WiresGroup
        {
          enabled: (deckCType == DeckType.Remix) && (encoderMode.value == encoderRemixMode)

          Wire { from: "%surface%.encoder";         to: "decks.3.remix.page" }
          Wire { from: "%surface%.encoder";         to: "ShowDisplayButtonArea_EncoderAdapter"; enabled: deckFocus }
          Wire { from: "loop_encoder_blinker_white"; to: "%surface%.loop.led" }
        }

        // Remix capture source
        WiresGroup
        {
          enabled:  encoderMode.value == encoderCaptureMode

          Wire { from: "%surface%.encoder.turn"; to: "decks.3.remix.capture_source" }
          Wire { from: "loop_encoder_blinker_white"; to: "%surface%.loop.led" }
        }

        // Stem filter control
        WiresGroup
        {
          enabled: encoderMode.value == encoderStemMode && screenOverlay.value == Overlay.none && screenViewProp.value == ScreenView.deck
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.3.stems.1.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode1.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.3.stems.2.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode2.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.3.stems.3.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode3.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.3.stems.4.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode4.value  }

          WiresGroup
          {
            enabled: stemSelectorMode1.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.3.reset_stems.1.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.3.reset_stems.1.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.3.stems.1.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode2.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.3.reset_stems.2.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.3.reset_stems.2.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.3.stems.2.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode3.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.3.reset_stems.3.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.3.reset_stems.3.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.3.stems.3.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode4.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.3.reset_stems.4.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.3.reset_stems.4.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.3.stems.4.filter_on" } enabled: !module.shift }
          }
        }
      }

      // Deck B
      SwitchTimer { name: "DeckB_ShowLoopSizeTouchTimer"; setTimeout: 500 }

      WiresGroup
      {
        enabled: (encoderFocusedDeckId == 2)

        // Loop and Freeze modes
        WiresGroup
        {
          enabled: hasLoopMode(deckBType)

          WiresGroup
          {
            enabled: encoderMode.value == encoderLoopMode

            Wire { from: "%surface%.encoder";       to: "decks.2.loop.autoloop";     enabled: !module.shift }
            Wire { from: "%surface%.encoder";       to: "decks.2.loop.move";         enabled:  module.shift }
            Wire { from: "decks.2.loop.active";       to: "%surface%.loop.led"                          }
            Wire { from: "%surface%.encoder.touch"; to: "DeckB_ShowLoopSizeTouchTimer.input"              }

            Wire
            {
              enabled: !module.shift
              from: Or
              {
                inputs:
                [
                  "DeckB_ShowLoopSizeTouchTimer.output",
                  "%surface%.encoder.is_turned"
                ]
              }
              to: "Top_ShowLoopSize.input"
            }
          }

          WiresGroup
          {
            enabled: encoderMode.value == encoderSlicerMode

            Wire
            {
              from: Or
              {
                inputs:
                [
                  "%surface%.encoder.touch",
                  "%surface%.encoder.is_turned"
                ]
              }
              to: "ShowSliceOverlay"
            }

            Wire { from: "%surface%.encoder.touch";  to: ButtonScriptAdapter  { onPress: { deckBExitFreeze = false; } } }
            Wire { from: "%surface%.loop.led"; to: "loop_encoder_blinker_blue" }

            Wire { from: "%surface%.encoder.turn"; to: "decks.2.freeze_slicer.slice_size"; enabled: !deckBLoopActive.value }
            Wire { from: "%surface%.encoder.turn"; to: "decks.2.loop.autoloop";          enabled:  deckBLoopActive.value }
          }
        }

        // Remix pages scrolling
        WiresGroup
        {
          enabled: (deckBType == DeckType.Remix) && (encoderMode.value == encoderRemixMode)

          Wire { from: "%surface%.encoder";         to: "decks.2.remix.page" }
          Wire { from: "%surface%.encoder";         to: "ShowDisplayButtonArea_EncoderAdapter"; enabled: !deckFocus }
          Wire { from: "loop_encoder_blinker_blue"; to: "%surface%.loop.led" }
        }

        // Remix capture source
        WiresGroup
        {
          enabled:  encoderMode.value == encoderCaptureMode

          Wire { from: "%surface%.encoder.turn"; to: "decks.2.remix.capture_source" }
          Wire { from: "loop_encoder_blinker_blue"; to: "%surface%.loop.led" }
        }

        // Stem filter control
        WiresGroup
        {
          enabled: encoderMode.value == encoderStemMode && screenOverlay.value == Overlay.none && screenViewProp.value == ScreenView.deck
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.2.stems.1.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode1.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.2.stems.2.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode2.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.2.stems.3.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode3.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.2.stems.4.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode4.value  }

          WiresGroup
          {
            enabled: stemSelectorMode1.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.2.reset_stems.1.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.2.reset_stems.1.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.2.stems.1.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode2.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.2.reset_stems.2.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.2.reset_stems.2.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.2.stems.2.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode3.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.2.reset_stems.3.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.2.reset_stems.3.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.2.stems.3.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode4.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.2.reset_stems.4.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.2.reset_stems.4.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.2.stems.4.filter_on" } enabled: !module.shift }
          }
        }
      }

      // Deck D
      SwitchTimer { name: "DeckD_ShowLoopSizeTouchTimer"; setTimeout: 500 }

      WiresGroup
      {
        enabled: (encoderFocusedDeckId == 4)

        // Loop and Freeze modes
        WiresGroup
        {
          enabled: hasLoopMode(deckDType)

          WiresGroup
          {
            enabled: encoderMode.value == encoderLoopMode

            Wire { from: "%surface%.encoder";       to: "decks.4.loop.autoloop";     enabled: !module.shift }
            Wire { from: "%surface%.encoder";       to: "decks.4.loop.move";         enabled:  module.shift }
            Wire { from: "decks.4.loop.active";      to: "%surface%.loop.led";                              }
            Wire { from: "%surface%.encoder.touch"; to: "DeckD_ShowLoopSizeTouchTimer.input"                 }

            Wire
            {
              enabled: !module.shift
              from: Or
              {
                inputs:
                [
                  "DeckD_ShowLoopSizeTouchTimer.output",
                  "%surface%.encoder.is_turned"
                ]
              }
              to: "Bottom_ShowLoopSize.input"
            }
          }

          WiresGroup
          {
            enabled: encoderMode.value == encoderSlicerMode

            Wire
            {
              from: Or
              {
                inputs:
                [
                  "%surface%.encoder.touch",
                  "%surface%.encoder.is_turned"
                ]
              }
              to: "ShowSliceOverlay"
            }

            Wire { from: "%surface%.encoder.touch";  to: ButtonScriptAdapter  { onPress: { deckDExitFreeze = false; } } }
            Wire { from: "%surface%.loop.led"; to: "loop_encoder_blinker_white" }

            Wire { from: "%surface%.encoder.turn"; to: "decks.4.freeze_slicer.slice_size"; enabled: !deckDLoopActive.value }
            Wire { from: "%surface%.encoder.turn"; to: "decks.4.loop.autoloop";          enabled:  deckDLoopActive.value }
          }
        }

        // Remix pages scrolling
        WiresGroup
        {
          enabled:  (deckDType == DeckType.Remix) && (encoderMode.value == encoderRemixMode)

          Wire { from: "%surface%.encoder";         to: "decks.4.remix.page" }
          Wire { from: "%surface%.encoder";        to: "ShowDisplayButtonArea_EncoderAdapter"; enabled: deckFocus }
          Wire { from: "loop_encoder_blinker_white"; to: "%surface%.loop.led" }
        }

        // Remix capture source
        WiresGroup
        {
          enabled: encoderMode.value == encoderCaptureMode

          Wire { from: "%surface%.encoder.turn";   to: "decks.4.remix.capture_source" }
          Wire { from: "loop_encoder_blinker_white"; to: "%surface%.loop.led" }
        }

        // Stem filter control
        WiresGroup
        {
          enabled: encoderMode.value == encoderStemMode && screenOverlay.value == Overlay.none && screenViewProp.value == ScreenView.deck
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.4.stems.1.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode1.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.4.stems.2.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode2.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.4.stems.3.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode3.value  }
          Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks.4.stems.4.filter_value"; step: encoderStepsizeStemControl; mode: RelativeMode.Stepped } enabled: stemSelectorMode4.value  }
          
          WiresGroup
          {
            enabled: stemSelectorMode1.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.4.reset_stems.1.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.4.reset_stems.1.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.4.stems.1.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode2.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.4.reset_stems.2.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.4.reset_stems.2.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.4.stems.2.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode3.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.4.reset_stems.3.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.4.reset_stems.3.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.4.stems.3.filter_on" } enabled: !module.shift }
          }

          WiresGroup
          {
            enabled: stemSelectorMode4.value

            WiresGroup
            {
              enabled: module.shift

              Wire { from: "%surface%.encoder.push"; to: "decks.4.reset_stems.4.filter" }
              Wire { from: "%surface%.encoder.push"; to: "decks.4.reset_stems.4.filter_on" }
            }

            Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks.4.stems.4.filter_on" } enabled: !module.shift }
          }
        }
      }

      //------------------------------------------------------------------------------------------------------------------
      //  BEATGRID EDIT
      //------------------------------------------------------------------------------------------------------------------

      MappingPropertyDescriptor { path: propertiesPath + ".beatgrid.scan_control";      type: MappingPropertyDescriptor.Float;   value: 0.0   }
      MappingPropertyDescriptor { path: propertiesPath + ".beatgrid.scan_beats_offset"; type: MappingPropertyDescriptor.Integer; value: 0     }
      MappingPropertyDescriptor { id: zoomedEditView; path: propertiesPath + ".beatgrid.zoomed_view";       type: MappingPropertyDescriptor.Boolean; value: false }

      Beatgrid { name: "DeckA_Beatgrid"; channel: 1 }
      Beatgrid { name: "DeckB_Beatgrid"; channel: 2 }
      Beatgrid { name: "DeckC_Beatgrid"; channel: 3 }
      Beatgrid { name: "DeckD_Beatgrid"; channel: 4 }
      
      WiresGroup
      {
        enabled: isInEditMode
        
        Wire { from: "%surface%.encoder";   to: DirectPropertyAdapter { path: propertiesPath + ".beatgrid.scan_control" }   enabled: selectedFooterItem.value == 4  }
        Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: propertiesPath + ".beatgrid.zoomed_view" }  }
      }

      // Deck A
      WiresGroup
      {
        enabled: (focusedDeckId == 1) && isInEditMode && hasEditMode(deckAType) && !module.shift

        Wire { from: "%surface%.display.buttons.2"; to: "DeckA_Beatgrid.lock"  }
        Wire { from: "%surface%.display.buttons.3"; to: "DeckA_Beatgrid.tick"  }
        Wire { from: "%surface%.display.buttons.6"; to: "DeckA_Beatgrid.tap"   }
        Wire { from: "%surface%.display.buttons.7"; to: "DeckA_Beatgrid.reset" }

        Wire{ from: DirectPropertyAdapter{path: propertiesPath + ".beatgrid.scan_beats_offset"; input:false} to: "DeckA_Beatgrid.beats_offset"}
        
        WiresGroup
        {
          enabled: !zoomedEditView.value && selectedFooterItem.value == 1

          Wire { from: "%surface%.encoder"; to: "DeckA_Beatgrid.offset_fine";   enabled: !module.shift }
          Wire { from: "%surface%.encoder"; to: "DeckA_Beatgrid.offset_coarse"; enabled:  module.shift }
        }

        WiresGroup
        {
          enabled: zoomedEditView.value && selectedFooterItem.value == 1

          Wire { from: "%surface%.encoder"; to: "DeckA_Beatgrid.offset_ultrafine";   enabled: !module.shift }
          Wire { from: "%surface%.encoder"; to: "DeckA_Beatgrid.offset_fine";        enabled:  module.shift }
        }

        Wire { from: "%surface%.encoder"; to: "DeckA_Beatgrid.bpm_coarse"; enabled: selectedFooterItem.value == 2    }
        Wire { from: "%surface%.encoder"; to: "DeckA_Beatgrid.bpm_fine";   enabled: selectedFooterItem.value == 3    }
      }

      // Deck B
      WiresGroup
      {
        enabled: (focusedDeckId == 2) && isInEditMode && hasEditMode(deckBType)

        Wire { from: "%surface%.display.buttons.2"; to: "DeckB_Beatgrid.lock"  }
        Wire { from: "%surface%.display.buttons.3"; to: "DeckB_Beatgrid.tick"  }
        Wire { from: "%surface%.display.buttons.6"; to: "DeckB_Beatgrid.tap"   }
        Wire { from: "%surface%.display.buttons.7"; to: "DeckB_Beatgrid.reset" }

        Wire{ from: DirectPropertyAdapter{path: propertiesPath + ".beatgrid.scan_beats_offset"; input:false} to: "DeckB_Beatgrid.beats_offset"}
        
        WiresGroup
        {
          enabled: !zoomedEditView.value && selectedFooterItem.value == 1

          Wire { from: "%surface%.encoder"; to: "DeckB_Beatgrid.offset_fine";   enabled: !module.shift }
          Wire { from: "%surface%.encoder"; to: "DeckB_Beatgrid.offset_coarse"; enabled:  module.shift }
        }

        WiresGroup
        {
          enabled: zoomedEditView.value && selectedFooterItem.value == 1

          Wire { from: "%surface%.encoder"; to: "DeckB_Beatgrid.offset_ultrafine";   enabled: !module.shift }
          Wire { from: "%surface%.encoder"; to: "DeckB_Beatgrid.offset_fine";        enabled:  module.shift }
        }

        Wire { from: "%surface%.encoder"; to: "DeckB_Beatgrid.bpm_coarse"; enabled: selectedFooterItem.value == 2    }
        Wire { from: "%surface%.encoder"; to: "DeckB_Beatgrid.bpm_fine";   enabled: selectedFooterItem.value == 3    }
      }

      // Deck C
      WiresGroup
      {
        enabled: (focusedDeckId == 3) && isInEditMode && hasEditMode(deckCType)

        Wire { from: "%surface%.display.buttons.2"; to: "DeckC_Beatgrid.lock"  }
        Wire { from: "%surface%.display.buttons.3"; to: "DeckC_Beatgrid.tick"  }
        Wire { from: "%surface%.display.buttons.6"; to: "DeckC_Beatgrid.tap"   }
        Wire { from: "%surface%.display.buttons.7"; to: "DeckC_Beatgrid.reset" }

        Wire{ from: DirectPropertyAdapter{path: propertiesPath + ".beatgrid.scan_beats_offset"; input:false} to: "DeckC_Beatgrid.beats_offset"}
        
        WiresGroup
        {
          enabled: !zoomedEditView.value && selectedFooterItem.value == 1

          Wire { from: "%surface%.encoder"; to: "DeckC_Beatgrid.offset_fine";   enabled: !module.shift }
          Wire { from: "%surface%.encoder"; to: "DeckC_Beatgrid.offset_coarse"; enabled:  module.shift }
        }

        WiresGroup
        {
          enabled: zoomedEditView.value && selectedFooterItem.value == 1

          Wire { from: "%surface%.encoder"; to: "DeckC_Beatgrid.offset_ultrafine";   enabled: !module.shift }
          Wire { from: "%surface%.encoder"; to: "DeckC_Beatgrid.offset_fine";        enabled:  module.shift }
        }

        Wire { from: "%surface%.encoder"; to: "DeckC_Beatgrid.bpm_coarse"; enabled: selectedFooterItem.value == 2    }
        Wire { from: "%surface%.encoder"; to: "DeckC_Beatgrid.bpm_fine";   enabled: selectedFooterItem.value == 3    }
      }

      // Deck D
      WiresGroup
      {
        enabled: (focusedDeckId == 4) && isInEditMode && hasEditMode(deckDType)

        Wire { from: "%surface%.display.buttons.2"; to: "DeckD_Beatgrid.lock"  }
        Wire { from: "%surface%.display.buttons.3"; to: "DeckD_Beatgrid.tick"  }
        Wire { from: "%surface%.display.buttons.6"; to: "DeckD_Beatgrid.tap"   }
        Wire { from: "%surface%.display.buttons.7"; to: "DeckD_Beatgrid.reset" }

        Wire{ from: DirectPropertyAdapter{path: propertiesPath + ".beatgrid.scan_beats_offset"; input:false} to: "DeckD_Beatgrid.beats_offset"}
        
        WiresGroup
        {
          enabled: !zoomedEditView.value && selectedFooterItem.value == 1

          Wire { from: "%surface%.encoder"; to: "DeckD_Beatgrid.offset_fine";   enabled: !module.shift }
          Wire { from: "%surface%.encoder"; to: "DeckD_Beatgrid.offset_coarse"; enabled:  module.shift }
        }

        WiresGroup
        {
          enabled: zoomedEditView.value && selectedFooterItem.value == 1

          Wire { from: "%surface%.encoder"; to: "DeckD_Beatgrid.offset_ultrafine";   enabled: !module.shift }
          Wire { from: "%surface%.encoder"; to: "DeckD_Beatgrid.offset_fine";        enabled:  module.shift }
        }

        Wire { from: "%surface%.encoder"; to: "DeckD_Beatgrid.bpm_coarse"; enabled: selectedFooterItem.value == 2    }
        Wire { from: "%surface%.encoder"; to: "DeckD_Beatgrid.bpm_fine";   enabled: selectedFooterItem.value == 3    }
      }


  //------------------------------------------------------------------------------------------------------------------
  //  Show header/footer on touch
  //------------------------------------------------------------------------------------------------------------------

  SwitchTimer { name: "TopInfoOverlay";     resetTimeout: 1000 }
  SwitchTimer { name: "BottomInfoOverlay";  resetTimeout: 1000 }

  WiresGroup
  {
    enabled: showFxOnTouch.value && (screenOverlay.value != Overlay.fx)

    Wire {
      from:
      Or {
        inputs:
        [
          "%surface%.fx.knobs.1.touch",
          "%surface%.fx.knobs.2.touch",
          "%surface%.fx.knobs.3.touch",
          "%surface%.fx.knobs.4.touch"
        ]
      } 
      to: "TopInfoOverlay.input"
    }

    Wire { from: "TopInfoOverlay.output"; to: DirectPropertyAdapter{ path: propertiesPath + ".top_info_show" } }
  }

  // stem selector
  WiresGroup
  {
    enabled: encoderMode.value == encoderStemMode;
    Wire { from: DirectPropertyAdapter{ path: propertiesPath + ".stem_selector_mode.any" } to: "BottomInfoOverlay.input.boolean_value" }     
    Wire { from: "BottomInfoOverlay.output"; to: DirectPropertyAdapter{ path: propertiesPath + ".bottom_info_show" } }
  }

  //------------------------------------------------------------------------------------------------------------------  
  //  Zoom / Sample page / StemDeckStyle
  //------------------------------------------------------------------------------------------------------------------

  WiresGroup
  {
    enabled: (module.screenView.value == ScreenView.deck) && !isInEditMode

    // Deck A
    WiresGroup
    {
      enabled: focusedDeckId == 1

      // Waveform zoom
      WiresGroup
      {
        enabled: hasWaveform(deckAType) && !module.shift

        Wire { from: "%surface%.display.buttons.6"; to: RelativePropertyAdapter { path: settingsPath + ".top.waveform_zoom"; mode: RelativeMode.Decrement } }
        Wire { from: "%surface%.display.buttons.7"; to: RelativePropertyAdapter { path: settingsPath + ".top.waveform_zoom"; mode: RelativeMode.Increment } }
      }

      // Remix page scroll
      WiresGroup
      {
        enabled: (deckAType == DeckType.Remix)

        Wire { from: "%surface%.display.buttons.6"; to: "decks.1.remix.decrement_page" }
        Wire { from: "%surface%.display.buttons.7"; to: "decks.1.remix.increment_page" }
      }

      //Stem Style selection
      WiresGroup
      {
        enabled: (deckAType == DeckType.Stem) && module.shift

        Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: propertiesPath + ".top.stem_deck_style";  value: StemStyle.track } }
        Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: propertiesPath + ".top.stem_deck_style";  value: StemStyle.daw   } }
      }
    }

    // Deck B
    WiresGroup
    {
      enabled: focusedDeckId == 2

      // Waveform zoom
      WiresGroup
      {
        enabled: hasWaveform(deckBType) && !module.shift

        Wire { from: "%surface%.display.buttons.6"; to: RelativePropertyAdapter { path: settingsPath + ".top.waveform_zoom"; mode: RelativeMode.Decrement } }
        Wire { from: "%surface%.display.buttons.7"; to: RelativePropertyAdapter { path: settingsPath + ".top.waveform_zoom"; mode: RelativeMode.Increment } }
      }

      // Remix page scroll
      WiresGroup
      {
        enabled: (deckBType == DeckType.Remix)

        Wire { from: "%surface%.display.buttons.6"; to: "decks.2.remix.decrement_page" }
        Wire { from: "%surface%.display.buttons.7"; to: "decks.2.remix.increment_page" }
      }

      //Stem Style selection
      WiresGroup
      {
        enabled: (deckBType == DeckType.Stem) && module.shift

        Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: propertiesPath + ".top.stem_deck_style";  value: StemStyle.track } }
        Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: propertiesPath + ".top.stem_deck_style";  value: StemStyle.daw   } }
      }
    }

    // Deck C
    WiresGroup
    {
      enabled: focusedDeckId == 3

      // Waveform zoom
      WiresGroup
      {
        enabled: hasWaveform(deckCType) && !module.shift

        Wire { from: "%surface%.display.buttons.6"; to: RelativePropertyAdapter { path: settingsPath + ".bottom.waveform_zoom"; mode: RelativeMode.Decrement } }
        Wire { from: "%surface%.display.buttons.7"; to: RelativePropertyAdapter { path: settingsPath + ".bottom.waveform_zoom"; mode: RelativeMode.Increment } }
      }

      // Remix page scroll
      WiresGroup
      {
        enabled: (deckCType == DeckType.Remix)

        Wire { from: "%surface%.display.buttons.6"; to: "decks.3.remix.decrement_page" }
        Wire { from: "%surface%.display.buttons.7"; to: "decks.3.remix.increment_page" }
      }
      //Stem Style selection
      WiresGroup
      {
        enabled: (deckCType == DeckType.Stem) && module.shift

        Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: propertiesPath + ".bottom.stem_deck_style";  value: StemStyle.track } }
        Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: propertiesPath + ".bottom.stem_deck_style";  value: StemStyle.daw   } }
      }
    }

    // Deck D
    WiresGroup
    {
      enabled: focusedDeckId == 4

      // Waveform zoom
      WiresGroup
      {
        enabled: hasWaveform(deckDType) && !module.shift

        Wire { from: "%surface%.display.buttons.6"; to: RelativePropertyAdapter { path: settingsPath + ".bottom.waveform_zoom"; mode: RelativeMode.Decrement } }
        Wire { from: "%surface%.display.buttons.7"; to: RelativePropertyAdapter { path: settingsPath + ".bottom.waveform_zoom"; mode: RelativeMode.Increment } }
      }

      // Remix page scroll
      WiresGroup
      {
        enabled: (deckDType == DeckType.Remix)

        Wire { from: "%surface%.display.buttons.6"; to: "decks.4.remix.decrement_page" }
        Wire { from: "%surface%.display.buttons.7"; to: "decks.4.remix.increment_page" }
      }

      //Stem Style selection
      WiresGroup
      {
        enabled: (deckDType == DeckType.Stem) && module.shift

        Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: propertiesPath + ".bottom.stem_deck_style";  value: StemStyle.track } }
        Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: propertiesPath + ".bottom.stem_deck_style";  value: StemStyle.daw   } }
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------
  //  TRANSPORT SECTION
  //------------------------------------------------------------------------------------------------------------------

  // Settings forwarding
  Group
  {
    name: "touchstrip_settings"

    DirectPropertyAdapter { name: "bend_bensitivity";    path: "mapping.settings.touchstrip_bend_sensitivity";        input: false    }
    DirectPropertyAdapter { name: "bend_invert";         path: "mapping.settings.touchstrip_bend_invert";             input: false    }
    DirectPropertyAdapter { name: "scratch_sensitivity"; path: "mapping.settings.touchstrip_scratch_sensitivity";     input: false    }
    DirectPropertyAdapter { name: "scratch_invert";      path: "mapping.settings.touchstrip_scratch_invert";          input: false    }
  }

  // Deck A
  Wire { from: "touchstrip_settings.bend_bensitivity";     to: "decks.1.tempo_bend.sensitivity" }
  Wire { from: "touchstrip_settings.bend_invert";          to: "decks.1.tempo_bend.invert"      }
  Wire { from: "touchstrip_settings.scratch_sensitivity";  to: "decks.1.scratch.sensitivity"    }
  Wire { from: "touchstrip_settings.scratch_invert";       to: "decks.1.scratch.invert"         }

  WiresGroup
  {
    id: transportA

    enabled: (focusedDeckId == 1) && (hasTransport(deckAType))

    Wire { from: "%surface%.flux"; to: "decks.1.transport.flux" }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.play"; to: "decks.1.transport.play" }
      Wire { from: "%surface%.cue";  to: "decks.1.transport.cue"  }
      Wire { from: "%surface%.sync"; to: "decks.1.transport.sync"; enabled: (editMode.value != editModeArmed) && (editMode.value != editModeUsed) }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.play"; to: "decks.1.transport.timecode"     }
      Wire { from: "%surface%.cue";  to: "decks.1.transport.return_to_zero" }
      Wire { from: "%surface%.sync"; to: "decks.1.transport.master"; enabled: (editMode.value != editModeArmed) && (editMode.value != editModeUsed) }
    }

    WiresGroup
    {
      enabled: module.shift && hasSeek(deckAType) && !(deckARunning.value  && scratchWithTouchstrip.value)

      Wire { from: "%surface%.touchstrip";        to: "decks.1.track_seek"      }
      Wire { from: "%surface%.touchstrip.leds";   to: "decks.1.track_seek.leds" }
    }

    WiresGroup
    {
      enabled: (!deckARunning.value && !(module.shift && hasSeek(deckAType)))
               || (deckARunning.value && module.shift && (!hasSeek(deckAType) || scratchWithTouchstrip.value))

      Wire { from: "%surface%.touchstrip";        to: "decks.1.scratch"        }
      Wire { from: "%surface%.touchstrip.leds";   to: "decks.1.scratch.leds"   }
    }

    WiresGroup
    {
      enabled: deckARunning.value && !module.shift

      Wire { from: "%surface%.touchstrip";        to: "decks.1.tempo_bend"      }
      Wire { from: "%surface%.touchstrip.leds";   to: "decks.1.tempo_bend.leds" }
    }
  }

  // Deck B
  Wire { from: "touchstrip_settings.bend_bensitivity";     to: "decks.2.tempo_bend.sensitivity" }
  Wire { from: "touchstrip_settings.bend_invert";          to: "decks.2.tempo_bend.invert"      }
  Wire { from: "touchstrip_settings.scratch_sensitivity";  to: "decks.2.scratch.sensitivity"    }
  Wire { from: "touchstrip_settings.scratch_invert";       to: "decks.2.scratch.invert"         }

  WiresGroup
  {
    id: transportB

    enabled: (focusedDeckId == 2) && (hasTransport(deckBType))

    Wire { from: "%surface%.flux";  to: "decks.2.transport.flux" }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.play"; to: "decks.2.transport.play" }
      Wire { from: "%surface%.cue";  to: "decks.2.transport.cue"  }
      Wire { from: "%surface%.sync"; to: "decks.2.transport.sync"; enabled: (editMode.value != editModeArmed) && (editMode.value != editModeUsed) }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.play"; to: "decks.2.transport.timecode"     }
      Wire { from: "%surface%.cue";  to: "decks.2.transport.return_to_zero" }
      Wire { from: "%surface%.sync"; to: "decks.2.transport.master"; enabled: (editMode.value != editModeArmed) && (editMode.value != editModeUsed) }
    }

    WiresGroup
    {
      enabled: module.shift && hasSeek(deckBType) && !(deckBRunning.value  && scratchWithTouchstrip.value)

      Wire { from: "%surface%.touchstrip";       to: "decks.2.track_seek"      }
      Wire { from: "%surface%.touchstrip.leds";  to: "decks.2.track_seek.leds" }
    }

    WiresGroup
    {
      enabled: (!deckBRunning.value && !(module.shift && hasSeek(deckBType)))
               || (deckBRunning.value && module.shift && (!hasSeek(deckBType) || scratchWithTouchstrip.value))

      Wire { from: "%surface%.touchstrip";       to: "decks.2.scratch"        }
      Wire { from: "%surface%.touchstrip.leds";  to: "decks.2.scratch.leds"   }
    }

    WiresGroup
    {
      enabled: deckBRunning.value && !module.shift

      Wire { from: "%surface%.touchstrip";       to: "decks.2.tempo_bend"      }
      Wire { from: "%surface%.touchstrip.leds";  to: "decks.2.tempo_bend.leds" }
    }
  }

  // Deck C
  Wire { from: "touchstrip_settings.bend_bensitivity";     to: "decks.3.tempo_bend.sensitivity" }
  Wire { from: "touchstrip_settings.bend_invert";          to: "decks.3.tempo_bend.invert"      }
  Wire { from: "touchstrip_settings.scratch_sensitivity";  to: "decks.3.scratch.sensitivity"    }
  Wire { from: "touchstrip_settings.scratch_invert";       to: "decks.3.scratch.invert"         }

  WiresGroup
  {
    id: transportC

    enabled: (focusedDeckId == 3) && (hasTransport(deckCType))

    Wire { from: "%surface%.flux";  to: "decks.3.transport.flux" }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.play"; to: "decks.3.transport.play" }
      Wire { from: "%surface%.cue";  to: "decks.3.transport.cue"  }
      Wire { from: "%surface%.sync"; to: "decks.3.transport.sync"; enabled: (editMode.value != editModeArmed) && (editMode.value != editModeUsed) }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.play"; to: "decks.3.transport.timecode"     }
      Wire { from: "%surface%.cue";  to: "decks.3.transport.return_to_zero" }
      Wire { from: "%surface%.sync"; to: "decks.3.transport.master"; enabled: (editMode.value != editModeArmed) && (editMode.value != editModeUsed) }
    }

    WiresGroup
    {
      enabled: module.shift && hasSeek(deckCType) && !(deckCRunning.value  && scratchWithTouchstrip.value)

      Wire { from: "%surface%.touchstrip";        to: "decks.3.track_seek"       }
      Wire { from: "%surface%.touchstrip.leds";   to: "decks.3.track_seek.leds"  }
    }

    WiresGroup
    {
      enabled: (!deckCRunning.value && !(module.shift && hasSeek(deckCType)))
               || (deckCRunning.value && module.shift && (!hasSeek(deckCType) || scratchWithTouchstrip.value))

      Wire { from: "%surface%.touchstrip";        to: "decks.3.scratch"         }
      Wire { from: "%surface%.touchstrip.leds";   to: "decks.3.scratch.leds"    }
    }

    WiresGroup
    {
      enabled: deckCRunning.value && !module.shift

      Wire { from: "%surface%.touchstrip";        to: "decks.3.tempo_bend"       }
      Wire { from: "%surface%.touchstrip.leds";   to: "decks.3.tempo_bend.leds"  }
    }
  }

  // Deck D
  Wire { from: "touchstrip_settings.bend_bensitivity";     to: "decks.4.tempo_bend.sensitivity" }
  Wire { from: "touchstrip_settings.bend_invert";          to: "decks.4.tempo_bend.invert"      }
  Wire { from: "touchstrip_settings.scratch_sensitivity";  to: "decks.4.scratch.sensitivity"    }
  Wire { from: "touchstrip_settings.scratch_invert";       to: "decks.4.scratch.invert"         }

  WiresGroup
  {
    id: transportD

    enabled: (focusedDeckId == 4) && (hasTransport(deckDType))

    Wire { from: "%surface%.flux";  to: "decks.4.transport.flux" }

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.play"; to: "decks.4.transport.play" }
      Wire { from: "%surface%.cue";  to: "decks.4.transport.cue"  }
      Wire { from: "%surface%.sync"; to: "decks.4.transport.sync"; enabled: (editMode.value != editModeArmed) && (editMode.value != editModeUsed) }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.play"; to: "decks.4.transport.timecode"     }
      Wire { from: "%surface%.cue";  to: "decks.4.transport.return_to_zero" }
      Wire { from: "%surface%.sync"; to: "decks.4.transport.master"; enabled: (editMode.value != editModeArmed) && (editMode.value != editModeUsed) }
    }

    WiresGroup
    {
      enabled: module.shift && hasSeek(deckDType) && !(deckDRunning.value  && scratchWithTouchstrip.value)

      Wire { from: "%surface%.touchstrip";       to: "decks.4.track_seek"       }
      Wire { from: "%surface%.touchstrip.leds";  to: "decks.4.track_seek.leds"  }
    }

    WiresGroup
    {
      enabled: (!deckDRunning.value && !(module.shift && hasSeek(deckDType)))
               || (deckDRunning.value && module.shift && (!hasSeek(deckDType) || scratchWithTouchstrip.value))

      Wire { from: "%surface%.touchstrip";       to: "decks.4.scratch"         }
      Wire { from: "%surface%.touchstrip.leds";  to: "decks.4.scratch.leds"    }
    }

    WiresGroup
    {
      enabled: deckDRunning.value && !module.shift

      Wire { from: "%surface%.touchstrip";       to: "decks.4.tempo_bend"       }
      Wire { from: "%surface%.touchstrip.leds";  to: "decks.4.tempo_bend.leds"  }
    }
  }

  //------------------------------------------------------------------------------------------------------------------

  WiresGroup
  {
    enabled:  (decksAssignment == DecksAssignment.AC)

    Wire { from: "decks.1.remix.page"; to: "screen.upper_remix_deck_page" }
    Wire { from: "decks.3.remix.page"; to: "screen.lower_remix_deck_page" }
  }

  WiresGroup
  {
    enabled: (decksAssignment == DecksAssignment.BD)

    Wire { from: "decks.2.remix.page"; to: "screen.upper_remix_deck_page" }
    Wire { from: "decks.4.remix.page"; to: "screen.lower_remix_deck_page" }
  }

  //------------------------------------------------------------------------------------------------------------------
  //  COPY PHASE FROM MASTER
  //------------------------------------------------------------------------------------------------------------------

  CopyMasterPhase { name: "DeckA_CopyMasterPhase";  channel: 1 }
  SwitchTimer { name: "DeckA_CopyMasterPhase_Switch"; setTimeout: 1000 }

  CopyMasterPhase { name: "DeckB_CopyMasterPhase";  channel: 2 }
  SwitchTimer { name: "DeckB_CopyMasterPhase_Switch"; setTimeout: 1000 }

  CopyMasterPhase { name: "DeckC_CopyMasterPhase";  channel: 3 }
  SwitchTimer { name: "DeckC_CopyMasterPhase_Switch"; setTimeout: 1000 }

  CopyMasterPhase { name: "DeckD_CopyMasterPhase";  channel: 4 }
  SwitchTimer { name: "DeckD_CopyMasterPhase_Switch"; setTimeout: 1000 }
  
  Blinker { name: "CopyMasterPhase_Blinker"; cycle: 300; repetitions: 3; defaultBrightness: onBrightness; blinkBrightness: dimmedBrightness; color: Color.Green }

  WiresGroup
  {
    enabled: (editMode.value == editModeArmed) || (editMode.value == editModeUsed)

    Wire { from: "%surface%.sync.led"; to: "CopyMasterPhase_Blinker" }
    Wire { from: "%surface%.sync.value"; to: ButtonScriptAdapter { onPress: onSyncPressed(); } }

    // Deck A
    WiresGroup
    {
      enabled: (focusedDeckId == 1) && hasEditMode(deckAType)

      Wire { from: "%surface%.sync"; to: "DeckA_CopyMasterPhase_Switch.input" }
      Wire { from: "DeckA_CopyMasterPhase_Switch.output"; to: "DeckA_CopyMasterPhase" }
      Wire { from: "DeckA_CopyMasterPhase_Switch.output"; to: "CopyMasterPhase_Blinker.trigger" }
    }

    // Deck B
    WiresGroup
    {
      enabled: (focusedDeckId == 2) && hasEditMode(deckBType)

      Wire { from: "%surface%.sync"; to: "DeckB_CopyMasterPhase_Switch.input" }
      Wire { from: "DeckB_CopyMasterPhase_Switch.output"; to: "DeckB_CopyMasterPhase" }
      Wire { from: "DeckB_CopyMasterPhase_Switch.output"; to: "CopyMasterPhase_Blinker.trigger" }
    }

    // Deck C
    WiresGroup
    {
      enabled: (focusedDeckId == 3) && hasEditMode(deckCType)

      Wire { from: "%surface%.sync"; to: "DeckC_CopyMasterPhase_Switch.input" }
      Wire { from: "DeckC_CopyMasterPhase_Switch.output"; to: "DeckC_CopyMasterPhase" }
      Wire { from: "DeckC_CopyMasterPhase_Switch.output"; to: "CopyMasterPhase_Blinker.trigger" }
    }

    // Deck D
    WiresGroup
    {
      enabled: (focusedDeckId == 4) && hasEditMode(deckDType)

      Wire { from: "%surface%.sync"; to: "DeckD_CopyMasterPhase_Switch.input" }
      Wire { from: "DeckD_CopyMasterPhase_Switch.output"; to: "DeckD_CopyMasterPhase" }
      Wire { from: "DeckD_CopyMasterPhase_Switch.output"; to: "CopyMasterPhase_Blinker.trigger" }
    }
  }

  //------------------------------------------------------------------------------------------------------------------
  //  EFFECT UNITS
  //------------------------------------------------------------------------------------------------------------------

  Group
  {
    name: "fx_units"

    FxUnit { name: "1"; channel: 1 }
    FxUnit { name: "2"; channel: 2 }
    FxUnit { name: "3"; channel: 3 }
    FxUnit { name: "4"; channel: 4 }
  }

  WiresGroup
  {
    enabled: module.screenView.value == ScreenView.deck

    Wire
    {
      enabled: screenOverlay.value != Overlay.fx
      from: "softtakeover_knobs_timer.output"
      to: DirectPropertyAdapter { path: propertiesPath + ".softtakeover.show_knobs"; output: false }
    }

    // Effect Unit 1
    WiresGroup
    {
      enabled: decksAssignment == DecksAssignment.AC

      WiresGroup
      {
        enabled: screenOverlay.value != Overlay.fx && !module.shift

        Wire { from: "%surface%.fx.buttons.1";   to: "fx_units.1.enabled" }
        Wire { from: "%surface%.fx.buttons.2";   to: "fx_units.1.button1" }
        Wire { from: "%surface%.fx.buttons.3";   to: "fx_units.1.button2" }
        Wire { from: "%surface%.fx.buttons.4";   to: "fx_units.1.button3" }
      }

      Wire { from: "softtakeover_knobs1.module.output"; to: "fx_units.1.dry_wet" }
      Wire { from: "softtakeover_knobs2.module.output"; to: "fx_units.1.knob1"   }
      Wire { from: "softtakeover_knobs3.module.output"; to: "fx_units.1.knob2"   }
      Wire { from: "softtakeover_knobs4.module.output"; to: "fx_units.1.knob3"   }
    }

    // Effect Unit 2
    WiresGroup
    {
      enabled: decksAssignment == DecksAssignment.BD

      WiresGroup
      {
        enabled: screenOverlay.value != Overlay.fx && !module.shift

        Wire { from: "%surface%.fx.buttons.1";   to: "fx_units.2.enabled" }
        Wire { from: "%surface%.fx.buttons.2";   to: "fx_units.2.button1" }
        Wire { from: "%surface%.fx.buttons.3";   to: "fx_units.2.button2" }
        Wire { from: "%surface%.fx.buttons.4";   to: "fx_units.2.button3" }
      }

      Wire { from: "softtakeover_knobs1.module.output"; to: "fx_units.2.dry_wet" }
      Wire { from: "softtakeover_knobs2.module.output"; to: "fx_units.2.knob1"   }
      Wire { from: "softtakeover_knobs3.module.output"; to: "fx_units.2.knob2"   }
      Wire { from: "softtakeover_knobs4.module.output"; to: "fx_units.2.knob3"   }
    }
  }

  
}
