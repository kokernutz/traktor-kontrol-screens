import QtQuick 2.0


Item {

  id: knobLabelBar

  property real value: 0.2

  onValueChanged: {
    if ( value > 1.0 ) value = 1.0
    if ( value < 0.0 ) value = 0.0
  }

  width: 100
  height: 80


  // Value Indicator ---------------------------------------------------------------------------------------------------
  ProgressBar {   id: valueBar

    value: knobLabelBar.value

    anchors {
      bottom:  parent.bottom
      left:  parent.left
      right:  parent.right
    }
  }
}