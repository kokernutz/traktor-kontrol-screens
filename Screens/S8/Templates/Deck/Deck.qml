import CSI 1.0
import QtQuick 2.0

import '../../../../Defines'
import '../../Views/Deck/' as DeckTypes

//------------------------------------------------------------------------------------------------------------------
// SPECIFICATION OF ONE DECK (UPPER OR LOWER DECK)
// The deck is created using the data of the corresponding deck id in traktor. (0 = A, 1 = B, 2 = C, 3 = D)
// The deck can be in Remix Deck, Track Deck and Live Deck mode.
// \todo the track deck should use a Loader component, too! (as the remix deck already does)
//------------------------------------------------------------------------------------------------------------------

Item {
  id: view
  property int    deckId:            0
  property int    remixDeckRowShift: 1
  property string deckSize:          "medium"
  property bool   directThru:        directThruID.value
  property bool   showLoopSize: false
  property int    zoomLevel:    1
  property bool   isInEditMode: false
  property string propertiesPath: ""
  property int    stemStyle:    StemStyle.track
  property string deckContentState:  deckType.description

  // -------------------------------------------------------------------------------------------------------------------
  AppProperty { id: deckType;      path: "app.traktor.decks." + (deckId + 1) + ".type" }
  AppProperty { id: directThruID;  path: "app.traktor.decks." + (deckId + 1) + ".direct_thru" }

  Flipable {
    id: flipable

    anchors.top:    deckHeader.bottom
    anchors.left:   parent.left
    anchors.right:  parent.right
    anchors.bottom: parent.bottom

    Behavior on anchors.topMargin { NumberAnimation { duration: durations.deckTransition } }

    // TRACK DECK  -------------------------------------------------------------------------------------------------------

    front:
        Item {
      id: frontSide
      anchors.fill: parent
      Loader {
        id:              loader1
        anchors.fill:    parent
        sourceComponent: trackDeckComponent
        active:          true
        visible:         true
      }
    }

    // REMIX DECK  -------------------------------------------------------------------------------------------------------

    back:
        Item {
      id: backSide
      anchors.fill: parent
      Loader {
        id:              loader2
        anchors.fill:    parent
        sourceComponent: remixDeckComponent
        active:          true
        visible:         true
      }
    }

    transform:
        Rotation {
      id: rotation
      origin.x: 0.5*flipable.width
      origin.y: 0.5*flipable.height
      axis.x: 1; axis.y: 0; axis.z: 0     // set axis.x to 1 to rotate around x-axis
      angle: 0
      Behavior on angle { NumberAnimation { duration: 1000 } }

    }

    Component { id: emptyDeckComponent; DeckTypes.EmptyDeck { id: emptyDeck; deckSizeState: view.deckSize } }

    Component { id: trackDeckComponent; DeckTypes.TrackDeck { id: trackDeck; deckId: view.deckId; deckSizeState: view.deckSize; zoomLevel: view.zoomLevel; showLoopSize: view.showLoopSize; isInEditMode: view.isInEditMode; stemStyle: view.stemStyle; propertiesPath: view.propertiesPath } }
    
    Component { id: stemDeckComponent;  DeckTypes.TrackDeck  { id: stemDeck; deckId: view.deckId; deckSizeState: view.deckSize; zoomLevel: view.zoomLevel; showLoopSize: view.showLoopSize; isInEditMode: view.isInEditMode; stemStyle: view.stemStyle; propertiesPath: view.propertiesPath } }

    Component {
      id: remixDeckComponent
      DeckTypes.RemixDeck {
        id: remixDeck
        remixDeckPropertyPath: "app.traktor.decks." + (deckId + 1) + ".remix."
        deckId:    view.deckId
        sizeState: view.deckSize
        rowShift:  remixDeckRowShift
        showLoopSize: view.showLoopSize
        height:    0
        visible:   true
      }
    }

    //  ------------------------------------------------------------------------------------------------------------------

    Item {
      id: content
      state: "Track Deck"
      property string prevState: "Track Deck"
      property bool flipped: false
      Component.onCompleted: { content.state = Qt.binding(function(){ return directThruID.value ? "Direct Thru" : deckType.description }); }

      states: [
        State { name: "Track Deck";  },
        State { name: "Stem Deck";   },
        State { name: "Remix Deck";  },
        State { name: "Live Input";  },
        State { name: "Direct Thru"; }
      ]

      transitions: [
        // the sequntial animations are necessary to load the correct deck before flipping sides.
        Transition {
          to: "Track Deck"
          SequentialAnimation {
            PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: trackDeckComponent               }
            PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active";          value: true                             }
            NumberAnimation { target: rotation;                            property: "angle";           to:    content.flipped ? 0 : 180; duration: 100 }
            PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active";          value: false                            }
            PropertyAction  { target: content;                             property: "flipped";         value: !content.flipped                         }
          }
        },
        Transition {
          to: "Remix Deck"
          SequentialAnimation {
            PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: remixDeckComponent            }
            PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active";          value: true                          }
            NumberAnimation { target: rotation;                            property: "angle";           to: content.flipped ? 0 : 180; duration: 100 }
            PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active";          value: false                         }
            PropertyAction  { target: content;                             property: "flipped";         value: !content.flipped                      }
          }
        },
        Transition {
          to: "Stem Deck"
          SequentialAnimation {
            PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: stemDeckComponent            }
            PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active";          value: true                          }
            NumberAnimation { target: rotation;                            property: "angle";           to: content.flipped ? 0 : 180; duration: 100 }
            PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active";          value: false                         }
            PropertyAction  { target: content;                             property: "flipped";         value: !content.flipped              }
          }
        },
        Transition {
          to: "Live Input"
          SequentialAnimation {
            PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: emptyDeckComponent               }
            PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active";          value: true                             }
            NumberAnimation { target: rotation;                            property: "angle";           to:    content.flipped  ? 0 : 180; duration: 100 }
            PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active";          value: false                            }
            PropertyAction  { target: content;                             property: "flipped";         value: !content.flipped                 }
          }
        },
        Transition {
          to: "Direct Thru"
          SequentialAnimation {
            PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: emptyDeckComponent               }
            PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active";          value: true                             }
            NumberAnimation { target: rotation;                            property: "angle";           to:    content.flipped  ? 0 : 180; duration: 100 }
            PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active";          value: false                            }
            PropertyAction  { target: content;                             property: "flipped";         value: !content.flipped                 }
          }
        }
      ]
    }
  }



  // DECK HEADER  -------------------------------------------------------------------------------------------------------

  DeckTypes.DeckHeader {
    id: deckHeader
    anchors.top:   view.top
    anchors.left:  view.left
    anchors.right: view.right
    deck_Id:       view.deckId
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  STATES FOR THE DIFFERENT HEADER SIZES
  //--------------------------------------------------------------------------------------------------------------------

  state: deckSize
  states: [
    State {
      name: "small";
      PropertyChanges { target: deckHeader; headerState: "small"; }
      PropertyChanges { target: flipable;    anchors.topMargin: -3; }
    },
    State {
      name: "medium";
      PropertyChanges { target: deckHeader; headerState: "large"; }
      PropertyChanges { target: flipable;    anchors.topMargin: 0; }
    },
    State {
      name: "large";
      PropertyChanges { target: deckHeader; headerState: "large"; }
      PropertyChanges { target: flipable;    anchors.topMargin: 0; }
    }
  ]
}
