import QtQuick 2.0
import Qt5Compat.GraphicalEffects
import CSI 1.0
import Traktor.Gui 1.0 as Traktor

import '../../Widgets' as Widgets

// The DisplayButtonArea is a stripe on the left/right border of the screen andcontains two DisplayButtons
// showing the state of the actual buttons to the left/right of the main screen.
/// \todo figure out if the button area is a) always visible or b) visible on touching the button


Item {
  id: scrollBar
  property int currentPosition: 0
  anchors.fill: parent
  anchors.verticalCenter: parent.verticalCenter

  
  Column {
    spacing: 3
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    Repeater {
      model: 8
      Rectangle {
        width: 6
        height: 17 
        color: (scrollBar.currentPosition == index) ? colors.colorWhite : colors.colorGrey40
      }
    }
  }

  Widgets.Triangle { 
    id : arrowUp
    width:  10
    height: 9
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:  12
    color: colors.colorGrey40
    rotation: 180
    antialiasing: true

  }

    Widgets.Triangle { 
    id : arrowDown
    width:  10
    height: 9
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin:  13
    color: colors.colorGrey40
    rotation: 0
    antialiasing: true
  }
}

