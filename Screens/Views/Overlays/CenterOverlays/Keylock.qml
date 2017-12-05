import QtQuick 2.0
import CSI 1.0

import './../../Definitions/' as Definitions


// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: keylock

  property int  deckId:    0

  Definitions.Margins {id: customMargins }


  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: keyValue;   path: "app.traktor.decks." + (deckId+1) + ".track.key.adjust" }
  AppProperty { id: keyEnable;  path: "app.traktor.decks." + (deckId+1) + ".track.key.lock_enabled" }
  AppProperty { id: keyDisplay; path: "app.traktor.decks." + (deckId+1) + ".track.key.key_for_display" }

  property real key:    keyValue.value * 12
  property int  offset: (key.toFixed(2) - key.toFixed(0)) * 100.0

  //--------------------------------------------------------------------------------------------------------------------

  // headline
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        customMargins.topMarginCenterOverlayHeadline
    font.pixelSize:           fonts.largeFontSize
    color:                    colors.colorCenterOverlayHeadline
    text:                     "KEY"
  }

  // button
  Rectangle {
    anchors.top:              parent.top
    anchors.left:             parent.left
    anchors.topMargin:        67
    anchors.leftMargin:       21
    width: 43
    height: 17
    color: (keyEnable.value) ? "white" : "black"
    radius: 1

    Text {
      anchors.centerIn: parent
      anchors.verticalCenterOffset: 1
      anchors.horizontalCenterOffset: -1
      font.pixelSize: fonts.smallFontSize     
      text: "LOCK"
      color: (keyEnable.value) ? colors.colorBlack : colors.colorGrey104
    }
  }

  // value
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        55
    font.pixelSize:           fonts.extraLargeValueFontSize
    font.family   :           "Pragmatica"
    color:                    colors.colorWhite    
  	text:  ((key<0)?"":"+") + key.toFixed(2).toString()
  }

  // key
  Text {
    anchors.top:              parent.top
    anchors.right:            parent.right
    anchors.topMargin:        67
    anchors.rightMargin:      20
    font.pixelSize:           fonts.largeFontSize
    font.family   :           "Pragmatica"
    font.capitalization: Font.AllUppercase
    color:                    colors.colorGrey104
    opacity: (keyDisplay.value=="") ? 0 : 1
    text:    "(" + keyDisplay.value + ((offset==0)?"":" ") + ")"
  }
  
  // footline
  Text {
    anchors.bottom:           parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin:     14.0
    font.pixelSize:           fonts.smallFontSize
    color:                    colors.colorGrey104
    text:                     "Hold BACK to reset"
  }
  
}
