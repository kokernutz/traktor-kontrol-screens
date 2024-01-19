import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects

import '../Widgets' as Widgets
import '../../../Defines' as Defines

//--------------------------------------------------------------------------------------------------------------------
//  FX CONTROLS
//--------------------------------------------------------------------------------------------------------------------

// The FxControls are located on the top of the screen and blend in if one of the top knobs is touched/changed

Item {
  id: topLabels

  property string showHideState: "hide"
  property int  fxUnit: 0
  property int  yPositionWhenHidden: 0 - topLabels.height - headerBlackLine.height - headerShadow.height // also hides black border & shadow
  property int  yPositionWhenShown: 0
  property string sizeState: "large" // small/large
  readonly property color barBgColor: "black"

  Defines.Colors    { id: colors    }
  Defines.Durations { id: durations }

  
  height: (sizeState == "small") ? 45 : 69 // includes grey panel and black border with shadow at the bottom
  anchors.left:  parent.left
  anchors.right: parent.right

  // dark grey background
  Rectangle {
    id: topInfoDetailsPanelDarkBg
    anchors {
      top: parent.top
      left:  parent.left
      right: parent.right
    }
    height: topLabels.height
    color: colors.colorFxHeaderBg
    // light grey background
    Rectangle {
      id:topInfoDetailsPanelLightBg
      anchors {
        top: parent.top
        left: parent.left
      }
      height: topLabels.height
      width: 120
      color: colors.colorFxHeaderLightBg
    }
  }

//  // dividers
//  Rectangle {
//    id: fxInfoDivider0
//    width:1;
//    height:63;
//    color: colors.colorDivider
//    anchors.top: parent.top
//    anchors.left: parent.left
//    anchors.leftMargin: 120
//  }

  // dividers
  Rectangle {
    id: fxInfoDivider1
    width:1;
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 240
    height: (sizeState == "small") ? 43 : 63
  }

  Rectangle {
    id: fxInfoDivider2
    width:1;
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 360
    height: (sizeState == "small") ? 43 : 63
  }

  // Info Details
  Rectangle {
    id: topInfoDetailsPanel

    height: parent.height
    clip: true
    width: parent.width
    color: "transparent"

    anchors.left: parent.left
    anchors.leftMargin: 1

    AppProperty { id: fxDryWet;      path: "app.traktor.fx." + (fxUnit + 1) + ".dry_wet"          }
    
    AppProperty { id: fxParam1;      path: "app.traktor.fx." + (fxUnit + 1) + ".parameters.1"      }
    AppProperty { id: fxKnob1name;   path: "app.traktor.fx." + (fxUnit + 1) + ".knobs.1.name"      }
    
    AppProperty { id: fxParam2;      path: "app.traktor.fx." + (fxUnit + 1) + ".parameters.2"      }
    AppProperty { id: fxKnob2name;   path: "app.traktor.fx." + (fxUnit + 1) + ".knobs.2.name"      }
    
    AppProperty { id: fxParam3;      path: "app.traktor.fx." + (fxUnit + 1) + ".parameters.3"      }
    AppProperty { id: fxKnob3name;   path: "app.traktor.fx." + (fxUnit + 1) + ".knobs.3.name"      }
    
    AppProperty { id: fxOn;          path: "app.traktor.fx." + (fxUnit + 1) + ".enabled"          }
    AppProperty { id: fxButton1;     path: "app.traktor.fx." + (fxUnit + 1) + ".buttons.1"         }
    AppProperty { id: fxButton1name; path: "app.traktor.fx." + (fxUnit + 1) + ".buttons.1.name"    }
    AppProperty { id: fxButton2;     path: "app.traktor.fx." + (fxUnit + 1) + ".buttons.2"         }
    AppProperty { id: fxButton2name; path: "app.traktor.fx." + (fxUnit + 1) + ".buttons.2.name"    }
    AppProperty { id: fxButton3;     path: "app.traktor.fx." + (fxUnit + 1) + ".buttons.3"         }
    AppProperty { id: fxButton3name; path: "app.traktor.fx." + (fxUnit + 1) + ".buttons.3.name"    }
    
    AppProperty { id: singleMode;    path: "app.traktor.fx." + (fxUnit + 1) + ".type"             } // singleMode -> fxSelect1.description else "DRY/WET"
    AppProperty { id: fxSelect1;     path: "app.traktor.fx." + (fxUnit + 1) + ".select.1"         } // singleMode -> fxKnob1name.value
    AppProperty { id: fxSelect2;     path: "app.traktor.fx." + (fxUnit + 1) + ".select.2"         } // singleMode -> fxKnob2name.value
    AppProperty { id: fxSelect3;     path: "app.traktor.fx." + (fxUnit + 1) + ".select.3"         } // singleMode -> fxKnob3name.value
    
    Row {
      TopInfoDetails {
        id: topInfoDetails1
        parameter: fxDryWet
        isOn: fxOn.value
        label: singleMode.value ? fxSelect1.description : "DRY/WET"
        buttonLabel: singleMode.value ? "ON" : ""
        fxEnabled: (!singleMode.value) || fxSelect1.value
        barBgColor: barBgColor
        sizeState: topLabels.sizeState
      }
      
      TopInfoDetails {
        id: topInfoDetails2
        parameter: fxParam1
        isOn: fxButton1.value
        label: fxKnob1name.value
        buttonLabel: fxButton1name.value
        fxEnabled: (fxSelect1.value || (singleMode.value && fxSelect1.value) )
        barBgColor: barBgColor
        sizeState: topLabels.sizeState
      }
      
      TopInfoDetails {
        id: topInfoDetails3
        parameter: fxParam2
        isOn: fxButton2.value
        label: fxKnob2name.value
        buttonLabel: fxButton2name.value
        fxEnabled: (fxSelect2.value || (singleMode.value && fxSelect1.value) )
        barBgColor: barBgColor
        sizeState: topLabels.sizeState
      }
      
      TopInfoDetails {
        id: topInfoDetails4
        parameter: fxParam3
        isOn: fxButton3.value
        label: fxKnob3name.value
        buttonLabel: fxButton3name.value
        fxEnabled: (fxSelect3.value || (singleMode.value && fxSelect1.value) )
        barBgColor: barBgColor
        sizeState: topLabels.sizeState
      }
    }
  }

  // black border & shadow
  Rectangle {
    id: headerBlackLine
    anchors.top: topLabels.bottom
    width:       parent.width
    color:       colors.colorBlack
    height:      (sizeState == "small") ? 1 : 2
  }
  Rectangle {
    id: headerShadow
    anchors.left:  parent.left
    anchors.right: parent.right
    anchors.top:   headerBlackLine.bottom
    height:        6
    gradient: Gradient {
      GradientStop { position: 1.0; color: colors.colorBlack0 }
      GradientStop { position: 0.0; color: colors.colorBlack63 }
    }
    visible: false
  }

  //------------------------------------------------------------------------------------------------------------------
  //  STATES
  //------------------------------------------------------------------------------------------------------------------

  Behavior on y { PropertyAnimation { duration: durations.overlayTransition;  easing.type: Easing.InOutQuad } }

  Item {
    id: showHide
    state: showHideState
    states: [
      State {
        name: "show";
        PropertyChanges { target: topLabels;   y: yPositionWhenShown}
      },
      State {
        name: "hide";
        PropertyChanges { target: topLabels;   y: yPositionWhenHidden}
      }
    ]
  }
}


