import QtQuick 2.0
import CSI 1.0

Rectangle {
	id: footer
	
  property int            deckId:             0
  property bool           isAnalyzing:        false
  readonly property int   maxHeight:          20
  
  readonly property int   selectedFooterId:   selectedFooterItem.value === undefined ? 0 : selectedFooterItem.value

  readonly property variant knobLabel:    ["OFFSET", "BPM", "FINE", "SCAN"]
  // readonly property variant align:        [Text.AlignLeft, Text.AlignLeft, Text.AlignRight, Text.AlignLeft]
  // readonly property variant align:        [parent.left, parent.left, parent.right, parent.left]
  readonly property variant xPositioning: [9, 129, 324, 369] 
  // readonly property variant margin:       [19, 8, 0, 6]

  height: 20
  color:  colors.colorBgEmpty

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: bpm; path: "app.traktor.decks." + (deckId+1) + ".track.grid.adjust_bpm" }
  MappingProperty { id: selectedFooterItem;      path: propertiesPath + ".selected_footer_item" }
  
  //--------------------------------------------------------------------------------------------------------------------  

  // dividers
  Rectangle { id: line1; visible: !isAnalyzing; width: 1; height: footer.height; color: colors.colorDivider; x: 119 }
  Rectangle { id: line2; visible: !isAnalyzing; width: 1; height: footer.height; color: colors.colorDivider; x: 359 }

  // large BPM value
  Text {
    text:                     (isAnalyzing) ? "analyzing..." : bpm.value.toFixed(2).toString()
    color:                    colors.colorWhite
    font.pixelSize:           fonts.largeValueFontSize
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter:   parent.verticalCenter
    anchors.verticalCenterOffset:        1
  }

  
  Repeater {
    model: 4
    // labels
    Text {
      id: text

      text:                   knobLabel[index]
      width:                  footer.width/4 - 12         // 3px space left and right
      x:                      xPositioning[index]
      y:                      7
      color:                  (selectedFooterId - 1) == index ? "white" : colors.colorFontFxHeader
      font.pixelSize:         fonts.smallFontSize
      visible:                !isAnalyzing;

      // x:                      index * footer.width/4 + 6  // 3px because of the space
      // horizontalAlignment:    align[index]
      // verticalAlignment:      Text.AlignTop
      // anchors.verticalCenterOffset: 20
      // anchors.horizontalCenterOffset:     margin[index]            // TODO Work in progress...
      // anchors.horizontalCenter: align[index]


      // Used to underline the current footer
      Rectangle {
        id: underline

        anchors.top: text.bottom
        anchors.topMargin: -1
        anchors.left: text.left
        width: text.paintedWidth

        color: "white"
        height: 1
        visible: { (selectedFooterId - 1) == index ? true : false }
      }      
    }

  }

}
