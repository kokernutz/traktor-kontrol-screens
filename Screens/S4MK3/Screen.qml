import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as Traktor

import '../Defines' as Defines
import 'Views' as Views

//----------------------------------------------------------------------------------------------------------------------
//  S4MK3 Screen - manage top/bottom deck of one screen
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: screen

  property int side: ScreenSide.Left;
  readonly property bool isLeftScreen: (screen.side == ScreenSide.Left)

  property string settingsPath: ""
  property string propertiesPath: ""

  //--------------------------------------------------------------------------------------------------------------------

  readonly property int topDeckId: isLeftScreen ? 1 : 2
  readonly property int bottomDeckId: isLeftScreen ? 3 : 4
  readonly property int deckId: propTopDeckFocus.value ? topDeckId : bottomDeckId
  MappingProperty { id: propTopDeckFocus;           path: propertiesPath + ".top_deck_focus" }
  MappingProperty { id: propTopDeckSelectedSlot;    path: propertiesPath + "." + topDeckId    + ".active_slot" }
  MappingProperty { id: propBottomDeckSelectedSlot; path: propertiesPath + "." + bottomDeckId + ".active_slot" }

  Defines.Font   {id: fonts}
  Defines.Utils  {id: utils}
  Defines.Durations {id: durations}
  Views.Colors {id: colors}

  width:  320
  height: 240
  clip:   true

  /*
    A screen is visible if - 
    The deck is in focus and the linked deck is not selecting a sample slot
    OR
    The deck is not in focus but a sample slot is selected 
  */

  DeckScreen {
    id: topDeckScreen
    deckId: topDeckId
    visible: (propTopDeckFocus.value && propBottomDeckSelectedSlot.value == 0) || propTopDeckSelectedSlot.value != 0;
    anchors.fill: parent
  }

  DeckScreen {
    id: bottomDeckScreen
    deckId: bottomDeckId
    visible: (!propTopDeckFocus.value && propTopDeckSelectedSlot.value == 0) || propBottomDeckSelectedSlot.value != 0;
    anchors.fill: parent
  }

}
