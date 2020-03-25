import QtQuick 2.0
import Traktor.Gui 1.0 as Traktor

Item {
  property color color:        "black"
  property int   borderWidth:  0
  property color borderColor:  "transparent"

  property alias antialiasing: triangle.antialiasing

  clip: false

  Traktor.Polygon {
    id: triangle
    anchors.centerIn: parent
    color:            parent.color

    border.width:     parent.borderWidth
    border.color:     parent.borderColor

    opacity:          1.0
    clip:             false
    visible:          parent.visible

    points:           [ Qt.point(0, 0), Qt.point(parent.width, 0), Qt.point(0.5* parent.width, parent.height)]
  }
}
