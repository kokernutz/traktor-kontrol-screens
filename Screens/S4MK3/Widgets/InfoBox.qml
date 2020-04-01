import QtQuick 2.5

Item {
    id: widget
      property string title: ''
      property string text:  ''
      property bool active: false
      property bool highlight: false
      property color color: 'white'
      property int fontSize: 30
      property int alignment: Text.AlignCenter

      // Background
      Rectangle
      {
        color: widget.color
        anchors.fill: parent
        opacity: widget.active ? 0.15 : 0.00
      }

      // Title
      Text
      {
        id: title
        opacity: 0.5
        text: widget.title
        font.pixelSize: 10
        font.family: "Roboto"
        font.weight: Font.Normal
        color: widget.color
        horizontalAlignment: widget.alignment

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: content.top
        anchors.topMargin: 5
        anchors.leftMargin: 10
        anchors.rightMargin: 10
      }

      // Content
      Text
      {
        id: content
        text: widget.text
        font.pixelSize: widget.fontSize
        font.family: "Roboto"
        color: widget.color
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: widget.alignment

        style: widget.highlight ? Text.Outline : Text.Normal
        styleColor: widget.color

        anchors.top: title.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.leftMargin: 10
        anchors.rightMargin: 10
      }
    }