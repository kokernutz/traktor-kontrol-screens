import QtQuick 2.5
import QtQuick.Layouts 1.1

import '../Widgets' as Widgets

//----------------------------------------------------------------------------------------------------------------------
//  Track Screen View - UI of the screen for track
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: display
  Dimensions {id: dimensions}

  // MODEL PROPERTIES //
  property var deckInfo: ({})
  property real boxesRadius:      dimensions.cornerRadius
  property real infoBoxesWidth:   dimensions.infoBoxesWidth
  property real firstRowHeight:   dimensions.firstRowHeight
  property real secondRowHeight:  dimensions.secondRowHeight
  property real spacing:          dimensions.spacing
  property real screenTopMargin:  dimensions.screenTopMargin
  property real screenLeftMargin: dimensions.screenLeftMargin

  width  : 320
  height : 240

  Rectangle
  {
    id: displayBackground
    anchors.fill : parent
    color: colors.defaultBackground
  }

  ColumnLayout
  {
    id: content
    spacing: display.spacing
    
    anchors.left:       parent.left
    anchors.top:        parent.top
    anchors.topMargin:  display.screenTopMargin
    anchors.leftMargin: display.screenLeftMargin

    // DECK HEADER //
    Widgets.DeckHeader
    {
      id: deckHeader

      title:  deckInfo.titleString
      height: display.firstRowHeight
      width:  2*display.infoBoxesWidth + display.spacing
    }

    // FIRST ROW //
    RowLayout {
      id: firstRow

      spacing: display.spacing

      // BPM DISPLAY //
      Rectangle {
        id: bpmBox
        height: display.firstRowHeight
        width:  display.infoBoxesWidth

        border.width: 2
        border.color: colors.colorDeckDarkGrey
        color: colors.defaultBackground
        radius: display.boxesRadius

        Text {
          text: deckInfo.bpmString
          font.pixelSize: 24
          font.family: "Roboto"
          font.weight: Font.Normal
          color: "white"
          anchors.fill: parent
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      // KEY DISPLAY //
      Item {
          id: keyDisplay

          property var keyColor: deckInfo.hasKey ? colors.musicalKeyColors[deckInfo.resultingKeyIdx] : colors.colorBlack

          // key box background color
          property var bgKeyOn: deckInfo.hasKey ? colors.opacity( keyColor, 0.3 ) : colors.opacity( colors.colorEnabledCyan, 0.7 )
          property var bgKeyOnShift: deckInfo.hasKey ? colors.opacity( keyColor, 0.5 ) : colors.opacity( colors.colorEnabledCyan, 1.0 )
          property var bgKeyOff: colors.colorDeckDarkGrey
          property var bgKeyOffShift: colors.colorDeckGrey
          property var backgroundColor: deckInfo.isKeyLockOn ? ( deckInfo.shift ? bgKeyOnShift   : bgKeyOn  ) :
                                                               ( deckInfo.shift ? bgKeyOffShift  : bgKeyOff )

          // key text color
          property var textColor: deckInfo.isKeyLockOn ? keyColor : colors.colorWhite

          // key text string
          readonly property real keyAdjustThreshold: 0.01
          property bool isKeyAdjusted: deckInfo.isKeyLockOn && Math.abs(deckInfo.keyAdjustVal) > keyAdjustThreshold
          property string keyLabelStr: deckInfo.hasKey ?
                                           // Has Key
                                           ( deckInfo.resultingKeyStr  + ( isKeyAdjusted && deckInfo.shift ? "  " + deckInfo.keyAdjustIntText : "" ) ) :
                                           // Has No Key
                                           ( isKeyAdjusted ? deckInfo.keyAdjustFloatText : "No key" )

          height: display.firstRowHeight
          width:  display.infoBoxesWidth

          Rectangle {
            id: keyBackground
            color: keyDisplay.backgroundColor
            radius: display.boxesRadius
            anchors.fill: parent
          }

          Text {
            id: keyText
            text: keyDisplay.keyLabelStr
            font.pixelSize: 24
            font.family: "Roboto"
            color: keyDisplay.textColor
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
          }
      }


    } // first row


    // SECOND ROW //
    RowLayout {
      id: secondRow
      spacing: display.spacing

      // TIME DISPLAY //
      Item {
        id: timeBox
        width : display.infoBoxesWidth
        height: display.secondRowHeight

        Rectangle {
          anchors.fill: parent
          color:  trackEndBlinkTimer.blink ? colors.colorRed : colors.colorDeckGrey
          radius: display.boxesRadius
        }

        Text {
          text: deckInfo.remainingTimeString
          font.pixelSize: 45
          font.family: "Roboto"
          color: trackEndBlinkTimer.blink ? "black": "white"
          anchors.fill: parent
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }

        Timer {
          id: trackEndBlinkTimer
          property bool  blink: false

          interval: 500
          repeat:   true
          running:  deckInfo.trackEndWarning

          onTriggered: {
            blink = !blink;
          }

          onRunningChanged: {
            blink = running;
          }
        }
      }

      // LOOP DISPLAY //
      Item {
        id: loopBox
        width : display.infoBoxesWidth
        height: display.secondRowHeight

        Rectangle {
          anchors.fill: parent
          color: deckInfo.loopActive ? (deckInfo.shift ? colors.loopActiveDimmedColor : colors.loopActiveColor) : (deckInfo.shift ? colors.colorDeckDarkGrey : colors.colorDeckGrey ) 
          radius: display.boxesRadius
          }

        Text {
          text: deckInfo.loopSizeString
          font.pixelSize: 45
          font.family: "Roboto"
          color: deckInfo.loopActive ? "black" : ( deckInfo.shift ? colors.colorDeckGrey : colors.defaultTextColor )
          anchors.fill: parent
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      

    } // second row

    // STRIPE //
    Widgets.Stripe
    {
      deckId:  deckInfo.deckId - 1 // stripe uses zero based indices.
      visible: deckInfo.isLoaded

      // we apply -3 on the height and +3 on the topMargin,
      //because Widgets.Stripes has elements (the cues) that are
      //not taken into the height of the Stripe. They are 3pix outside
      //of the stripe.
      height: display.secondRowHeight
      width:  2*display.infoBoxesWidth + display.spacing - 6
      Layout.leftMargin: 6


      hotcuesModel: deckInfo.hotcues
      trackLength:  deckInfo.trackLength
      elapsedTime:  deckInfo.elapsedTime
      audioStreamKey: ["PrimaryKey", deckInfo.primaryKey]
    }

  }




}
