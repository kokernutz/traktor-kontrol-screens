import CSI 1.0
import QtQuick 2.0

import '../../../../Defines' as Defines

// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: captureSource

  Defines.Margins { id: customMargins }

  property int  deckId:    0

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: captureSrcIndex; path: "app.traktor.decks." + (deckId+1) + ".capture_source"; }

  //--------------------------------------------------------------------------------------------------------------------

  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        customMargins.topMarginCenterOverlayHeadline
    font.pixelSize:           fonts.largeFontSize
    color:                    colors.colorCenterOverlayHeadline
    text:                     "CAPTURE"
  }

  Text {
    anchors.top:              parent.top
  	anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        39
  	font.pixelSize:           fonts.superLargeValueFontSize
    font.capitalization:      Font.AllUppercase
  	color:                    (deckId > 1) ? colors.colorWhite : colors.colorDeckBlueBright
    text:                     captureSrcIndex.description
  }

}
