import QtQuick 2.5
import QtQuick.Layouts 1.1
import "../Views"
import "../ViewModels"

//----------------------------------------------------------------------------------------------------------------------
//  Remix Deck Overlay - for sample volume and filter value editing
//----------------------------------------------------------------------------------------------------------------------


Item {
  id: display

  //to be set when using the object
  property var    deckInfo: ({})
  property int    slotId:    1

  property var slot: deckInfo.getSlot(slotId)
  property int activeCellIdx: slot.activeCellIdx

  property var topCell:    slot.getCell( activeCellIdx - 1)
  property var middleCell: slot.getCell( activeCellIdx )
  property var bottomCell: slot.getCell( activeCellIdx + 1)

  function isValid( cell )      { return typeof cell !== "undefined"; }
  function isActiveCell( cell ) { if(isValid(cell)) return cell.cellId == slot.activeCellIdx; return false; }
  function getName( cell )      { 
    if(isValid(cell)) {
      return getIsEmpty(cell) ? "Cell " + cell.cellId : cell.name;
    }
    return "Empty cell ";
  }
    
  function getIsLoop( cell )    { if(isValid(cell)) return cell.isLooped;  return ""; }
  function getColor( cell )     { if(isValid(cell)) return cell.color; return "grey"; }
  function getIsEmpty( cell )   { if(isValid(cell)) return cell.isEmpty; return true;}
  function getIconColor( cell ) {
    if(isValid(cell)) {
      return getIsEmpty( cell ) ? colors.colorDeckBrightGrey : getColor( cell );  
    }
    return colors.defaultBackground;
  }

  Colors {id: colors}
  Dimensions {id: dimensions}

  width  : 320
  height : 240

  // LAYOUT + DESIGN //

  property real infoBoxesWidth:   dimensions.infoBoxesWidth
  property real secondRowHeight:  dimensions.secondRowHeight
  property real remixCellWidth:   dimensions.thirdRowHeight
  property real screenTopMargin:  dimensions.screenTopMargin + 4
  property real screenLeftMargin: dimensions.screenLeftMargin 

  property real boxesRadius:  dimensions.cornerRadius
  property real cellSpacing:  dimensions.spacing
  property real textMargin:   9

  property variant lightGray: colors.colorDeckGrey
  property variant darkGray:  colors.colorDeckDarkGrey

  Rectangle
  {
    width: display.width
    height: display.height
    color: colors.defaultBackground


    Column 
    {
      spacing: display.cellSpacing 
      anchors.top: parent.top
      anchors.topMargin: display.screenTopMargin
      anchors.left: parent.left
      anchors.leftMargin: display.screenLeftMargin

      Repeater {
        model: [display.topCell, display.middleCell, display.bottomCell]

        Rectangle
        {
          height:   display.remixCellWidth
          width:    dimensions.largeBoxWidth
          radius:   dimensions.cornerRadius
          color:    isActiveCell(modelData) ? colors.colorDeckGrey : colors.defaultBackground

          Row
          {
            spacing: display.textMargin
            visible:  isValid( modelData )

            RemixCell
            {
              cellColor                   : getIconColor( modelData )
              cellRadius                  : display.boxesRadius 
              cellSize                    : display.remixCellWidth
              isLoop                      : getIsLoop( modelData ) 
              withIcon                    : !getIsEmpty( modelData )
            }

            Text { 
              text: getName(modelData)
              font.pixelSize: 24
              font.family: "Roboto"
              font.weight: Font.Normal
              color: "white"
              anchors.verticalCenter: parent.verticalCenter
            }
          }
        }
      }
    }
  }
}
