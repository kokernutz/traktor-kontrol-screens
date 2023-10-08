import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects

import '../Widgets' as Widgets

Item {
  id: softTakeoverFaders
  height: 81
  anchors.left:  parent.left
  anchors.right: parent.right

  // dark grey background
  Rectangle {
    anchors.fill: parent
    color: colors.colorFxHeaderBg
  }

  // dividers
  Repeater {
    model: 3
    Rectangle {
      width:1;
      height:75;
      color: colors.colorDivider
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.leftMargin: (index+1) * 120
    }
  }

  // faders
  MappingProperty { id: fader_active1;         path: propertiesPath +  ".softtakeover.faders.1.active" }
  MappingProperty { id: fader_active2;         path: propertiesPath +  ".softtakeover.faders.2.active" }
  MappingProperty { id: fader_active3;         path: propertiesPath +  ".softtakeover.faders.3.active" }
  MappingProperty { id: fader_active4;         path: propertiesPath +  ".softtakeover.faders.4.active" }
  MappingProperty { id: fader_inputPosition1;  path: propertiesPath +  ".softtakeover.faders.1.input"  }
  MappingProperty { id: fader_inputPosition2;  path: propertiesPath +  ".softtakeover.faders.2.input"  }
  MappingProperty { id: fader_inputPosition3;  path: propertiesPath +  ".softtakeover.faders.3.input"  }
  MappingProperty { id: fader_inputPosition4;  path: propertiesPath +  ".softtakeover.faders.4.input"  }
  MappingProperty { id: fader_outputPosition1; path: propertiesPath +  ".softtakeover.faders.1.output" }
  MappingProperty { id: fader_outputPosition2; path: propertiesPath +  ".softtakeover.faders.2.output" }
  MappingProperty { id: fader_outputPosition3; path: propertiesPath +  ".softtakeover.faders.3.output" }
  MappingProperty { id: fader_outputPosition4; path: propertiesPath +  ".softtakeover.faders.4.output" }

  property variant fader_inputPosition: [fader_inputPosition1.value,    fader_inputPosition2.value,    fader_inputPosition3.value,    fader_inputPosition4.value   ]
  property variant fader_outputPosition:[fader_outputPosition1.value,   fader_outputPosition2.value,   fader_outputPosition3.value,   fader_outputPosition4.value  ]
  property variant fader_active:        [fader_active1.value,           fader_active2.value,           fader_active3.value,           fader_active4.value          ]

  Row {
    Repeater {
      model: 4

      Item {
        width: softTakeoverFaders.width / 4
        height: softTakeoverFaders.height

        Widgets.Fader {
          anchors.centerIn: parent
          internalValue:  fader_inputPosition[index]
          hardwareValue:  fader_outputPosition[index]
          mismatch:       fader_active[index]
        }
      }
    }
  }

  // black border & shadow
  Rectangle {
    id: headerBlackLine
    anchors.bottom: softTakeoverFaders.top
    width:          parent.width
    height:         1
    color:          colors.colorBlack
  }
}


