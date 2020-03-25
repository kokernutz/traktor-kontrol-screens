import CSI 1.0
import QtQuick 2.0

import '../../../../Defines' as Defines


// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: quantizeAdjust

  Defines.Margins {id: customMargins }
  property int  deckId: 0


  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: quantize;    path: "app.traktor.decks." + (deckId+1) + ".remix.quant_index"; }
  AppProperty { id: isQuantize;  path: "app.traktor.decks." + (deckId+1) + ".remix.quant"; }

  //--------------------------------------------------------------------------------------------------------------------

  // headline
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        customMargins.topMarginCenterOverlayHeadline
    font.pixelSize:           fonts.largeFontSize
    color:                    colors.colorCenterOverlayHeadline
    text:                     "QUANTIZE"
  }

  // value
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        47
    font.pixelSize:           fonts.superLargeValueFontSize
    font.family:              "Pragmatica"
    color:                    colors.colorWhite    
    text:                     isQuantize.value ? quantize.description : "off"
  }

}
