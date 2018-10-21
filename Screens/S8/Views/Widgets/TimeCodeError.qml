import QtQuick 2.0

Rectangle {
  width:   300
  height:  160
  radius:  7
  color:  '#aa444444'
  border {
    width: 1
    color: '#aaa'
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  ICON
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle  {
    id:  symbol
    anchors.centerIn: parent
    width:  80
    height: 80
    radius: 6
    color:  '#888'
    border {
      width: 2
      color: '#111'
    }

    Rectangle  {
      anchors.centerIn: parent
      width: 60
      height: 2
      color: '#000'
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  TEXT FIELDS
  //--------------------------------------------------------------------------------------------------------------------

  Text  {
    anchors {
      horizontalCenter: symbol.horizontalCenter
      bottom:           symbol.top;   
      bottomMargin:     6
    }
    font {
      pixelSize: 24
    }
    text: "TIMECODE"
    color: '#fff'
  }


  Text  {
    id:  errorMessage
    anchors {
      horizontalCenter: symbol.horizontalCenter
      top:              symbol.bottom;   
      topMargin:        7
    }
    font {
      pixelSize: 20
    }

    text: "LEFT CHANNEL MISSING"
    color: '#f44'

    Timer {
      property  real  _angle: 0.0
      on_AngleChanged: errorMessage.opacity = 0.6 + 0.4*Math.cos( _angle )

      interval: 16
      running:  true
      repeat:   true

      onTriggered: _angle += 0.1
    }
  }
}
