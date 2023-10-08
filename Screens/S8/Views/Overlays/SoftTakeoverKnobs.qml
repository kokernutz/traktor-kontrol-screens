import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects

import '../Widgets' as Widgets

Item {
  id: softTakeoverKnobs
  height: 69
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
      height:63;
      color: colors.colorDivider
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.leftMargin: (index+1) * 120
    }
  }

  // knobs

  MappingProperty { id: knob_active1;         path: propertiesPath +  ".softtakeover.knobs.1.active" }
  MappingProperty { id: knob_active2;         path: propertiesPath +  ".softtakeover.knobs.2.active" }
  MappingProperty { id: knob_active3;         path: propertiesPath +  ".softtakeover.knobs.3.active" }
  MappingProperty { id: knob_active4;         path: propertiesPath +  ".softtakeover.knobs.4.active" }
  MappingProperty { id: knob_inputPosition1;  path: propertiesPath +  ".softtakeover.knobs.1.input"  }
  MappingProperty { id: knob_inputPosition2;  path: propertiesPath +  ".softtakeover.knobs.2.input"  }
  MappingProperty { id: knob_inputPosition3;  path: propertiesPath +  ".softtakeover.knobs.3.input"  }
  MappingProperty { id: knob_inputPosition4;  path: propertiesPath +  ".softtakeover.knobs.4.input"  }
  MappingProperty { id: knob_outputPosition1; path: propertiesPath +  ".softtakeover.knobs.1.output" }
  MappingProperty { id: knob_outputPosition2; path: propertiesPath +  ".softtakeover.knobs.2.output" }
  MappingProperty { id: knob_outputPosition3; path: propertiesPath +  ".softtakeover.knobs.3.output" }
  MappingProperty { id: knob_outputPosition4; path: propertiesPath +  ".softtakeover.knobs.4.output" }

  property variant knob_inputPosition:  [knob_inputPosition1.value,     knob_inputPosition2.value,     knob_inputPosition3.value,     knob_inputPosition4.value    ]
  property variant knob_outputPosition: [knob_outputPosition1.value,    knob_outputPosition2.value,    knob_outputPosition3.value,    knob_outputPosition4.value   ]
  property variant knob_active:         [knob_active1.value,            knob_active2.value,            knob_active3.value,            knob_active4.value           ]

  Row {
    Repeater {
      model: 4

      Item {
        width: softTakeoverKnobs.width / 4
        height: softTakeoverKnobs.height

        Widgets.Knob {
          anchors.centerIn: parent
          internalValue:  knob_inputPosition[index]
          hardwareValue:  knob_outputPosition[index]
          mismatch:       knob_active[index]
        }
      }
    }
  }

  // black border & shadow
  Rectangle {
    id: headerBlackLine
    anchors.top: softTakeoverKnobs.bottom
    width:       parent.width
    height:      2
    color:       colors.colorBlack
  }
}


