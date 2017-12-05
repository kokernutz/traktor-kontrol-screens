import QtQuick 2.0
import Traktor.Gui 1.0 as Traktor

Traktor.Polygon {
  antialiasing: false
  color:        "black" 
  border.color: "green"
  border.width: 0
  points:       [ Qt.point(0, 0), Qt.point(3, 0), Qt.point(6, 3.5), Qt.point(3, 7), Qt.point(0, 7), Qt.point(3, 3.5) ]
}

