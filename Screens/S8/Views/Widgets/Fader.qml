import QtQuick 2.0
import Qt5Compat.GraphicalEffects

// container
Rectangle {
  id:             faderContainer
  property double internalValue: 0.0
  property double hardwareValue: 0.0
  property bool   mismatch: false

  property variant scaleColor:    colors.colorGrey64
  property variant mismatchColor: colors.colorRed70
  property variant takeoverColor: colors.colorGrey96 //colors.colorGrey152
  property variant handleColor:   colors.colorGrey96 //colors.colorGrey152

  // Number of ticks between start/end tick
  property int tickCount:           4
  // Spacing between the central ticks
  property int interTickSpacing:    8
  // Spacing between the start/end ticks and the central ticks
  property int preTickSpacing:      10
  // Line width of the start/end ticks
  property int borderTickLineWidth: 2
  // Line width of the central ticks
  property int tickLineWidth:       1
 
  property int scaleHeight: (tickCount-1)*interTickSpacing + tickCount*tickLineWidth + 2*preTickSpacing


  opacity:        1
  width:          36
  height:         scaleHeight + 14
  color:          "transparent"

  // background
  Rectangle {
    id:           faderBg
    width:        24
    height:       scaleHeight
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    color:        "transparent"

    // upper line
    Row {
      anchors.top:  parent.top
      spacing: 6
      Repeater {
        model:  2
        Rectangle {
          height:     borderTickLineWidth
          width:      9
          color:      scaleColor
        }
      }
    }

    // bottom line
    Row {
      anchors.bottom: parent.bottom
      spacing: 6
      Repeater {
        model:  2
        Rectangle {
          height:     borderTickLineWidth
          width:      9
          color:      scaleColor
        }
      }
    }

    // indicators left
    Column {
      anchors.left:       parent.left
      anchors.top:        parent.top
      anchors.topMargin:  preTickSpacing
      spacing:            interTickSpacing
      Repeater {
        model:  4
        Rectangle {
          height:     tickLineWidth
          width:      5
          color:      scaleColor
        }
      }
    }

    // indicators right
    Column {
      anchors.right:      parent.right
      anchors.top:        parent.top
      anchors.topMargin:  preTickSpacing
      spacing:            interTickSpacing
      Repeater {
        model:        4
        Rectangle {
          height:     tickLineWidth
          width:      5
          color:      scaleColor
        }
      }
    }

    // vertical lines
    Row {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.leftMargin: 9
      spacing: 4
      Repeater {
        model:  2
        Rectangle {
          width:          1
          height:         scaleHeight
          color:          scaleColor
        }
      }
    }

    // black vertical fill
    Rectangle {
      width:      4
      height:     scaleHeight
      anchors.left: parent.left
      anchors.leftMargin:   10
      color:      colors.colorBlack
    }
  }

  // takeoverPosition
  Item {
    width:        parent.width
    height:       16
    anchors.horizontalCenter: parent.horizontalCenter
    y:            (1 - hardwareValue)* (faderBg.height - 2)
    visible: mismatch
                  
    // handle line
    Rectangle {
      anchors.top:  parent.top
      anchors.left: parent.left
      height:       parent.height
      width:        2
      color:        takeoverColor 
      Rectangle { anchors.top:    parent.top;    anchors.left: parent.left; color: takeoverColor; height: 2; width: 6 }
      Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; color: takeoverColor; height: 2; width: 6 }
    }
    Rectangle {
      anchors.top : parent.top
      anchors.right: parent.right
      height:       parent.height
      width:        2
      color:        takeoverColor 
      Rectangle { anchors.top:    parent.top;    anchors.right: parent.right; color: takeoverColor; height: 2; width: 6 }
      Rectangle { anchors.bottom: parent.bottom; anchors.right: parent.right; color: takeoverColor; height: 2; width: 6 }
    }
  }

  // handle
  Rectangle {
    id:           faderHandle
    y :           (1 - internalValue)* (faderBg.height - 2)
    width:        parent.width
    height:       16
    anchors.horizontalCenter: parent.horizontalCenter
    color:        colors.colorBlack
    border.width:  2
    border.color: faderContainer.mismatch ? mismatchColor : handleColor

    // handle line
    Rectangle {
      id:           faderHandleLine
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
      width:        parent.width -12
      height:       2
      color:        faderContainer.mismatch ? mismatchColor : handleColor
    }
  }
}
