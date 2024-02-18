import CSI 1.0
import QtQuick
import Traktor.Gui 1.0 as Traktor

import '../Widgets' as Widgets



Item {
  id: view
  property int  deckId: 0
  property bool forceHideLoop: false 
  property var  waveformPosition

  anchors.fill: parent

   

  property int cueType:   activeCueType.value
  property int cueStart:  activeCueStart.value * sampleRate.value
  property int cueLength: activeCueLength.value * sampleRate.value

  property int  loop_length: samples_to_waveform_x(cueLength)
  property bool is_looping:  ( cueType == 5 ) && ( loopEnabled.value == true ) 

  // test begin
  property var highOpacity: 1
  property var lowOpacity: 0.25
  property var blinkFreq: 500

  // test end

  function samples_to_waveform_x( sample_pos ) { return (sample_pos / waveformPosition.sampleWidth) * waveformPosition.viewWidth; }


  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: sampleRate;      path: "app.traktor.decks." + (deckId+1) + ".track.content.sample_rate" }
  AppProperty { id: loopEnabled;     path: "app.traktor.decks." + (deckId+1) + ".loop.active"          }
  AppProperty { id: activeCueType;   path: "app.traktor.decks." + (deckId+1) + ".track.cue.active.type"        }
  AppProperty { id: activeCueStart;  path: "app.traktor.decks." + (deckId+1) + ".track.cue.active.start_pos"   }
  AppProperty { id: activeCueLength; path: "app.traktor.decks." + (deckId+1) + ".track.cue.active.length"      }
  AppProperty { id: activePos;       path: "app.traktor.decks." + (deckId+1) + ".track.cue.active.start_pos"   }
  AppProperty { id: loopSizePos;     path: "app.traktor.decks." + (deckId+1) + ".loop.size"                    }


  //--------------------------------------------------------------------------------------------------------------------
  // Loop Overlay & Marker
  //--------------------------------------------------------------------------------------------------------------------

  Traktor.WaveformTranslator {
    followTarget: waveformPosition
    pos:          cueStart
    visible:      is_looping && !forceHideLoop
    anchors.fill: view

    property int deckId: view.deckId
    readonly property int lineWidthAdjustment: -2

    Rectangle {                         // loop coloring
      color:  colors.colorGreenLoopOverlay       // sets the loop bg color
      x:      parent.lineWidthAdjustment
      height: view.height
      y:      0
      width:  samples_to_waveform_x(cueLength)
    }

    Rectangle {                         // left marker
      id: loopMarkerLeft
      color: colors.colorGreen
      opacity: 1
      x:       parent.lineWidthAdjustment
      y:       0
      height:  view.height 
      width:   1
    }

    Rectangle {                         // right marker
      id: loopMarkerRight
      color:   colors.colorGreen
      opacity: 1
      x:       samples_to_waveform_x(cueLength) + parent.lineWidthAdjustment
      y:       0
      height:  view.height 
      width:   1
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Hot Cues
  //--------------------------------------------------------------------------------------------------------------------

  Repeater {
    id: hotcues
    model: 8

    Traktor.WaveformTranslator
    {
      property int deckId: view.deckId

      AppProperty { id: pos;    path: "app.traktor.decks." + (view.deckId+1) + ".track.cue.hotcues." + (index + 1) + ".start_pos" }

      followTarget: waveformPosition
      pos:          pos.value * sampleRate.value // pos in samples

      Widgets.Hotcue {
        AppProperty { id: length; path: "app.traktor.decks." + (view.deckId+1) + ".track.cue.hotcues." + (index + 1) + ".length"    }
        anchors.topMargin: 3
        height:            view.height
        showHead:          trackDeck.deckSizeState != "small"
        smallHead:         false
        hotcueLength:      samples_to_waveform_x(length.value* sampleRate.value)
        hotcueId:          index + 1
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Active Cue
  //--------------------------------------------------------------------------------------------------------------------

  Traktor.WaveformTranslator {
    id: activeCue
    property int deckId: view.deckId
    followTarget: waveformPosition
    pos: cueStart
    visible: trackDeck.trackIsLoaded && (trackDeck.deckSizeState != "small") && !slicer.enabled
    anchors.fill: parent

    Widgets.ActiveCue {
      clip: false
      anchors.bottomMargin:  8
      anchors.bottom:  parent.bottom
      height: 20
      width: 20
      x:               0
      activeCueLength: samples_to_waveform_x(cueLength)
      isSmall: false
    }
  }

}
