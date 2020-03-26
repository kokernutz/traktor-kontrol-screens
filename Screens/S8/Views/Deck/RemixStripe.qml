import QtQuick 2.0
import CSI 1.0
import Traktor.Gui 1.0 as Traktor


Rectangle {
  property int           xPosition: 1
  property int           deckId: 0
  property string        propertyPath // set outside
  readonly property bool trackIsLoaded: ((trackLength.value != 0) && ((primaryKey.value != 0) || isMemoryOnly.value))
  readonly property var  waveformColors:  colors.getWaveformColors(activeCellColorId.value)
 
  clip: true
  width: 0
  height: 0
  color: colors.palette(0, 0)

  AppProperty { id: activeCellColorId;  path: activeSamplePath + ".color_id" }
  AppProperty { id: playPosition; path: propertyPath + ".play_position"                     }
  AppProperty { id: trackLength;  path: propertyPath + ".content.track_length"              }
  AppProperty { id: volume;       path: propertyPath + ".level"                             }  
  AppProperty { id: primaryKey;   path: propertyPath + ".content.entry_key";                }
  AppProperty { id: isMemoryOnly; path: propertyPath + ".content.is_memory_only";           } 
  AppProperty { id: timeStamp;    path: propertyPath + ".content.memory_audio_time_stamp"   }
  
  AppProperty { id: deckIsInLoop; path: "app.traktor.decks." + (deckId+1) + ".loop.active"; }

  AppProperty { 
    id: muted;       
      path: propertyPath  + ".muted"
      onValueChanged: {
      waveform.opacity = value ? 0.3 : 1; playPositionIndicator.opacity = value ? 0.3 : 1; 
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  
  Traktor.Stripe {
    id: waveform
    anchors.fill:            parent
    audioStreamKey:          isMemoryOnly.value ? ["MemoryStreamKey", timeStamp.value] : ["PrimaryKey", primaryKey.value]
    deckId:                  parent.deckId
    playerId:                xPosition - 1
    visible:                 trackIsLoaded
    colorMatrix.background:  colors.colorBgEmpty

    colorMatrix.high1: waveformColors.high1
    colorMatrix.high2: waveformColors.high2
    colorMatrix.mid1 : waveformColors.mid1
    colorMatrix.mid2 : waveformColors.mid2
    colorMatrix.low1 : waveformColors.low1
    colorMatrix.low2 : waveformColors.low2
    
  }

  //--------------------------------------------------------------------------------------------------------------------

  // playmarker indicating the current play position of the track  
  Rectangle {
    id: playPositionIndicator
    width:   3
    height:  parent.height + 2 
    color:   colors.colorRedPlaymarker
    visible: trackIsLoaded 
    // calculate the position of the indicator: 'waveform rectangle width' * currentPlayPosition/trackLength
    x:       (trackLength.value != 0) ? waveform.width*(playPosition.value/trackLength.value) -1 : 0  // -1 is a fix for 1px shadow border

    anchors.verticalCenter: parent.verticalCenter

    border {
      color: colors.colorBlack50
      width: 1
    }
  }

  Rectangle {
    id: loop_overlay
    visible: deckIsInLoop.value == 1
    anchors.fill: waveform
    color: "#44007700"
  }
}
