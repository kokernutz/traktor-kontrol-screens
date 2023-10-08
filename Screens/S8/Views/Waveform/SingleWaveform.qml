import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as T


Item {
  id: view

  property int deckId:          0
  property int streamId:        0 
  property int sampleWidth:     0  
  property var waveformColors:  colors.getDefaultWaveformColors()
  property var waveformPosition 

  readonly property var audioStreamKey: (primaryKey.value == 0) ? ["MixerDeckKey", view.deckId] 
                                                                : ["PrimaryKey", primaryKey.value, streamId]
  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: primaryKey; path: "app.traktor.decks." + (deckId + 1) + ".track.content.entry_key" }
  

  //--------------------------------------------------------------------------------------------------------------------

  T.Waveform {
    id: waveform
    anchors.fill:     parent
    deckId:           view.deckId
    waveformPosition: view.waveformPosition
    
    colorMatrix.high1: waveformColors.high1
    colorMatrix.high2: waveformColors.high2
    colorMatrix.mid1 : waveformColors.mid1
    colorMatrix.mid2 : waveformColors.mid2
    colorMatrix.low1 : waveformColors.low1
    colorMatrix.low2 : waveformColors.low2

    audioStreamKey:  (!view.visible) ? ["PrimaryKey", 0] : view.audioStreamKey
  }

  //--------------------------------------------------------------------------------------------------------------------

  WaveformColorize { 
    id: waveformColorize
    anchors.fill:  parent
    loop_start:    waveformCues.cueStart
    loop_length:   waveformCues.loop_length
    visible:       waveformCues.is_looping

    waveform:         waveform
    waveformPosition: view.waveformPosition
  }

}
