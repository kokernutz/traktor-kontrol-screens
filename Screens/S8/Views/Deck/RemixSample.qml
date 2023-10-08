import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects

import '../Widgets' as Widgets
import '../../../Defines' as Defines

Item {
  id: remixSample

  property string samplePropertyPath: "app.traktor.decks.1.remix.cell.columns.1.rows.1"; // path is set in RemixColumn.qml (default: deck1, cell[1,1])
 
  // this is the color displayed as sample background color
  property color  resultColor: "white" 

  // these properties are necessary to calculate the animated color for the background
  // the sample background colors are stored in a color palette in Colors.qml. They contain 16 colors for each brightness
  // level and 3 additional colors for blinking white/grey and the default background color.
  property color  sampleBgColor:  colors.palette(brightness1.value,  color1.value)
  property color  sampleBgColor2: colors.palette(brightness2.value,  color2.value)
  onSampleBgColorChanged: calculateResultColor()
  onSampleBgColor2Changed: calculateResultColor()

  // dimensions of one sample deck
  width: 111
  height: 47

  Defines.Colors { id: colors }

  //--------------------------------------------------------------------------------------------------------------------

  // function calcuating the background color (resultColor = color1*(1-colorRatio) + color2*colorRatio )
  function calculateResultColor() {
    resultColor.r = sampleBgColor.r*(1.0 - colorRatio.value) + (sampleBgColor2.r*(colorRatio.value));
    resultColor.g = sampleBgColor.g*(1.0 - colorRatio.value) + (sampleBgColor2.g*(colorRatio.value));
    resultColor.b = sampleBgColor.b*(1.0 - colorRatio.value) + (sampleBgColor2.b*(colorRatio.value));
    resultColor.a = sampleBgColor.a*(1.0 - colorRatio.value) + (sampleBgColor2.a*(colorRatio.value));
    remixSampleBg.color = resultColor;
  }

   //-------------------------------------------------------------------------------------------------------------------

  // remix cell AppProperties 
  AppProperty { id: colorId;     path: samplePropertyPath + ".color_id"  }
  AppProperty { id: sampleName;  path: samplePropertyPath + ".name"      } 
  AppProperty { id: playState;   path: samplePropertyPath + ".state"     }
  AppProperty { id: playMode;    path: samplePropertyPath + ".play_mode" } 

  AppProperty { id: color1;      path: samplePropertyPath + ".animation.color_id.1"       }
  AppProperty { id: color2;      path: samplePropertyPath + ".animation.color_id.2"       }
  AppProperty { id: brightness1; path: samplePropertyPath + ".animation.brightness.1"  }
  AppProperty { id: brightness2; path: samplePropertyPath + ".animation.brightness.2"  }
  AppProperty { id: colorRatio;  path: samplePropertyPath + ".animation.color_ratio";  onValueChanged: calculateResultColor() }                          


  //--------------------------------------------------------------------------------------------------------------------

  // Sample Container
  Rectangle {
    id: remixSampleBg

    anchors.fill: parent
    radius:       3
    color:        resultColor
    Component.onCompleted: calculateResultColor() // refers to color palette

    //------------------------------------------------------------------------------------------------------------------

    // Sample Loop & OneShotIcon
    Image {
      id: remixSampleIcon
      anchors.left:       parent.left
      anchors.top:        parent.top
      anchors.leftMargin: 3
      anchors.topMargin:  3

      visible:            false
      source: "../Images/Remix_Sample_Icon_Loop.png"
      state:              playMode.description 
      states: [
        State { name: "Looped";  PropertyChanges { target: remixSampleIcon; source: "../Images/Remix_Sample_Icon_Loop.png"    } },
        State { name: "OneShot"; PropertyChanges { target: remixSampleIcon; source: "../Images/Remix_Sample_Icon_OneShot.png" } } 
      ]
    }

    ColorOverlay {
      id: remixSampleIconColorOverlay

      property double brightness: 0.5

      anchors.fill: remixSampleIcon
      color:        color1.value == 0 ? colors.colorGrey40 : colors.palette(brightness, colorId.value) 
      source:       remixSampleIcon
    }

    //------------------------------------------------------------------------------------------------------------------

    // Sample Name
    Text {
      id: remixSampleName

      property double brightness: 0.5 // set in state

      anchors.fill:         parent
      anchors.bottomMargin: 5
      anchors.leftMargin:   22 
      anchors.rightMargin:  18 

      horizontalAlignment:  Text.AlignHCenter
      verticalAlignment:    Text.AlignVCenter

      color:                colors.palette(brightness, colorId.value)

      text:                 sampleName.value 
      font.pixelSize:       fonts.middleFontSize
      wrapMode:             Text.WrapAnywhere
      maximumLineCount:     2
      lineHeight:           0.8
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  state: playState.description
  states: [
    State {
      name: "Empty"; // = empty cell
      PropertyChanges { target: remixSampleIconColorOverlay;  brightness: 0.5 }
      PropertyChanges { target: remixSampleName;              brightness: 0.5 }
    },
    State {
      name: "Loaded"; // = loaded cell
      PropertyChanges { target: remixSampleIconColorOverlay;  brightness: 0.5 }
      PropertyChanges { target: remixSampleName;              brightness: 0.5 }
    },
    State {
      name: "Playing"; // = cell is playing
      PropertyChanges { target: remixSampleIconColorOverlay;  color: colors.colorBlack /*brightness: 0.0*/ } 
      PropertyChanges { target: remixSampleName;              color: colors.colorBlack /*brightness: 0.0*/ } 
    },
    State {
      name: "Waiting"; // = cell is waiting to be played (waiting for quantized)
      PropertyChanges { target: remixSampleIconColorOverlay;  brightness: 0.5 }
      PropertyChanges { target: remixSampleName;              brightness: 0.5 }
    }
  ]

}
