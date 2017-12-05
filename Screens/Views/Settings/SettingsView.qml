import QtQuick 2.0
import './../DeckViews' as Views

Views.View {
  id: browserView
  Rectangle {
    anchors.fill: parent
    color: "beige"
    Text {
      anchors.centerIn: parent
      color: "black"
      text: "Settings View"
    }
  }
}

