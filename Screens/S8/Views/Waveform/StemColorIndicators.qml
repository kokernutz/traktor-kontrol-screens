import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects
import Traktor.Gui 1.0 as T

import '../Widgets' as Widgets
import '../../../../Defines'


Item {
  id: view
  
  property int deckId
  readonly property int stemCount:  4
  readonly property var stemColors: ["green", "blue", "red", "orange"]
  property int  stemStyle:    StemStyle.track

  property var indicatorHeight: [36 , 36 , 36 , 36]
 
  //--------------------------------------------------------------------------------------------------------------------
  // There is one pixel space between the color-indicator-rectangles. In this space, you can see the beatgrid/cuePoints, 
  // which is not what we want. Therefore I added this Rectalgles in the same color as the backgroud. This rectangles hide
  // the beatgrid/cuePoints. 
  Rectangle { x: 0;                  y: 0; width: 3; height: view.height; color: colors.colorBlack }
  Rectangle { x: view.width - width; y: 0; width: 3; height: view.height; color: colors.colorBlack }

  //--------------------------------------------------------------------------------------------------------------------

  function indicatorY(index) {
    var y = 0;
    for (var i=0; i<index; ++i) {
      y = y + indicatorHeight[i] + 1;
    }
    return y;
  }

  Repeater {
    model: stemCount 

    Item {
      property color stemColor: colors.palette(1.0, stemColorId.value)
      AppProperty { id: stemColorId; path: "app.traktor.decks." + (deckId + 1) + ".stems." + (index + 1) + ".color_id" }

      width:  view.width;              x: 0  
      height: indicatorHeight[index];  y: indicatorY(index)

      Rectangle {
        id: colorRect1
        width:  3
        height: indicatorHeight[index]
        color:  stemColor
      }
      Rectangle {
        width:1
        height: indicatorHeight[index]
        anchors.left: colorRect1.right
        anchors.top: colorRect1.top
        color: "black"
      }
      Rectangle {
        id: colorRect2
        x:      view.width - width; 
        width:  3 
        height: indicatorHeight[index]
        color:  stemColor
      }
      Rectangle {
        width:1
        height: indicatorHeight[index]
        anchors.right: colorRect2.left
        anchors.top: colorRect2.top
        color: "black"
      }
    }
  }

}
