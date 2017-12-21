import QtQuick 2.0
import CSI 1.0
import Traktor.Gui 1.0 as Traktor
import './../Widgets' as Widgets
import './../Definitions' as Definitions

Traktor.Stripe {
  id: stripe
  property int           deckId:            0
  property int           windowSampleWidth: 122880  

  readonly property int  speed:             900 // blink speed
  readonly property real warningOpacity:    0.45
  readonly property int  indicatorBoxWidth: (windowSampleWidth / Math.max(1, propTrackSampleLength.value)) * width
  readonly property var   waveformColors:   colors.getDefaultWaveformColors()
  
  colorMatrix.high1: waveformColors.high1
  colorMatrix.high2: waveformColors.high2
  colorMatrix.mid1 : waveformColors.mid1
  colorMatrix.mid2 : waveformColors.mid2
  colorMatrix.low1 : waveformColors.low1
  colorMatrix.low2 : waveformColors.low2
  colorMatrix.background: colors.colorBgEmpty

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: trackLength;           path: "app.traktor.decks." + (deckId + 1) + ".track.content.track_length" }
  AppProperty { id: propTrackSampleLength; path: "app.traktor.decks." + (deckId + 1) + ".track.content.sample_count" }

  //--------------------------------------------------------------------------------------------------------------------

  function sampleToStripe(sampleValue) {
    return sampleValue/trackLength.value * stripe.width
  }

  //--------------------------------------------------------------------------------------------------------------------

  Rectangle
  {
    id: darkenAlreadyPlayedBox

    anchors.top:       parent.top
    anchors.left:      parent.left
    height:            28
    width:             (elapsedTime.value / trackLength.value) * parent.width
    
    radius:            1
    color:             colors.colorBlack66
    antialiasing:      false
  }

   //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: trackEndWarningOverlay

    AppProperty { id: trackEndWarning; path: "app.traktor.decks." + (deckId+1) + ".track.track_end_warning" }

    anchors.top:         posIndicatorBox.top
    anchors.bottom:      posIndicatorBox.bottom
    anchors.left:        parent.left
    anchors.right:       posIndicatorBox.horizontalCenter
    anchors.topMargin:    2
    anchors.bottomMargin: 2 
    anchors.rightMargin:  2  

    color:               colors.colorRed
    opacity:             0 // initial state
    visible:            (trackEndWarning.value) ? true : false

    Timer {
      id: timer
      property bool  blinker: false

      interval: speed
      repeat:   true
      running:  trackEndWarning.value

      onTriggered: { 
        trackEndWarningOverlay.opacity = (blinker) ? warningOpacity : 0;
        blinker = !blinker;
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  Repeater {
    id: hotcues
    model: 8
    Widgets.Hotcue {
      property int roundedX: sampleToStripe(pos.value)  // ensures that the flags are drawn "on the pixel" 

      AppProperty { id: pos;    path: "app.traktor.decks." + (parent.deckId + 1 ) + ".track.cue.hotcues." + (index + 1) + ".start_pos" }
      AppProperty { id: length; path: "app.traktor.decks." + (view.deckId   + 1 ) + ".track.cue.hotcues." + (index + 1) + ".length"    }

      anchors.top:     parent.top
      anchors.bottom:  parent.bottom
      x:               roundedX
      hotcueLength:    sampleToStripe(length.value)
      showHead:       (stripe.deckSizeState != "small") ? true : false;
      hotcueId:        index + 1
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  Widgets.ActiveCue {
    property int roundedX: sampleToStripe(activePos.value)  // ensures that the flags are drawn "on the pixel" 

    AppProperty { id: activePos;    path: "app.traktor.decks." + (parent.deckId+1) + ".track.cue.active.start_pos" }
    AppProperty { id: aciveLength;  path: "app.traktor.decks." + (parent.deckId+1) + ".track.cue.active.length"   }
    x:               roundedX         
    isSmall:         true
    anchors.bottom:  parent.bottom
    anchors.bottomMargin: 2
    activeCueLength: sampleToStripe(aciveLength.value)
    clip:            false
  }

  
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: posIndicatorBox

    property int roundedX:  (relativePlayPos * (parent.width - posIndicator.width) - 0.5*width)
    readonly property real relativePlayPos: elapsedTime.value / trackLength.value

    AppProperty { id: elapsedTime; path: "app.traktor.decks." + (deckId+1) + ".track.player.elapsed_time" }
    x:                 roundedX            
    anchors.top:       parent.top
    height:            28
    width:             Math.max (parent.indicatorBoxWidth - (1 - parent.indicatorBoxWidth%2) , 5) // 
    
    radius:            1
    color:             colors.colorRedPlaymarker06 
    border.color:      colors.colorRedPlaymarker75
    border.width:      1
    antialiasing:      false

    Rectangle {
      id: posIndicatorShadow
      anchors.horizontalCenter: posIndicator.horizontalCenter
      anchors.verticalCenter:   posIndicator.verticalCenter
      width: 3
      height: posIndicator.height + 2
      color: colors.colorBlack50
    }

    Rectangle {
      id: posIndicator
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top:              parent.top
      anchors.bottom:           parent.bottom
      anchors.topMargin:        2
      anchors.bottomMargin:     2
      antialiasing:             false

      color: colors.colorRedPlaymarker
      width: 1      
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: fluxPosIndicator

    property int roundedX:  fluxPosIndicator.relativePlayPos * (stripe.width - 1)
    readonly property real relativePlayPos: propFluxPosition.value / trackLength.value

    anchors.top:       parent.top
    anchors.topMargin: 2

    height:            24
    width:             1
    x:                 roundedX     


    antialiasing:             false

    AppProperty { id: propFluxPosition; path: "app.traktor.decks." + (deckId + 1) + ".track.player.flux_position" }
    AppProperty { id: propFluxState;    path: "app.traktor.decks." + (deckId + 1) + ".flux.state" }

    visible: propFluxState.value == 2
    color:   colors.colorBluePlaymarker 

    Rectangle {
      id: fluxPosIndicatorShadow
      anchors.horizontalCenter: fluxPosIndicator.horizontalCenter
      anchors.verticalCenter: fluxPosIndicator.verticalCenter
      width: 3
      height: fluxPosIndicator.height + 2
      color: colors.colorBlack50
    }
  }


  //--------------------------------------------------------------------------------------------------------------------

  Repeater {
    id: minuteMarkers
    model: Math.floor(trackLength.value / 60)

    Rectangle {
      anchors.bottom:  parent.bottom
      x:               sampleToStripe(60 * (index + 1)) - 1
      width:           3
      height:          5
      color:           colors.colorBlack
    }

    Rectangle {
      anchors.bottom:  parent.bottom
      x:               sampleToStripe(60 * (index + 1))
      width:           1
      height:          3
      color:           colors.colorWhite
    }
  }

}