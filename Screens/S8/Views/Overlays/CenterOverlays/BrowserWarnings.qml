import QtQuick 2.0
import CSI 1.0

import '../../../../Defines' as Defines


// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: browserWarning

  property int  deckId: 0

  Defines.Margins {id: customMargins }

  AppProperty { id: warningMessage;      path: "app.traktor.informer.deck_loading_warnings." + (deckId+1) + ".long"  }
  AppProperty { id: warningMessageShort; path: "app.traktor.informer.deck_loading_warnings." + (deckId+1) + ".short" }

  //--------------------------------------------------------------------------------------------------------------------

// the dynamic textfields are put into an item that will adjust it's height to the text-content. it will always be centered this way.

Item {
  // anchors.fill:             parent.fill
  anchors.horizontalCenter:   parent.horizontalCenter
  anchors.verticalCenter:     parent.verticalCenter
  width:                      parent.width
  height:                     headline.height + text.paintedHeight + text.anchors.topMargin

  // headline
  Text {
    id:                       headline
    width:                    parent.width - 20
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    font.pixelSize:           fonts.largeFontSize
    wrapMode:                 Text.WordWrap
    horizontalAlignment:      Text.AlignHCenter
    color:                    colors.colorOrange
    text:                     warningMessageShort.value
    font.capitalization:      Font.AllUppercase

  }

  // message
  Text {
    id: text
    width:                    parent.width - 20
    anchors.top:              headline.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        4
    font.pixelSize:           fonts.middleFontSize
    wrapMode:                 Text.WordWrap
    horizontalAlignment:      Text.AlignHCenter
    color:                    colors.colorOrange
  	text:                     warningMessage.value
  }
}


}
