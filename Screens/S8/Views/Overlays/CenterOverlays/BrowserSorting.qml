import QtQuick 2.0
import CSI 1.0

import '../../../../Defines' as Defines

CenterOverlay {
  id: tempoAdjust
  
  property int  deckId:    0

  Defines.Margins {id: customMargins }

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: propSortId;   path: "app.traktor.browser.sort_id" }

  function getText(id) {
    // the given numbers are determined by the EContentListColumns in Traktor
    switch (id) {
      case 0:   return "#"
      case 2:   return "TITLE"
      case 3:   return "ARTIST"
      case 5:   return "BPM"
      case 28:  return "KEY"
      case 22:  return "RATING"
      case 27:  return "IMPORT DATE"
      default:  break;
    }
    return "SORTED"
  }


  //--------------------------------------------------------------------------------------------------------------------

  // headline
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        11
    font.pixelSize:           fonts.largeFontSize
    color:                    colors.colorCenterOverlayHeadline
    text:                     "SORT BY"
  }

  // value
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        (text.length < 10) ? 45 : 53
    font.pixelSize:           (text.length < 10) ? fonts.extraLargeValueFontSize : fonts.moreLargeValueFontSize
    color:                    colors.colorWhite    
    text:  getText( propSortId.value ) 
  }
}
