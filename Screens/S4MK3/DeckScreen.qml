import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as Traktor

import '../Defines' as Defines
import './Views' as Views
import './ViewModels' as ViewModels

Item {
  id: deckscreen

  property int deckId: 1

  //--------------------------------------------------------------------------------------------------------------------
  // Deck Screen: show informations for track, stem, remix decks
  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: deckType;  path: "app.traktor.decks." + deckId + ".type" }
  AppProperty { id: directThruID;  path: "app.traktor.decks." + deckId + ".direct_thru" }

  ViewModels.DeckInfo {
    id: deckInfoModel
    deckId: deckscreen.deckId
  }

  Component {
    id: emptyDeckComponent;

    Views.EmptyDeck {
      anchors.fill: parent
    }
  }

  Component {
    id: trackDeckComponent;

    Views.TrackDeck {
      deckInfo: deckInfoModel
      anchors.fill: parent
    }
  }

  Component {
    id: stemDeckComponent;

    Views.StemDeck {
      deckInfo: deckInfoModel
      anchors.fill: parent
    }
  }

  Component {
    id: remixDeckComponent;

    Views.RemixDeck {
      deckInfo: deckInfoModel
      anchors.fill: parent
    }
  }

  Loader {
    id: loader
    active: true
    visible: true
    anchors.fill: parent
    sourceComponent: trackDeckComponent
  }

  Item {
    id: content
    state: "Empty Deck"

    Component.onCompleted: { content.state = Qt.binding(function(){ return directThruID.value ? "Direct Thru" : deckType.description }); }

    states: [
      State {
        name: "Empty Deck"
        PropertyChanges { target: loader; sourceComponent: emptyDeckComponent }
      },
      State {
        name: "Track Deck"
        PropertyChanges { target: loader; sourceComponent: trackDeckComponent }
      },
      State {
        name: "Stem Deck"
        PropertyChanges { target: loader; sourceComponent: stemDeckComponent  }
      },
      State {
        name: "Remix Deck"
        PropertyChanges { target: loader; sourceComponent: remixDeckComponent }
      },
      State {
        name: "Live Input"
        PropertyChanges { target: loader; sourceComponent: emptyDeckComponent }
      },
      State {
        name: "Direct Thru"
        PropertyChanges { target: loader; sourceComponent: emptyDeckComponent }
      }
    ]
  }

}
