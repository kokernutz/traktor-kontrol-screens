import QtQuick 2.5
import CSI 1.0


Item
{
  id: cell
  property int slotId:0
  property int deckId: 0
  property int cellId: 0
  
  readonly property bool    isEmpty:      propState.description == "Empty"
  readonly property color   color:        isEmpty ? colors.colorDeckBrightGrey : colors.palette(computeBrightness(propState.description, propDisplayState.description), propColorId.value)
  readonly property color   brightColor:  isEmpty ? colors.colorDeckBrightGrey : colors.palette(1., propColorId.value)
  readonly property color   midColor:     isEmpty ? colors.colorDeckGrey : colors.palette(0.5, propColorId.value)
  readonly property color   dimmedColor:  isEmpty ? colors.colorDeckDarkGrey : colors.palette(0., propColorId.value)
  
  readonly property string  name:         propName.value
  readonly property bool    isLooped:     propPlayMode.description == "Looped"

  AppProperty { id: propColorId;          path: "app.traktor.decks." + deckId + ".remix.cell.columns." + slotId + ".rows." + cellId + ".color_id" }
  AppProperty { id: propName;             path: "app.traktor.decks." + deckId + ".remix.cell.columns." + slotId + ".rows." + cellId + ".name" }
  //PlayMode can be "Looped" or "OneShot"
  AppProperty { id: propPlayMode;         path: "app.traktor.decks." + deckId + ".remix.cell.columns." + slotId + ".rows." + cellId + ".play_mode" }
  AppProperty { id: propState;            path: "app.traktor.decks." + deckId + ".remix.cell.columns." + slotId + ".rows." + cellId + ".state" }
  AppProperty { id: propDisplayState;     path: "app.traktor.decks." + deckId + ".remix.cell.columns." + slotId + ".rows." + cellId + ".animation.display_state"}

  function computeBrightness(state, displayState)
  {
    if(state == "Playing" && displayState == "BrightColor" ) {return 1.;}
    return 0.5;
  }
  
}