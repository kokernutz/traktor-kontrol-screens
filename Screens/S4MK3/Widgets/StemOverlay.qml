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

  Rectangle
  {
    width:  display.width
    height: 2*display.firstRowHeight + display.secondRowHeight + 3*display.cellsSpacing
    color:        colors.defaultBackground
  }

  ColumnLayout 
  {
    spacing: display.cellSpacing
    anchors.top: parent.top
    anchors.topMargin: display.screenTopMargin
    anchors.left: parent.left
    anchors.leftMargin: display.screenLeftMargin

    DeckHeader
    {
      title:  display.deckInfo.stemSelectedName
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

        color: display.deckInfo.isStemsActive ? (!display.deckInfo.stemSelectedMuted ? display.deckInfo.stemSelectedMidColor : colors.darkerColor(display.deckInfo.stemSelectedMidColor, 0.5) ) : "grey"
        radius: display.boxesRadius

        Text {
          text: "Volume"
          font.pixelSize: 24
          font.family: "Roboto"
          font.weight: Font.Normal
          color: display.deckInfo.isStemsActive ? (!display.deckInfo.stemSelectedMuted ? "white" : "grey" ) : "grey"
          anchors.fill: parent
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      // FILTER LABEL //
      Rectangle {
        
        height: display.firstRowHeight
        width:  display.infoBoxesWidth

        color:  display.deckInfo.isStemsActive ? (display.deckInfo.stemSelectedFilterOn ? display.deckInfo.stemSelectedMidColor : colors.darkerColor(display.deckInfo.stemSelectedMidColor, 0.5) ) : "grey"
        radius: display.boxesRadius

        Text {
          text: "Filter"
          font.pixelSize: 24
          font.family: "Roboto"
          font.weight: Font.Normal
          color: display.deckInfo.isStemsActive ? (display.deckInfo.stemSelectedFilterOn ? "white" : "grey" ) : "grey"
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
        value: display.deckInfo.isStemsActive ? display.deckInfo.stemSelectedVolume : 0.5
        radius: dimensions.cornerRadius

        backgroundColor:  display.deckInfo.isStemsActive ? (!display.deckInfo.stemSelectedMuted ? display.deckInfo.stemSelectedMidColor : colors.darkerColor(display.deckInfo.stemSelectedMidColor, 0.5) ) : "grey"
        sliderColor:      display.deckInfo.isStemsActive ? (!display.deckInfo.stemSelectedMuted ? display.deckInfo.stemSelectedBrightColor : display.deckInfo.stemSelectedMidColor ) : "red"
        cursorColor:      display.deckInfo.isStemsActive ? (!display.deckInfo.stemSelectedMuted ? "white" : "grey" ) : "grey"

      }

      // FILTER SLIDER //
      Slider
      {
        width : display.infoBoxesWidth
        height: display.secondRowHeight

        value: display.deckInfo.isStemsActive > 0 ? display.deckInfo.stemSelectedFilterValue : 0
        min: 0
        max: 1
        centered: true
        radius: dimensions.cornerRadius  

        backgroundColor:  display.deckInfo.isStemsActive ? (display.deckInfo.stemSelectedFilterOn ? display.deckInfo.stemSelectedMidColor : colors.darkerColor(display.deckInfo.stemSelectedMidColor, 0.5) ) : "grey"
        sliderColor:      display.deckInfo.isStemsActive ? (display.deckInfo.stemSelectedFilterOn ? display.deckInfo.stemSelectedBrightColor : display.deckInfo.stemSelectedMidColor ) : "red"
        cursorColor:      display.deckInfo.isStemsActive ? (display.deckInfo.stemSelectedFilterOn ? "white" : "grey" ) : "grey"
        centerColor:      colors.defaultBackground
      }
    }
  }
}
