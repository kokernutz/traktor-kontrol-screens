import QtQuick 2.5

Item {
    id : widget
    height: 10

    property real phase: 0.0

    property color phaseColor: "#90550C"
    property color phaseHeadColor: "#FCB262"
    property color separatorColor: "#88ffffff"
    property color backgroundColor: colors.grayBackground
    property real phasePosition: parent.width * (0.5 + widget.phase)
    property real phaseBarWidth: parent.width * Math.abs(widget.phase)

    // Background
    Rectangle
    {
      anchors.fill: parent
      color: widget.backgroundColor
    }

    // Phase Bar
    Rectangle
    {
      color  : widget.phaseColor
      height : parent.height
      width  : phaseBarWidth
      x : widget.phase < 0 ? widget.phasePosition : (parent.width/2)
    }

    // Phase Head
    Rectangle
    {
      color: widget.phaseHeadColor
      height : parent.height
      width: 1
      x: widget.phase < 0 ? widget.phasePosition : (widget.phasePosition - width)
      visible: Math.round(phaseBarWidth) !== 0 // hide phase head when phase is 0
    }

    // Separator at 0.25
    Rectangle
    {
      color  : widget.separatorColor
      height : parent.height
      width  : 2
      x : parent.width * 0.25 - 1
    }

    // center Separator
    Rectangle
    {
      color  : widget.separatorColor
      height : parent.height
      width  : 2
      x : parent.width * 0.50 - 1
    }

    // Separator at 0.75
    Rectangle
    {
      color  : widget.separatorColor
      height : parent.height
      width  : 2
      x : parent.width * 0.75 - 1
    }
}
