import QtQuick 2.0
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as Traktor

//----------------------------------------------------------------------------------------------------------------------
// Colorized Waveform part for Loop
//----------------------------------------------------------------------------------------------------------------------

Item {

  property int loop_start;
  property int loop_length;
  property var waveform
  property var waveformPosition
  //state: "default"

  anchors.fill: parent

  function samples_to_waveform_x( sample_pos )
  {  return (sample_pos / waveformPosition.sampleWidth) * waveformPosition.viewWidth;  }

  Item { id: mask
    visible: false
    anchors.fill: parent

    Traktor.WaveformTranslator {
      anchors.fill: parent

      followTarget: waveformPosition
      pos: loop_start

      Rectangle {
        x: 0
        y: 0
        width: loop_length
        height: waveform.height
        color: "#000"
      }
    }
  }
  /*
  GaussianBlur { id: blur
    anchors.fill: parent
    source:       waveform
    radius:       16
    samples:      32

    Behavior on radius { NumberAnimation { duration: 100 } }
    visible: radius > 1 ? true : false
  }
  */
  OpacityMask { id:  waveform_mask
    visible:      false
    anchors.fill: parent
    source:       waveform
    maskSource:   mask
  }

  Colorize {
    anchors.fill: waveform_mask
    source:       waveform_mask
    hue:          0.33   //  0..1
    saturation:   0.55   //  0..1
    lightness:    0.0    // -1..1
  }
  /*
  states: [
    State { name: "default";  PropertyChanges { target: blur;  radius: 1 } },
    State { name: "blurred";  PropertyChanges { target: blur;  radius: 16 } }
  ]
  */
}
