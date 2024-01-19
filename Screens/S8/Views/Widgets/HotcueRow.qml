import CSI 1.0
import QtQuick 2.0

Item {
  id: hotcue_row

  Repeater {
    id: hotcues
    model: 8

    Rectangle {
      property string nameTrimmed: name.value.trim()
      property bool   hasName:     (nameTrimmed != "" && nameTrimmed != "n.n.")

      AppProperty { id: exists; path: "app.traktor.decks." + (deckId + 1) + ".track.cue.hotcues." + (index + 1) + ".exists" }
      AppProperty { id: name;   path: "app.traktor.decks." + (deckId + 1) + ".track.cue.hotcues." + (index + 1) + ".name"   }

      anchors.left:   parent.left
      anchors.leftMargin: 5 + 60 * index
      anchors.bottom: parent.bottom
      width:          50
      height:         17
      color:          "transparent"

      Text {
        anchors.fill:   parent
        anchors.topMargin:   1
        color:          exists.value ? colors.colorGrey232 : colors.colorGrey24
        font.pixelSize: fonts.miniFontSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment:   Text.AlignVCenter
        elide:          Text.ElideMiddle
        text:           exists.value ? (hasName ? nameTrimmed : (index + 1)) : "▲"
      }
      Rectangle {
        anchors.left:   parent.left
        anchors.bottom: parent.bottom
        width:          parent.width
        height:         2
        color:          exists.value ? colors.hotcueColors[index + 1] : colors.colorGrey24
      }
    }
  }
}
