import CSI 1.0
import QtQuick 2.0
import Traktor.Gui 1.0 as Traktor

// These are the triangle shaped cues at the bottom of the waveform/stripe. Two different sized triangle components can
// be loaded and switched using the 'isSmall' variable. 
Item {
  id: activeCue
  property int  activeCueLength: 0
  property int  cueWidth: cue.width
  property bool isSmall: false

  readonly property var  hotcueMarkerTypes: {0: "hotcue", 1: "fadeIn", 2: "fadeOut", 3: "load", 4: "grid", 5: "loop" }
  property bool isLoop: (hotcueMarkerTypes[type] == "loop")
  property int type: -1
  anchors.top:    parent.top
  anchors.bottom: parent.bottom
  anchors.leftMargin:   -1
  width: 20
  clip:  false


  //--------------------------------------------------------------------------------------------------------------------

  Item {
    id: cue
    anchors.right:      parent.right
    anchors.left:       parent.left
    anchors.bottom:     parent.bottom
    height:             isSmall ? 7 : 13
    width:              cueLoader.sourceComponent.width
    clip:               false
    Loader { 
      id: cueLoader 
      anchors.bottom: parent.bottom
      height:         parent.height
      width:          parent.width
      active:         true
      visible:        true
      clip:           false
      sourceComponent: isSmall ? smallCue : largeCue
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  Item {
    anchors.left:   cue.left
   // anchors.leftMargin: -1
    width:          parent.activeCueLength  + 1
    anchors.bottom: parent.bottom
    height:         7
    clip:           false
    Loader { 
      id: endCueLoader 
      anchors.left:    parent.right
      anchors.bottom:  parent.bottom
      height:          cue.height
      width:           cue.width
      active:          true
      visible:         isLoop
      clip:            false
      sourceComponent: isSmall ? smallCue : largeCue
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // the small cue for the stripe is defined here. It is positioned such that its horizontal center lies on the left
  // anchor of the activeCue Item.
  Component {
    id: smallCue
    Traktor.Polygon {
      id: currentCueSmall
      anchors.bottomMargin: -2
      anchors.leftMargin: -7

      anchors.left:        parent.left
      anchors.bottom:     parent.bottom
      color:              activeCue.isLoop ? colors.color07Bright : "white"
      border.width:       1
      border.color:       colors.colorBlack50
      antialiasing:       true
      points: [ Qt.point(0, 7)
              , Qt.point(5.5, 0)
              , Qt.point(11, 7)
              ]
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // the large cue for the stripe is defined here. It is positioned such that its horizontal center lies on the left
  // anchor of the activeCue Item.
  Component {
    id: largeCue
    Traktor.Polygon {
      id: currentCueLarge
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      anchors.bottomMargin: -12
      anchors.leftMargin: -10
      color: activeCue.isLoop ? colors.color07Bright : "white"
      border.width: 1.5
      border.color: colors.colorBlack50
      antialiasing: true
      points: [ Qt.point(13, 8)
              , Qt.point(0 , 8)
              , Qt.point(6.5 , 0)
              
              ]
    }
  }
}
