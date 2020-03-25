import CSI 1.0
import QtQuick 2.0

Item {
  anchors.fill: parent

  AppProperty { id: loopEnabled; path: "app.traktor.decks." + (parent.deckId+1) + ".loop.active" }
  AppProperty { id: loopSizePos; path: "app.traktor.decks." + (parent.deckId+1) + ".loop.size";          }

  property int deckId: 0

  Rectangle {
    id:       loopSizeBackground
    width:    59
    height:   width
    radius:   width * 0.5
    color:    colors.colorBlack85
    Behavior on opacity { NumberAnimation { duration: blinkFreq; easing.type: Easing.Linear} }
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter:   parent.verticalCenter
    Rectangle {
      id:       loopLengthBorder
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter:   parent.verticalCenter
      width:  loopSizeBackground.width -2
      height: width
      radius: width * 0.5
      color: "transparent"
      border.color: colors.colorGreen
      border.width: 2
    }
  }

  Text {
      readonly property variant loopText: ["/32", "/16", "1/8", "1/4", "1/2", "1", "2", "4", "8", "16", "32"]
      text: loopText[loopSizePos.value]
      color: colors.colorGreen
      font.pixelSize: fonts.extraLargeValueFontSize
      font.family: "Pragmatica"
      anchors.fill: loopSizeBackground
      anchors.rightMargin: 2
      anchors.topMargin: 1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment:   Text.AlignVCenter
      onTextChanged: {
        if (loopSizePos.value < 5) {
          font.pixelSize = 22
        } else if ( loopSizePos.value > 8 ){
          font.pixelSize = 32
        } else {
          font.pixelSize = fonts.extraLargeValueFontSize
        }
      }
    }
}
