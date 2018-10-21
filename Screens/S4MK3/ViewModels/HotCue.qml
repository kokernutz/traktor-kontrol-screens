import QtQuick 2.5
import CSI 1.0

Item
{
  id: hotcue
  readonly property real position:  propPosition.value
  readonly property real length:    propLength.value
  readonly property string type:    propType.value
  readonly property bool exists:    propExists.value
  property int index: 0
  
  AppProperty { id: propPosition;   path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".start_pos" }
  AppProperty { id: propLength;     path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".length"    }
  AppProperty { id: propType;       path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".type"   }
  AppProperty { id: propExists;     path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".exists" }
}