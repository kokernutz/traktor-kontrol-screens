import QtQuick 2.0

Item {
  id: trackRating

  property int              rating: 0
  property color            bigLineColor:   colors.colorWhite // set from outside
  property color            smallLineColor: colors.colorWhite // set from outside  
  readonly property variant ratingMap:      { '-1' : 0, '0' : 0, '51': 1, '102': 2, '153' : 3, '204' : 4, '255': 5 }
  readonly property int     nrRatings: 5

  width:  20
  height: 13
  
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: largeLineContainer
    anchors.left:           parent.left
    anchors.verticalCenter: parent.verticalCenter
    height:                 parent.height
    width:                  rowLarge.width + 2
    color:                  colors.colorBlack28
    visible:                trackRating.rating > 0 // -1 is also possible if rating has never been set!
    Row {
      id: rowLarge
      anchors.left:       parent.left
      anchors.top:        parent.top
      anchors.leftMargin: 1
      height:             parent.height
      spacing:            2
      Repeater {
        model: (ratingMap[trackRating.rating] === undefined) ? 0 : ratingMap[trackRating.rating]
        Rectangle {
          width:                  2
          height:                 largeLineContainer.height - 2
          anchors.verticalCenter: rowLarge.verticalCenter
          color:                  trackRating.bigLineColor 
        }
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: smallLineContainer
    anchors.right:          parent.right
    anchors.verticalCenter: parent.verticalCenter
    height:                 parent.height  - 8
    width:                  rowSmall.width + 2
    color:                  colors.colorBlack28
    visible:                ratingMap[trackRating.rating] < nrRatings

    Row {
      id: rowSmall
      anchors.left:       parent.left
      anchors.top:        parent.top
      anchors.leftMargin: 1
      height:             parent.height
      spacing:            2
      Repeater {
        model: (ratingMap[trackRating.rating] === undefined) ? nrRatings : (nrRatings - ratingMap[trackRating.rating])
        Rectangle {
          width:                  2
          height:                 smallLineContainer.height - 2
          anchors.verticalCenter: rowSmall.verticalCenter
          color:                  trackRating.smallLineColor
        }
      }
    }
  }
}