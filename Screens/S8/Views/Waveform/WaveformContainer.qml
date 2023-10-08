import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as T

import '../../../../Defines'
import '../Widgets' as Widgets


Item {
  id: view
  property int    deckId:        0
  property string deckSizeState: "large"
  property int    sampleWidth:   0
  property bool   showLoopSize: false
  property bool   isInEditMode: false
  property string propertiesPath: ""

  readonly property bool trackIsLoaded: (primaryKey.value > 0)


  property          int    stemStyle:       StemStyle.track
  readonly property bool   isStemDeck: (deckType.value == DeckType.Stem && stemStyle == StemStyle.daw && deckSizeState == "large")

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty     { id: primaryKey;        path: "app.traktor.decks."   + (deckId + 1) + ".track.content.entry_key"  }
  AppProperty     { id: sampleRate;        path: "app.traktor.decks."   + (deckId + 1) + ".track.content.sample_rate"; onValueChanged: { updateLooping(); } }
  AppProperty     { id: propFluxState;     path: "app.traktor.decks."   + (deckId + 1) + ".flux.state"                 }
  AppProperty     { id: propFluxPosition;  path: "app.traktor.decks."   + (deckId + 1) + ".track.player.flux_position" }
  
  // If the playhead is in a loop, propIsLooping is TRUE and the loop becomes the active cue.
  AppProperty   { id: propIsLooping;     path: "app.traktor.decks." + (deckId + 1) + ".loop.is_in_active_loop";        onValueChanged: { updateLooping(); } }
  AppProperty   { id: propLoopStart;     path: "app.traktor.decks." + (deckId + 1) + ".track.cue.active.start_pos";    onValueChanged: { updateLooping(); } }
  AppProperty   { id: propLoopLength;    path: "app.traktor.decks." + (deckId + 1) + ".track.cue.active.length";       onValueChanged: { updateLooping(); } }


  //--------------------------------------------------------------------------------------------------------------------
  // WAVEFORM Position
  //------------------------------------------------------------------------------------------------------------------
  
  function slicer_zoom_width()          { return  slicer.slice_width * slicer.slice_count / slicer.zoom_factor * sampleRate.value;          }
  function slicer_pos_to_waveform_pos() { return (slicer.slice_start - (0.5 * slicer.slice_width * slicer.zoom_factor)) * sampleRate.value; }

  function updateLooping()
  {
    if (propIsLooping.value) {
      var loopStart  = propLoopStart.value  * sampleRate.value;
      var loopLength = propLoopLength.value * sampleRate.value;
      wfPosition.clampPlayheadPos(loopStart, loopLength);
    }
    else wfPosition.unclampPlayheadPos();
  }

  T.WaveformPosition {
    id: wfPosition
    deckId: view.deckId
    followsPlayhead: !slicer.enabled && !beatgrid.editEnabled
    waveformPos:     beatgrid.editEnabled ? beatgrid.posOnEdit   : (slicer.enabled ? slicer_pos_to_waveform_pos() : (playheadPos -  0.5 * view.sampleWidth ))
    sampleWidth:     beatgrid.editEnabled ? beatgrid.widthOnEdit : (slicer.enabled ? slicer_zoom_width()          : view.sampleWidth)
    viewWidth:       singleWaveform.width

    Behavior on sampleWidth { PropertyAnimation { duration: 150; easing.type: Easing.OutCubic } }
    Behavior on waveformPos { PropertyAnimation { duration: 150; easing.type: Easing.OutCubic }  enabled: (slicer.enabled || beatgrid.editEnabled) }
  }


  //--------------------------------------------------------------------------------------------------------------------
  // Single/DAW WAVEFORM
  //------------------------------------------------------------------------------------------------------------------

  SingleWaveform {
    id: singleWaveform
    deckId:        view.deckId
    sampleWidth:   view.sampleWidth

    waveformPosition: wfPosition

    anchors.top:   view.top
    anchors.left:  view.left
    anchors.right: view.right

    anchors.leftMargin:   3
    anchors.rightMargin:  3
    anchors.bottomMargin: (slicer.enabled) ? 11 : 0

    clip:    true
    visible: true        // changed in state
    height:  view.height // changed in state

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

  //------------------------------------------------------------------------------------------------------------------

  StemWaveforms {
    id: stemWaveform
    deckId:        view.deckId
    sampleWidth:   view.sampleWidth
   
    waveformPosition: wfPosition

    anchors.top:    singleWaveform.bottom
    anchors.left:   view.left
    anchors.right:  view.right
    anchors.bottom: view.bottom
    anchors.leftMargin:   3
    anchors.rightMargin:  3
    anchors.bottomMargin: (isStemDeck & slicer.enabled) ? 15 : 0
    
    visible: false // set by viewSizeState
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Beatgrid
  //--------------------------------------------------------------------------------------------------------------------

  BeatgridView {
    id: beatgrid
    anchors.fill:  parent
    anchors.leftMargin:  3
    anchors.rightMargin: 3

    waveformPosition: wfPosition
    propertiesPath:   view.propertiesPath
    trackId:          primaryKey.value
    deckId:           parent.deckId  
    visible:          (!slicer.enabled || beatgrid.editEnabled)
    editEnabled:      view.isInEditMode && (deckSizeState != "small")
    clip: true
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  CuePoints
  //--------------------------------------------------------------------------------------------------------------------

  WaveformCues {
    id: waveformCues
    anchors.fill: parent
    anchors.leftMargin:  3
    anchors.rightMargin: 3

    deckId:            view.deckId
    waveformPosition:  wfPosition
    forceHideLoop:     slicer.enabled || !trackIsLoaded
  }


  //--------------------------------------------------------------------------------------------------------------------
  // Freeze/Slicer
  //--------------------------------------------------------------------------------------------------------------------

  Slicer {
    id: slicer
    anchors.fill:      parent
    anchors.leftMargin: 3
    anchors.rightMargin: 3
    anchors.topMargin: 1
    deckId:            view.deckId
    opacity:           (beatgrid.editEnabled) ? 0 : 1

    stemStyle:         view.isStemDeck ? view.stemStyle : StemStyle.track
  }

  T.WaveformTranslator {
    Rectangle {
      id: flux_marker
      x:     0; y:      -4
      width: 3; height: view.height
      color:        colors.colorBluePlaymarker
      border.color: colors.colorBlack31
      border.width: 1
      visible:      (propFluxState.value == 2) // flux mode enabled & fluxing)
    }

    followFluxPosition: true
    relativeToPlayhead: true
    pos:                0
    followTarget:       wfPosition
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  PlayMarker
  //--------------------------------------------------------------------------------------------------------------------

  T.WaveformTranslator {
    id: play_marker
    followTarget:       wfPosition
    pos:                0
    relativeToPlayhead: true
    visible:            view.trackIsLoaded

    Rectangle {
      property int sliceModeHeight: (stemStyle == StemStyle.track) ? waveformContainer.height - 14 : waveformContainer.height - 10
      
      y:     -1
      width:  3
      height: (slicer.enabled && !beatgrid.editEnabled ) ? sliceModeHeight : waveformContainer.height + 2
      color:        colors.colorRedPlaymarker
      border.color: colors.colorBlack31
      border.width: 1
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Stem Color Indicators (Rectangles)
  //--------------------------------------------------------------------------------------------------------------------

  StemColorIndicators {
    id: stemColorIndicators
    deckId:          view.deckId
    anchors.fill:    stemWaveform
    visible:         stemWaveform.visible
    indicatorHeight: (slicer.enabled && !beatgrid.editEnabled ) ? [34 , 33 , 33 , 33] : [36 , 36 , 36 , 36]
  }

  //--------------------------------------------------------------------------------------------------------------------
  // LoopSize Widgets
  //--------------------------------------------------------------------------------------------------------------------

  Widgets.LoopSize {
    id: loopSize
    anchors.topMargin: 1
    anchors.fill: parent
    visible: showLoopSize
  }


  //--------------------------------------------------------------------------------------------------------------------
  // States
  //------------------------------------------------------------------------------------------------------------------ 
  state: isStemDeck ? "stem" : "single"
  states: [
    State {
      name: "single";
      PropertyChanges { target: singleWaveform; height: view.height; }
      PropertyChanges { target: stemWaveform;   height: 0;           }
    },
    State {
      name: "stem";
      PropertyChanges { target: singleWaveform; height: 0           }
      PropertyChanges { target: stemWaveform;   height: view.height }
      PropertyChanges { target: stemWaveform; anchors.bottomMargin: (isStemDeck & slicer.enabled) ? 15 : 0 }
    }
  ]
  transitions: [
    Transition {
      from: "single"
      SequentialAnimation {
        PropertyAction  { target: stemWaveform;   property: "visible"; value: true; }
        ParallelAnimation {
          NumberAnimation { target: singleWaveform; property: "height";   duration: durations.deckTransition; }
          NumberAnimation { target: stemWaveform;   property: "height";  duration: durations.deckTransition; }
        }
        PropertyAction  { target: singleWaveform; property: "visible"; value: false; }
      }
    },
    Transition {
      from: "stem"
      SequentialAnimation {
        PropertyAction  { target: singleWaveform; property: "visible"; value: true; }
        ParallelAnimation {
          NumberAnimation { target: singleWaveform; property: "height";  duration: durations.deckTransition; }
          NumberAnimation { target: stemWaveform;   property: "height";  duration: durations.deckTransition; }
        }
        PropertyAction  { target: stemWaveform;   property: "visible"; value: false; }
      }
    }
  ]

}
