import QtQuick 2.0;

import '../../../Defines' as Defines


Rectangle {
  id: scrollbar;

  property Flickable flickable:  null
  property color handleColor: colors.colorWhite // set in handle

  //--------------------------------------------------------------------------------------------------------------------

  readonly property real handlePos: flickable.contentY * handle.maximumY / (flickable.contentHeight - flickable.height)

  Defines.Colors { id: colors}

  opacity: 0
  width:   1
  visible: (flickable.visibleArea.heightRatio < 1.0)

  color:                "transparent"
  anchors.top:          parent.top 
  anchors.right:        parent.right 
  anchors.bottom:       parent.bottom 
  anchors.rightMargin:  2
  anchors.topMargin:    17
  anchors.bottomMargin: 17

  
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: handle
    
    readonly property int  margin:   0
    readonly property real minimumY: margin
    readonly property real maximumY: parent.height - height - margin

    y:               Math.max( minimumY , Math.min( maximumY , scrollbar.handlePos ) )
    height:          Math.max(20, (flickable.visibleArea.heightRatio * scrollbar.height))
    radius:          parent.radius
    anchors.left:    parent.left
    anchors.right:   parent.right
    anchors.margins: margin
    color:           parent.handleColor
  }

}