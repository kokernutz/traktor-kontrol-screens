import QtQuick 2.5
import CSI 1.0

Item
{
  id: hotcuesModel
  property int deckId: 0

  readonly property alias activeHotcue: activeHotcueModel
  readonly property var array:
  [
    hotcueModel1,
    hotcueModel2,
    hotcueModel3,
    hotcueModel4,
    hotcueModel5, 
    hotcueModel6, 
    hotcueModel7, 
    hotcueModel8
  ]

  Item 
  {
    id: activeHotcueModel
    readonly property real position:  activePos.value
    readonly property real length:    activeLength.value
    readonly property string type:  activeType.value

    AppProperty { id: activePos;      path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos" }
    AppProperty { id: activeLength;   path: "app.traktor.decks." + deckId + ".track.cue.active.length" }
    AppProperty { id: activeType;     path: "app.traktor.decks." + deckId + ".track.cue.active.type"   }
  }

  HotCue { id: hotcueModel1; index: 0 } 
  HotCue { id: hotcueModel2; index: 1 } 
  HotCue { id: hotcueModel3; index: 2 } 
  HotCue { id: hotcueModel4; index: 3 } 
  HotCue { id: hotcueModel5; index: 4 } 
  HotCue { id: hotcueModel6; index: 5 } 
  HotCue { id: hotcueModel7; index: 6 } 
  HotCue { id: hotcueModel8; index: 7 } 
}