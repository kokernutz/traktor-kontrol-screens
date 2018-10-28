import CSI 1.0
import QtQuick 2.0
import Traktor.Gui 1.0 as Traktor

Traktor.Stripe {
  id: stripe
  property var hotcuesModel:  {}
  property int           trackLength: 0
  property real          elapsedTime: 0
  property bool          trackEndWarning: false
  readonly property var  waveformColors:   colors.getDefaultWaveformColors()
  
  //-----------------------------------------------------Traktor Stripe Props--------------------------------------------

  deckId:        0

  function lighterColor (c, factor) {
    return Qt.rgba( Math.min(1.0, factor*c.r) ,  Math.min(1.0, factor*c.g) , Math.min(1.0, factor*c.b) , Math.min(1., factor*c.a) );
  }

  function lighterColorK(c) {
    return lighterColor(c, 1.7);
  }

  colorMatrix.high1: lighterColorK(waveformColors.high1)
  colorMatrix.high2: lighterColorK(waveformColors.high2)
  colorMatrix.mid1 : lighterColorK(waveformColors.mid1)
  colorMatrix.mid2 : lighterColorK(waveformColors.mid2)
  colorMatrix.low1 : lighterColorK(waveformColors.low1)
  colorMatrix.low2 : lighterColorK(waveformColors.low2)
  colorMatrix.background: colors.defaultBackground

  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
      id: elapsedTimeShadow
      anchors.left: parent.left
      width: posIndicator.x
      height: posIndicator.height
      color: colors.rgba(0,0,0,175)
  }

  //--------------------------------------------------------------------------------------------------------------------

  Repeater {
    id: hotcues
  
    model: 8
    Hotcue
    {
      property int roundedX: (hotcuesModel.array[index].position/trackLength) * stripe.width  

      anchors.top:     parent.top
      anchors.bottom:  parent.bottom
      x:               roundedX + 3
      hotcueLength:    (hotcuesModel.array[index].length/trackLength) * stripe.width 
      hotcueId:        index + 1
      exists:          hotcuesModel.array[index].exists
      type:            hotcuesModel.array[index].type
      smallHead:       false
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  ActiveCue {
    property int roundedX: (hotcuesModel.activeHotcue.position / parent.trackLength) * stripe.width

    x:               roundedX + 2         
    isSmall:         false
    anchors.bottom:  posIndicator.bottom
    anchors.bottomMargin:8
    activeCueLength: (hotcuesModel.activeHotcue.length / trackLength) * stripe.width
    clip:            false 
    type:            hotcuesModel.activeHotcue.type 
  }

  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: trackEndWarningOverlay

    anchors.left: parent.left
    width:  posIndicator.x
    height: posIndicator.height

    color:               colors.colorRedPlaymarker
    opacity:             0 // initial state
    visible:             trackEndWarning

    Timer {
      id: timer
      property bool blinker: false

      interval: 700
      repeat:   true
      running: trackEndWarning

      onTriggered: { 
        trackEndWarningOverlay.opacity = (blinker) ? 0.35 : 0;
        blinker = !blinker;
      }
    }
  }


  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: posIndicator

    readonly property real relativePlayPos: elapsedTime / trackLength

    x:                 relativePlayPos * stripe.width
    anchors.bottom:    parent.bottom
    height:            parent.height
    width:             2
    color:             colors.rgba(255, 56, 26, 255) 
    opacity:           1
  }
}



//--------------------------------------------------------------------------------------------------------------------