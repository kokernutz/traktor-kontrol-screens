import QtQuick 2.5
import '../Widgets' as Widgets

//----------------------------------------------------------------------------------------------------------------------
//  Stem Screen View - UI of the screen for stems
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: display

  // MODEL PROPERTIES //
  property var deckInfo: ({})

  width  : 320
  height : 240

  TrackDeck {
    id: trackScreen
    deckInfo: display.deckInfo
    anchors.fill: parent
  }

  // STEM OVERLAY //
  Widgets.StemOverlay
  {
    visible: display.deckInfo.isStemsActive
    anchors.top:  parent.top
    anchors.left: parent.left
    deckInfo: display.deckInfo
  }
}
