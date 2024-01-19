import QtQuick 2.0
import Traktor.Gui 1.0 as Traktor
import Qt5Compat.GraphicalEffects
import CSI 1.0

// The hotcue can be used to show all different types of hotcues. Type switching is done by using the 'hotcue state'.
// The number shown in the hotcue can be set by using hotcueId.
Item {
  id : hotcue

  property bool   showHead:     true
  property bool   smallHead:    true 
  property color  hotcueColor:  "transparent" 
  property int    hotcueId:     0
  property int    hotcueLength: 0
  property int    topMargin:    6


  readonly property double borderWidth:       2
  readonly property bool   useAntialiasing:   true
  readonly property int    smallCueHeight:    hotcue.height + 3
  readonly property int    smallCueTopMargin: -4 
  readonly property int    largeCueHeight:    hotcue.height 
  readonly property var    hotcueMarkerTypes: { 0: "hotcue", 1: "fadeIn", 2: "fadeOut", 3: "load", 4: "grid", 5: "loop" }
  readonly property string hotcueState:       ( exists && type != -1) ? hotcueMarkerTypes[type] : "off"
  property bool exists: false
  property int type: -1

  height:  parent.height
  clip:    false

  //--------------------------------------------------------------------------------------------------------------------
  // If the hotcue should only be represented as a single line, use 'flagpole'

  Rectangle {
    id: flagpole
    anchors.bottom:           parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    height:                   smallCueHeight - 2
    width:                    3
    border.width:             1
    border.color:             colors.colorBlack50
    color:                    hotcue.hotcueColor
    visible:                  !showHead && (smallHead == true)
  }

  //--------------------------------------------------------------------------------------------------------------------
  // cue loader loads the different kinds of hotcues depending on their type (-> states at end of file)

  Item {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    height:                   smallHead ? 32 : (parent.height)
    width:                    40
    clip:                     false
    visible:                  hotcue.showHead
    Loader { 
      id: cueLoader 
      anchors.fill: parent
      active:       true
      visible:      true
      clip:         false
    }
  }

  // GRID --------------------------------------------------------------------------------------------------------------

  Component {
    id: gridComponentSmall
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.topMargin:  hotcue.smallCueTopMargin
      anchors.leftMargin: -8

      antialiasing:       useAntialiasing

      color:              hotcue.hotcueColor
      border.width:       borderWidth
      border.color:       colors.colorBlack50

      points: [ Qt.point(0 , 10)
              , Qt.point(0 , 0)
              , Qt.point(13, 0) 
              , Qt.point(13, 10)
              , Qt.point(7 , 14)
              , Qt.point(7 , hotcue.smallCueHeight)
              , Qt.point(6 , hotcue.smallCueHeight)
              , Qt.point(6 , 14)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 4
        anchors.topMargin: -1
        color:              colors.colorBlack
        text:               hotcue.hotcueId
        font.pixelSize:     fonts.smallFontSize
      }
    }
  }

  Component {
    id: gridComponentLarge
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -10 
      anchors.topMargin:  -1
      antialiasing:       useAntialiasing

      color:              hotcue.hotcueColor
      border.width:       borderWidth
      border.color:       colors.colorBlack50
      points: [ Qt.point(0 , 12)
              , Qt.point(0 , 0)
              , Qt.point(15, 0) 
              , Qt.point(15, 12)
              , Qt.point(8 , 17)
              , Qt.point(8 , hotcue.largeCueHeight)
              , Qt.point(7 , hotcue.largeCueHeight)
              , Qt.point(7 , 17)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 5
        color:              colors.colorBlack
        text:               hotcue.hotcueId
        font.pixelSize:     fonts.smallFontSize
      }
    }
  }

  // CUE ----------------------------------------------------------------------------------------------------------------

  Component {
    id: hotcueComponentSmall
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.topMargin:  hotcue.smallCueTopMargin
      anchors.leftMargin: -2
      antialiasing:       useAntialiasing

      color:              hotcue.hotcueColor
      border.width:       borderWidth
      border.color:       colors.colorBlack50
      points: [ Qt.point(0 , 0)
              , Qt.point(12, 0)
              , Qt.point(15, 5.5)
              , Qt.point(12, 11)
              , Qt.point(1 , 11)
              , Qt.point(1 , hotcue.smallCueHeight)
              , Qt.point(0 , hotcue.smallCueHeight) 
              ]
      Text {
        anchors.top:        parent.top; 
        anchors.left:       parent.left; 
        anchors.leftMargin: 4
        anchors.topMargin:  -1
        color:              colors.colorBlack; 
        text:               hotcue.hotcueId; 
        font.pixelSize:     fonts.smallFontSize
      }
    }
  }

  Component {
    id: hotcueComponentLarge
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -3
      anchors.topMargin:  -1
      antialiasing:       useAntialiasing

      color:              hotcue.hotcueColor 
      border.width:       borderWidth
      border.color:       colors.colorBlack50
      points: [ Qt.point(0 , 0)
              , Qt.point(14, 0)
              , Qt.point(19, 6.5)
              , Qt.point(14, 13)
              , Qt.point(1 , 13)
              , Qt.point(1 , hotcue.largeCueHeight) 
              , Qt.point(0 , hotcue.largeCueHeight) 
              ]
      Text {
        anchors.top:        parent.top;         
        anchors.left:       parent.left; 
        anchors.leftMargin: 5
        color:              colors.colorBlack; 
        text:               hotcue.hotcueId; 
        font.pixelSize:     fonts.smallFontSize
      }
    }
  }

  // FADE IN -----------------------------------------------------------------------------------------------------------

  Component {
    id: fadeInComponentSmall
    Traktor.Polygon {
      anchors.top:         cueLoader.top
      anchors.right:       cueLoader.right 
      anchors.topMargin:   hotcue.smallCueTopMargin
      anchors.rightMargin: -1
      antialiasing:        useAntialiasing

      color:               hotcue.hotcueColor   
      border.width:        borderWidth
      border.color:        colors.colorBlack50
      points: [ Qt.point(-0.4, 11)
              , Qt.point(5 , 0)
              , Qt.point(17, 0) 
              , Qt.point(17, hotcue.smallCueHeight)
              , Qt.point(16, hotcue.smallCueHeight)
              , Qt.point(16, 11)
              ]

      Text {
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.topMargin:  -1
        anchors.leftMargin: borderWidth + 6
        color:              colors.colorBlack 
        text:               hotcue.hotcueId; 
        font.pixelSize:     fonts.smallFontSize
      }
    }
  }

  Component {
    id: fadeInComponentLarge
    Traktor.Polygon {
      anchors.top:         cueLoader.top
      anchors.left:        cueLoader.horizontalCenter
      anchors.topMargin:   -1
      anchors.leftMargin:  -23
      antialiasing:        useAntialiasing

      color:               hotcue.hotcueColor   
      border.width:        borderWidth
      border.color:        colors.colorBlack50
      points: [ Qt.point(-0.4 , 13)
              , Qt.point(6 , 0)
              , Qt.point(20, 0) 
              , Qt.point(20, hotcue.largeCueHeight)
              , Qt.point(19, hotcue.largeCueHeight)
              , Qt.point(19, 13)
              ]

      Text {
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 9
        color:              colors.colorBlack
        text:               hotcue.hotcueId; 
        font.pixelSize:     fonts.smallFontSize
      }
    }
  }

  // FADE OUT ----------------------------------------------------------------------------------------------------------

  Component {
    id: fadeOutComponentSmall
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter 
      anchors.topMargin:  hotcue.smallCueTopMargin
      anchors.leftMargin: -2
      antialiasing:       useAntialiasing

      color:              hotcue.hotcueColor   
      border.width:       borderWidth
      border.color:       colors.colorBlack50
      points: [ Qt.point(0, 0)
              , Qt.point(12, 0)
              , Qt.point(17, 11)
              , Qt.point(1, 11)
              , Qt.point(1, hotcue.smallCueHeight)
              , Qt.point(0, hotcue.smallCueHeight)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 4.5
        anchors.topMargin:  -1
        color:              colors.colorBlack; 
        text:               hotcue.hotcueId; 
        font.pixelSize:     fonts.smallFontSize
      }
    }
  }

  Component {
    id: fadeOutComponentLarge
    Traktor.Polygon {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -3
      anchors.topMargin:  -1
      antialiasing:       useAntialiasing

      color:              hotcue.hotcueColor   
      border.width:       borderWidth
      border.color:       colors.colorBlack50
      points: [ Qt.point(0, 0)
              , Qt.point(14, 0)
              , Qt.point(20, 13)
              , Qt.point(1, 13)
              , Qt.point(1, hotcue.largeCueHeight)
              , Qt.point(0, hotcue.largeCueHeight)
              ]
      Text { 
        anchors.top:        parent.top
        anchors.left:       parent.left
        anchors.leftMargin: 6
        color:              colors.colorBlack 
        text:               hotcue.hotcueId
        font.pixelSize:     fonts.smallFontSize
      }
    }
  }

  // LOAD --------------------------------------------------------------------------------------------------------------

  Component {
    id: loadComponentSmall
    Item {
      anchors.top:               cueLoader.top
      anchors.topMargin:         hotcue.smallCueTopMargin
      anchors.horizontalCenter:  cueLoader.horizontalCenter
      clip:               false

      // pole border
      Rectangle {
        anchors.top:              circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.leftMargin:       4
        width:                    3
        height:                   18
        color:                    colors.colorBlack50
      }
      
      // round head
      Rectangle {
        id: circle
        anchors.top:               parent.top
        anchors.horizontalCenter:  parent.horizontalCenter
        anchors.topMargin:         -1
        color:                     hotcue.hotcueColor
        width:                     15 
        height:                    width
        radius:                    0.5*width
        border.width:              1
        border.color:              colors.colorBlack50

        Text {
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 4
          anchors.topMargin:  0
          color:              colors.colorBlack 
          text:               hotcue.hotcueId
          font.pixelSize:     fonts.smallFontSize
        }
      }
            // pole
      Rectangle {
        anchors.top:              circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.leftMargin:       5
        anchors.topMargin:        -1
        width:                    1
        height:                   18
        color:                    hotcue.hotcueColor
      }

    }
  }

  Component {
    id: loadComponentLarge
    Item {
      anchors.top:        cueLoader.top
      anchors.left:       cueLoader.horizontalCenter
      anchors.leftMargin: -21 
      anchors.topMargin:  -2
      height:             cueLoader.height
      clip:               false

      // pole border
      Rectangle {
        anchors.top:              circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.leftMargin:       4
        width:                    3
        height:                   hotcue.height - circle.height + 1
        color:                    colors.colorBlack50
      }
      
      // round head
      Rectangle {
        id: circle
        anchors.top:              parent.top
        anchors.topMargin:        -1
        anchors.horizontalCenter: parent.horizontalCenter
        color:                    hotcue.hotcueColor
        width:                    19 
        height:                   width
        radius:                   0.5*width
        border.width:             borderWidth
        border.color:             colors.colorBlack50

        Text {
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 6
          anchors.topMargin:  2
          color:              colors.colorBlack
          text:               hotcue.hotcueId
          font.pixelSize:     fonts.smallFontSize
        }
      }

      // pole
      Rectangle {
        anchors.top:              circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.topMargin:        -2
        anchors.leftMargin:       5
        width:                    1
        height:                   hotcue.height - circle.height + 2
        color:                    hotcue.hotcueColor
      }
    }
  }

  // LOOP --------------------------------------------------------------------------------------------------------------

   Component {
      id: loopComponentSmall
    Item {
      clip:                     false
      anchors.top:              cueLoader.top
      anchors.topMargin:        hotcue.smallCueTopMargin
      anchors.left:             cueLoader.left
      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter
        anchors.leftMargin: -15 
        antialiasing: true
        color:             hotcue.hotcueColor   
        border.width:       borderWidth
        border.color:       colors.colorBlack50
        points: [ Qt.point(0 , 11)
                , Qt.point(0 , 0)
                , Qt.point(14, 0)
                , Qt.point(14, hotcue.smallCueHeight)
                , Qt.point(13, hotcue.smallCueHeight)
                , Qt.point(13, 11)
                ]

        Text { 
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 4
          anchors.topMargin: -1
          color:              colors.colorBlack
          text:               hotcue.hotcueId
          font.pixelSize:     fonts.smallFontSize
        }
      }

      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter 
        anchors.leftMargin: hotcueLength -1
        // anchors.topMargin:  hotcue.topMargin
        antialiasing: useAntialiasing

        color:             hotcue.hotcueColor   
        border.width:       borderWidth
        border.color:       colors.colorBlack50
        points: [ Qt.point(0, 0)
                , Qt.point(14, 0)
                , Qt.point(14, 11)
                , Qt.point(1, 11)
                , Qt.point(1, hotcue.smallCueHeight) 
                , Qt.point(0, hotcue.smallCueHeight)
                ]
      }
    }
  }

  Component {
    id: loopComponentLarge
    Item {
      anchors.top:          cueLoader.top
      anchors.left:         cueLoader.left
      anchors.topMargin:    -1
      anchors.leftMargin:   -1
      clip:                 false
      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter
        anchors.leftMargin: -17 
        antialiasing:       true
        color:              hotcue.hotcueColor   
        border.width:       borderWidth 
        border.color:       colors.colorBlack50
  
        points: [ Qt.point(0 , 13)
                , Qt.point(0 , 0)
                , Qt.point(16, 0)
                , Qt.point(16, hotcue.largeCueHeight)
                , Qt.point(15, hotcue.largeCueHeight)
                , Qt.point(15, 13)
                ]

        Text { 
          anchors.top:        parent.top
          anchors.left:       parent.left
          anchors.leftMargin: 5
          color:             colors.colorBlack 
          text:              hotcue.hotcueId
          font.pixelSize:    fonts.smallFontSize
        }
      }

      Traktor.Polygon {
        anchors.top:        parent.top
        anchors.left:       parent.horizontalCenter 
        anchors.leftMargin: hotcueLength -1
        antialiasing:       useAntialiasing

        color:              hotcue.hotcueColor   
        border.width:       borderWidth
        border.color:       colors.colorBlack50
        points: [ Qt.point(0, 0)
                , Qt.point(16, 0)
                , Qt.point(16, 13)
                , Qt.point(1, 13)
                , Qt.point(1, hotcue.largeCueHeight)
                , Qt.point(0, hotcue.largeCueHeight)
                ]
      }
    }
  }

  //-------------------------------------------------------------------------------------------------------------------- 

  state: hotcueState
  states: [
    State {
      name: "off";
      PropertyChanges { target: hotcue;      visible:         false   }
    },
    State {
      name: "grid";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.grid   }
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? gridComponentSmall : gridComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "hotcue";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.hotcue } 
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? hotcueComponentSmall : hotcueComponentLarge  }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "fadeIn";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.fade } 
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? fadeInComponentSmall : fadeInComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "fadeOut";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.fade } 
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? fadeOutComponentSmall  : fadeOutComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
      name: "load";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.load } 
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? loadComponentSmall : loadComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    },
    State {
       name: "loop";
      PropertyChanges { target: hotcue;      hotcueColor:     colors.hotcue.loop } 
      PropertyChanges { target: cueLoader;   sourceComponent: smallHead ? loopComponentSmall  : loopComponentLarge }
      PropertyChanges { target: hotcue;      visible:         true   }
    } 
  ]       
}
