import QtQuick 2.0
import './../Definitions' as Definitions


Item {

  id: progressBarContainer

  property alias progressBarWidth:  progressBar.width
  property alias progressBarHeight: progressBarContainer.height
  property color progressBarColorIndicatorLevel: colors.colorIndicatorLevelGrey
  property alias progressBarBackgroundColor: progressBar.color
  property real value: 0.0
  property bool drawAsEnabled: true

  Definitions.Colors { id: colors}

  onValueChanged: {
    var val  = Math.max( Math.min(value, 1.0), 0.0)
    if ( val < 0.5 ) { 
      leftValueIndicator.width  = (0.5 - val) * (progressBar.width - 2)
      rightValueIndicator.width = 0
    } else {
      leftValueIndicator.width  = 0
      rightValueIndicator.width = (val - 0.5) * (progressBar.width - 2)
    }
  }

  height: 6
  width: 120

  // Progress Background
  Rectangle {
    id: progressBar
    anchors.left: parent.left
    anchors.top: parent.top
    height: parent.height
    width:  100 // set from outside
    color: colors.colorWhite // set from outside

    Rectangle {
      id: leftValueIndicator
      width: 0
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.horizontalCenter
      color: progressBarContainer.progressBarColorIndicatorLevel
      visible: drawAsEnabled ? true : false
    }

    Rectangle {
      id: rightValueIndicator
      width: 0
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.horizontalCenter
      color: progressBarContainer.progressBarColorIndicatorLevel
      visible: drawAsEnabled ? true : false
    }
    // Progress Indicator Thumb
    Rectangle {
      id: indicatorThumb
        color: colors.colorWhite // (progressBarContainer.progressBarColorIndicatorLevel != colors.colorWhite) ? colors.colorWhite : colors.colorBlack
        width: 2
        height: parent.height 
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: (leftValueIndicator.width > 0 ) ? leftValueIndicator.left : rightValueIndicator.right
        visible: drawAsEnabled ? true : false
    }
  }
}
