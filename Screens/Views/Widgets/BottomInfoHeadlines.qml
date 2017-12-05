import QtQuick 2.0

Item {
  id: bottomInfoHeadlines

  property string headlineText: "FILTER"
  property variant textColor: "white"

  height: 13
  width: 157

  Text {
    text: headlineText
    color: textColor
    font.pixelSize: fonts.scale(10)
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
  }

  Rectangle {
    id: bottomInfoLine
    height: 1
    color: textColor
    anchors.bottom: parent.bottom
    width: parent.width
  }
}
