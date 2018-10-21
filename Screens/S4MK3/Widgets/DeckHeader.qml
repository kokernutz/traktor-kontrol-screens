import QtQuick 2.5

//here we assume that `colors` and `dimensions` already exists in the object hierarchy
Item {
  id: widget
  property string title: ''
  property color  backgroundColor: colors.defaultBackground
  
  height:         dimensions.firstRowHeight
  

  Rectangle {
    id           : headerBg
    color        : widget.backgroundColor
    anchors.fill : parent
    radius: dimensions.cornerRadius
    
    // TRACK NAME // 
    Text
    {
      anchors.fill : parent
      anchors.leftMargin:   dimensions.titleTextMargin
      anchors.rightMargin:  dimensions.titleTextMargin
      font.family: "Roboto"
      font.weight: Font.Normal

      font.pixelSize: 22
      verticalAlignment: Text.AlignVCenter
      color: colors.defaultTextColor
      elide: Text.ElideRight
      text: widget.title
    }
    
  }
}
