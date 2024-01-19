import CSI 1.0
import QtQuick 2.0

import "../../CSI/X1MK3/Defines"

Item {
  id: screen

  // side is unused but needed for compatibility
  property int side: ScreenSide.Left;

  property string settingsPath: ""
  property string propertiesPath: ""

  width:  128
  height: 64
  clip:   true

  MappingProperty { id: fxSectionLayer; path: screen.propertiesPath + ".fx_section_layer" }

  MappingProperty { id: deviceSetupStateProp; path: screen.propertiesPath + ".device_setup_state" }
  property alias deviceSetupState: deviceSetupStateProp.value

  MappingProperty { id: leftDeckIdxProp; path: screen.propertiesPath + ".left_deck_index" }
  property alias leftDeckIdx: leftDeckIdxProp.value

  MappingProperty { id: rightDeckIdxProp; path: screen.propertiesPath + ".right_deck_index" }
  property alias rightDeckIdx: rightDeckIdxProp.value

  MappingProperty { id: leftFxIdxProp; path: screen.propertiesPath + ".left_fx_index" }
  property alias leftFxIdx: leftFxIdxProp.value

  MappingProperty { id: rightFxIdxProp; path: screen.propertiesPath + ".right_fx_index" }
  property alias rightFxIdx: rightFxIdxProp.value

  AppProperty { id: deckAPlayProp; path: "app.traktor.decks.1.play" }
  AppProperty { id: deckBPlayProp; path: "app.traktor.decks.2.play" }
  AppProperty { id: deckCPlayProp; path: "app.traktor.decks.3.play" }
  AppProperty { id: deckDPlayProp; path: "app.traktor.decks.4.play" }
  AppProperty { id: deckALevelProp; path: "app.traktor.mixer.channels.1.level.prefader.linear.sum" }
  AppProperty { id: deckBLevelProp; path: "app.traktor.mixer.channels.2.level.prefader.linear.sum" }
  AppProperty { id: deckCLevelProp; path: "app.traktor.mixer.channels.3.level.prefader.linear.sum" }
  AppProperty { id: deckDLevelProp; path: "app.traktor.mixer.channels.4.level.prefader.linear.sum" }
  readonly property real metersFactor: 0.8

  function deckImage(layer, deckIdx)
  {
    if (layer == FXSectionLayer.mixer)
    {
      switch(deckIdx)
      {
        case 1: return "A_" + (deckAPlayProp.value ? "A" : "U") + ".png";
        case 2: return "B_" + (deckBPlayProp.value ? "A" : "U") + ".png";
        case 3: return "C_" + (deckCPlayProp.value ? "A" : "U") + ".png";
        case 4: return "D_" + (deckDPlayProp.value ? "A" : "U") + ".png";
      }
    }

    return "A_A.png";
  }

  Rectangle {
    color: "black"
    anchors.fill: parent

    Item {
      anchors.fill: parent
      visible: (deviceSetupState == DeviceSetupState.assigned) &&
               ((fxSectionLayer.value == FXSectionLayer.fx_primary) || (fxSectionLayer.value == FXSectionLayer.fx_secondary))

      ThinText {
          anchors {
              top: parent.top
              left: parent.left
              right: parent.right
              topMargin: -8
              leftMargin: -12
          }
          text: " EFFECTS"        
      }
  
      Image {
          anchors {
              bottom: parent.bottom
              left: parent.left
          }
  
          source:    "Images/" + leftFxIdx + "_A.png"
          fillMode:  Image.PreserveAspectFit
      }
  
      Image {
          anchors {
              bottom: parent.bottom
              right: parent.right
          }
  
          source:    "Images/" + rightFxIdx + "_A.png"
          fillMode:  Image.PreserveAspectFit
      }
  
      AnimatedImage {
          id: fxAnimation1
          anchors {
              bottom: parent.bottom
              horizontalCenter: parent.horizontalCenter
              bottomMargin: 5
          }
  
          source: "Images/FX.gif"
      }
  
      AnimatedImage {
          id: fxAnimation2
          anchors {
              bottom: fxAnimation1.top
              horizontalCenter: parent.horizontalCenter
              bottomMargin: 5
          }
  
          source: "Images/FX.gif"
      }
    }

    Item {
      anchors.fill: parent
      visible: (deviceSetupState == DeviceSetupState.assigned) &&
               (fxSectionLayer.value == FXSectionLayer.mixer)

      ThinText {
          anchors {
              top: parent.top
              left: parent.left
              right: parent.right
              topMargin: -8
              leftMargin: -12
          }
          text: " MIXER"
          horizontalAlignment: Text.AlignHCenter
      }
  
      Image {
          anchors {
              bottom: parent.bottom
              left: parent.left
          }
  
          source:    "Images/" + deckImage(fxSectionLayer.value, leftDeckIdx)
          fillMode:  Image.PreserveAspectFit
      }
  
      Image {
          anchors {
              bottom: parent.bottom
              right: parent.right
          }
  
          source:    "Images/" + deckImage(fxSectionLayer.value, rightDeckIdx)
          fillMode:  Image.PreserveAspectFit
      }
  
      Image {
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 43
        }
        source: "Images/VolumeMeter.png"

        Rectangle
        {
          anchors {
              left: parent.left
              right: parent.right
              bottom: parent.bottom
          }

          color: "white"
          height: Math.min(deckCLevelProp.value * parent.height * metersFactor, 36)
        }
      }

      Image {
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 55
        }
        source: "Images/VolumeMeter.png"

        Rectangle
        {
          anchors {
              left: parent.left
              right: parent.right
              bottom: parent.bottom
          }

          color: "white"
          height: Math.min(deckALevelProp.value * parent.height * metersFactor, 36)
        }
      }

      Image {
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 67
        }
        source: "Images/VolumeMeter.png"

        Rectangle
        {
          anchors {
              left: parent.left
              right: parent.right
              bottom: parent.bottom
          }

          color: "white"
          height: Math.min(deckBLevelProp.value * parent.height * metersFactor, 36)
        }
      }

      Image {
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 79
        }
        source: "Images/VolumeMeter.png"

        Rectangle
        {
          anchors {
              left: parent.left
              right: parent.right
              bottom: parent.bottom
          }

          color: "white"
          height: Math.min(deckDLevelProp.value * parent.height * metersFactor, 36)
        }
      }
    }

    Item {
      anchors.fill: parent
      visible: deviceSetupState == DeviceSetupState.unassigned
  
      ThinText {
          anchors.fill: parent
          text: "DEVICE SETUP"
          horizontalAlignment: Text.AlignHCenter
          wrapMode: Text.WordWrap
          lineHeight: 29
          lineHeightMode: Text.FixedHeight
      }
    }

    Item {
      anchors.fill: parent
      visible: deviceSetupState == DeviceSetupState.just_assigned
  
      ThinText {
          anchors.fill: parent
          text: "¢"
          font.pixelSize: 60
          horizontalAlignment: Text.AlignHCenter
          wrapMode: Text.WordWrap
      }
    }
  }
}
