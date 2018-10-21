import QtQuick 2.5
import QtQuick.Layouts 1.1
import '../Views'

//----------------------------------------------------------------------------------------------------------------------
//  Remix Deck Overlay - for sample volume and filter value editing
//----------------------------------------------------------------------------------------------------------------------


Item {
  id: display
  Colors {id: colors}
  Dimensions {id: dimensions}
  
  // MODEL PROPERTIES //
  property var    deckInfo: ({})
  property int    slotId:    1 //shoudl be always a valid slot

  // fetch data
  property var    slot:           deckInfo.getSlot(slotId)
  property var    activeCellIdx:  slot.activeCellIdx

  property var    activeCell:     slot.getCell(activeCellIdx)

  width  : 320
  height : 240
 
  // LAYOUT + DESIGN //

  property real infoBoxesWidth:   dimensions.infoBoxesWidth
  property real firstRowHeight:   dimensions.firstRowHeight
  property real secondRowHeight:  dimensions.secondRowHeight
  property real remixCellWidth:   dimensions.thirdRowHeight
  property real screenTopMargin:  dimensions.screenTopMargin
  property real screenLeftMargin: dimensions.screenLeftMargin

  property real boxesRadius:  5
  property real cellSpacing:  dimensions.spacing
  property real textMargin:   13

  property variant lightGray: colors.colorDeckGrey
  property variant darkGray:  colors.colorDeckDarkGrey

  ColumnLayout 
  {
    spacing: display.cellSpacing
    anchors.top: parent.top
    anchors.topMargin: display.screenTopMargin
    anchors.left: parent.left
    anchors.leftMargin: display.screenLeftMargin

    DeckHeader
    {
      title:  display.activeCell.name
      height: display.firstRowHeight
      width:  2*display.infoBoxesWidth + display.cellSpacing
    }

    RowLayout
    {
      spacing: display.cellSpacing

      // VOLUME LABEL //
      Rectangle {

        height: display.firstRowHeight
        width:  display.infoBoxesWidth

        color: !display.slot.muted ? display.activeCell.midColor : colors.darkerColor(display.activeCell.midColor, 0.5)
        radius: display.boxesRadius

        Text {
          text: "Volume"
          font.pixelSize: 24
          font.family: "Roboto"
          font.weight: Font.Normal
          color: !display.slot.muted ? "white" : "grey"
          anchors.fill: parent
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      // FILTER LABEL //
      Rectangle {
        
        height: display.firstRowHeight
        width:  display.infoBoxesWidth

        color:  display.slot.filterOn ? display.activeCell.midColor : colors.darkerColor(display.activeCell.midColor, 0.5)
        radius: display.boxesRadius

        Text {
          text: "Filter"
          font.pixelSize: 24
          font.family: "Roboto"
          font.weight: Font.Normal
          color: display.slot.filterOn ? "white" : "grey"
          anchors.verticalCenter: parent.verticalCenter
          anchors.rightMargin: display.textMargin
          anchors.leftMargin:  display.textMargin
          anchors.fill: parent
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
        
      }
    }

    RowLayout
    {
      spacing: display.cellSpacing
      
      // VOLUME SLIDER //
      Slider
      {
        width : display.infoBoxesWidth
        height: display.secondRowHeight
        min: 0
        max: 1
        value: display.slot.volume
        radius: dimensions.cornerRadius

        backgroundColor:  !display.slot.muted ? display.activeCell.midColor : colors.darkerColor(display.activeCell.midColor, 0.5)
        sliderColor:      !display.slot.muted ? display.activeCell.brightColor : display.activeCell.midColor
        cursorColor:      !display.slot.muted ? "white" : "grey"

      }

      // FILTER SLIDER //
      Slider
      {
        width : display.infoBoxesWidth
        height: display.secondRowHeight

        value: display.slot.filterValue
        min: 0
        max: 1
        centered: true
        radius: dimensions.cornerRadius  

        backgroundColor:  display.slot.filterOn ? display.activeCell.midColor : colors.darkerColor(display.activeCell.midColor, 0.5)
        sliderColor:      display.slot.filterOn ? display.activeCell.brightColor : display.activeCell.midColor
        cursorColor:      display.slot.filterOn ? "white" : "grey"
        centerColor:      colors.defaultBackground
      }
    }
  }
}
