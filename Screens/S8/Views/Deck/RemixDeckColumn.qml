import CSI 1.0
import QtQuick 2.0
import Traktor.Gui 1.0 as Traktor

import '../Widgets' as Widgets
import '../../../Defines' as Defines

//--------------------------------------------------------------------------------------------------------------------
// The REMIX DECK COLUMN provides the content of one column of the remix deck in all of its states.
// The columns are put together to a complete Remix Deck in RemixDeck.qml. 
// Each component of the Column anchors at the bottom of the previous Item! 
//--------------------------------------------------------------------------------------------------------------------

Item {  
  id: root
  property bool   sequencerMode: false
  property int    deckId
  property int    rowShift:              1
  property string deck_position: (deckId < 2) ? ".top" : ".bottom"

  onRowShiftChanged: { if (root.rowShift != remixDeck.rowShift) {  root.rowShift = remixDeckRowShift } }
  property int    activeSampleYPosition: 0
  property alias  sampleRowState: sampleRowShift.state

  // Use the colorId of the active cell to define the color of the indicator bars and the headlines.
  // The Sample Cell colors are set in RemixSample
  property color  brightColor:          colors.palette(1.0, activeCellColorId.value)

  // These properties are necessary to establish the connections to traktor AppProperties
  property string remixPath:            "app.traktor.decks.1.remix."   // default value
  property string playerPropertyPath:   "app.traktor.decks.1.remix.players.1"   // default value
  property string columnPropertyPath:   "app.traktor.decks.1.remix.cell.columns.1"     // default value
  property string activeSamplePath:     "app.traktor.decks.1.remix.cell.columns.1.rows.1" // default value

  Defines.Colors { id: colors }

  //--------------------------------------------------------------------------------------------------------------------
  // colorId of the active cell and name of the currently active sample are extracted from traktor
  
  AppProperty { id: activeCellColorId;  path: activeSamplePath + ".color_id" }
  AppProperty { id: sampleName;         path: activeSamplePath + ".name"     }
  AppProperty { id: playingState;       path: activeSamplePath + ".state"    }

  MappingProperty { id: sequencer_slot; path: propertiesPath + deck_position + ".sequencer_deck_slot";  }
  MappingProperty { id: sequencer_page; path: propertiesPath + deck_position + ".sequencer_deck_page";  }
  
  //--------------------------------------------------------------------------------------------------------------------

  // Sample Deck Container
  Item {
    id: remixSampleContainer
    clip:   true
    anchors.top:   remixDeckWaveform.bottom
    anchors.left:  parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.topMargin: 7
    anchors.bottomMargin: 3
    visible: !sequencerMode
    Behavior on anchors.topMargin { NumberAnimation { duration: durations.deckTransition  } }

    Column { // the two samples shown in one column of the remix deck view
      id: remixDeckSamples
      // property int yShift: 7
      anchors.fill: parent
      anchors.topMargin: 0
      spacing: 1
      clip: true

      // first and second Sample cell in this column
      Repeater {
        id: sampleColumn
        model: 2
        RemixSample {
          id: sample1;
          visible: !sequencerMode
          height: remixSampleContainer.height/2 - remixDeckSamples.spacing;
          anchors.topMargin: 0;
          samplePropertyPath: columnPropertyPath + ".rows." +  (rowShift + index);
        }
      }
    }
  }

  StepSequencer {
    anchors.top:           remixDeckWaveform.bottom
    anchors.left:          parent.left
    anchors.right:         parent.right
    anchors.bottom:        parent.bottom
    anchors.topMargin:     1
    anchors.bottomMargin:  1
    visible:               sequencerMode && (root.state != "small")

    selected:              sequencerMode && (sequencer_slot.value - 1 == index)

    clip:                  true
    playerPropertyPath:    root.playerPropertyPath
    activeSamplePath:      root.activeSamplePath

    remixDeckPropertyPath: root.remixPath
  }

  //--------------------------------------------------------------------------------------------------------------------

  // color bar above the waveform showing the currently active cell
  Rectangle {
    id: remixDeckPlayIndicatorTop
    anchors.top: remixDeckHeadline.bottom
    anchors.topMargin: 3 /* set in state */
    width: 111
    height: 3
    color: brightColor
    Behavior on anchors.topMargin { NumberAnimation { duration: durations.deckTransition } }
  }

  Traktor.Polygon {
    id : arrowDownBg
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom:           remixDeckPlayIndicatorTop.bottom
    anchors.bottomMargin:    -2
    points:                   [ Qt.point(0, 0), Qt.point(8.5, 0) , Qt.point(4, 4.5)]
    color:                    brightColor

    border.width:             3
    border.color:             colors.colorBlack

    antialiasing:             false
    visible:                  !sequencerMode && ((rowShift - 1 > activeSampleYPosition) && (playingState.description == "Playing")) ? true : false
    rotation:                 180
  }

  // upwards indicator (for playing deck out of focus)
  Traktor.Polygon {
    id : arrowUpBg
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom:           remixDeckPlayIndicatorTop.bottom
    anchors.bottomMargin:    -3
    points:                   [ Qt.point(0, 0), Qt.point(8.5, 0) , Qt.point(4, 4.5)]
    color:                    brightColor
    border.width:             3
    border.color:             colors.colorBlack
    antialiasing:             false
    visible:                  !sequencerMode && ((rowShift < activeSampleYPosition) && (playingState.description == "Playing")) ? true : false
  }


  //--------------------------------------------------------------------------------------------------------------------

  Item { // the headline of the player column. Only shown in "large" state
    id: remixDeckHeadline

    anchors.top: parent.top
    height: 12 // set in state
    width: 111
    clip: true

    Text {
      anchors.fill: parent;
      text: sampleName.description;
      color: brightColor;
      font.pixelSize: fonts.scale(12);
      font.capitalization: Font.AllUppercase
      elide: Text.ElideRight
    }
    Behavior on height { NumberAnimation { duration: durations.deckTransition } }
  }


  //--------------------------------------------------------------------------------------------------------------------

  RemixStripe { // the remix player waveform with position indicator
    id: remixDeckWaveform
    readonly property int smallHeigth: 24
    readonly property int bigHeight: 65
    anchors.top: remixDeckPlayIndicatorTop.bottom
    anchors.topMargin: 1 // pixel between waveform stripe and top indicator bar
    width: 111;
    height: smallHeigth; // set in state
    xPosition: index + 1;
    deckId: root.deckId
    propertyPath: playerPropertyPath
    Behavior on height { NumberAnimation { duration: durations.deckTransition } }
    Behavior on anchors.topMargin { NumberAnimation { duration: durations.deckTransition } }
  }

  //--------------------------------------------------------------------------------------------------------------------

  Item {
    id: sampleRowShift
    state: "Unchanged"
    states: [
      State {
        name: "Unchanged"
      },
      State {
        name: "Increased"
      },
      State {
        name: "Decreased"
      }
    ]
    transitions: [
      Transition {
        to: "Increased"
        SequentialAnimation {
          NumberAnimation { target: sampleColumn; property: "model"; to: 4 ; duration: 0}
          NumberAnimation { target: remixDeckSamples; property: "anchors.topMargin"; from: 0; to: -remixSampleContainer.height; duration: durations.deckTransition }
          ParallelAnimation {
            NumberAnimation { target: sampleColumn; property: "model"; to: 2 ; duration: 0}
            NumberAnimation { target: remixDeckSamples; property: "anchors.topMargin"; to: 0 ; duration: 0}
          }
          PropertyAction  { target: root; property: "rowShift"; value: (root.rowShift < 15) ? (root.rowShift + 2) : root.rowShift }
        }
      },
      Transition {
        to: "Decreased"
        SequentialAnimation {
          PropertyAction  { target: root; property: "rowShift"; value: (root.rowShift > 2) ? (root.rowShift - 2) : root.rowShift}
          NumberAnimation { target: sampleColumn; property: "model"; to: 4 ; duration: 0}
          NumberAnimation { target: remixDeckSamples; property: "anchors.topMargin"; from: -remixSampleContainer.height; to: 0; duration: durations.deckTransition }
          ParallelAnimation {
            NumberAnimation { target: sampleColumn; property: "model"; to: 2 ; duration: 0}
            NumberAnimation { target: remixDeckSamples; property: "anchors.topMargin"; to: 0 ; duration: 0}
          }
        }
      }
    ]
  }

  Rectangle
  {
    id: sequencerFrame
    anchors.fill:parent
    anchors.topMargin: 15
    anchors.bottomMargin: 1
    color: "transparent"
    border.width:1
    border.color: brightColor
    visible: sequencerMode && (sequencer_slot.value - 1 == index)
  }

  //--------------------------------------------------------------------------------------------------------------------

  state: "small"
  states: [
    State {
      name: "small"
      PropertyChanges {target: remixDeckWaveform; height: remixDeckWaveform.smallHeigth}
      PropertyChanges {target: remixSampleContainer; height: 0; visible: false}
      PropertyChanges {target: remixDeckHeadline; height: 0}
      PropertyChanges {target: remixDeckPlayIndicatorTop; anchors.topMargin: 6}
      PropertyChanges {target: sequencerFrame; anchors.topMargin: 0}
    },
    State {
      name: "medium"
      PropertyChanges {target: remixDeckWaveform; height: remixDeckWaveform.smallHeigth; anchors.topMargin: 1}
      PropertyChanges {target: remixSampleContainer; anchors.topMargin: 6; visible: true}
      PropertyChanges {target: remixDeckHeadline; height: 0}
      PropertyChanges {target: remixDeckPlayIndicatorTop; anchors.topMargin: 1}
      PropertyChanges {target: sequencerFrame; anchors.topMargin: 0}
    },
    State {
      name: "large"
      PropertyChanges {target: remixDeckWaveform; height: remixDeckWaveform.bigHeight; anchors.topMargin: 3}
      PropertyChanges {target: remixSampleContainer; anchors.topMargin: 7; visible: true}
      PropertyChanges {target: remixDeckHeadline; height: 12}
      PropertyChanges {target: remixDeckPlayIndicatorTop; anchors.topMargin: 3}
      PropertyChanges {target: sequencerFrame; anchors.topMargin: 15}
    }
  ]
}
