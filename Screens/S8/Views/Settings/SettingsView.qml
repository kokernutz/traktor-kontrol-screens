import QtQuick
import '../DeckViews' as Views

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

