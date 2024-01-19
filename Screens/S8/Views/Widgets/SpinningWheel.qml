
import QtQuick 2.0
import Qt5Compat.GraphicalEffects

Item {
  property color textColor: "black"
  property int   circleWidth: 3
  property bool  spinning: false
  
  width: 32
  height: width
  anchors.topMargin: -1
  anchors.leftMargin: -1

  Rectangle {
    id: gradientContainer
    width:  parent.width
    height: parent.height
    color:  "transparent"
    clip:   true
    radius: width * 0.5
    border.width: 2
    border.color: textColor
  }

  // ConicalGradient {
  //   id: loopGradient2
  //   anchors.fill: gradientContainer

  //   angle: 0.0
  //   RotationAnimation on rotation {
  //     loops:    Animation.Infinite
  //     from:     0
  //     to:       360
  //     duration: 500
  //   }
  //   gradient: Gradient {
  //     GradientStop {position: 1.0; color: textColor}
  //     GradientStop {position: 0.0; color: "transparent"}
  //   }
  // }
  
  // Rectangle {
  //   id: outerCover
  //   width: 46
  //   height: width
  //   radius: width * 0.5
  //   color: spinning ? "transparent" : textColor
  //   border.color: "black"
  //   border.width: 8
  //   anchors.horizontalCenter: gradientContainer.horizontalCenter
  //   anchors.verticalCenter: gradientContainer.verticalCenter
  // }

  // Rectangle {
  //   id: innerCover
  //   width: 26
  //   height: width
  //   radius: width * 0.5
  //   color: "black"
  //   anchors.horizontalCenter: gradientContainer.horizontalCenter
  //   anchors.verticalCenter: gradientContainer.verticalCenter
  // }
}
