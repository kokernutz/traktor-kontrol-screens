import QtQuick 2.0
import Qt5Compat.GraphicalEffects

Item {
  anchors.fill: parent
  property color  deckColor:     "black"

  Rectangle {
      id           : background
      color        : colors.defaultBackground
      anchors.fill : parent
  }

  Image {
    id: emptyTrackDeckImage
    anchors.fill:         parent
    anchors.bottomMargin: 15
    anchors.topMargin:    15
    visible:              false // visibility is handled by emptyTrackDeckImageColorOverlay

    source:               "../../Images/EmptyDeck.png"
    fillMode:             Image.PreserveAspectFit
  } 

  // Function Deck Color
  ColorOverlay {
    id: emptyTrackDeckImageColorOverlay
    anchors.fill: emptyTrackDeckImage
    visible:      true
    color:        "#252525"
    source:       emptyTrackDeckImage
  }
}

