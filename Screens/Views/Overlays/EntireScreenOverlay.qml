import QtQuick 2.0
import CSI 1.0

import './../Widgets/' as Widgets

Rectangle {
  id: overlay
  property alias showHide: showHideState.state

  AppProperty { id: fader1; path: "app.traktor.decks.1.remix.players.1.volume" }
  AppProperty { id: fader2; path: "app.traktor.decks.1.remix.players.2.volume" }
  AppProperty { id: fader3; path: "app.traktor.decks.1.remix.players.3.volume" }
  AppProperty { id: fader4; path: "app.traktor.decks.1.remix.players.4.volume" }
  
  property variant faderValues: [fader1.value,fader2.value,fader3.value,fader4.value]

  anchors.fill: parent
  color: "black"
  opacity: 0.5

  //------------------------------------------------------------------------------------------------------------------
  //  STATES
  //------------------------------------------------------------------------------------------------------------------
  Item {
    id: showHideState
    state: "hide"

    states: [
      State {
        name: "hide"
        PropertyChanges { target: overlay; visible: false }   
      },
      State {
        name: "show"
        PropertyChanges { target: overlay; visible: true }
      }
    ]
  }
} 
