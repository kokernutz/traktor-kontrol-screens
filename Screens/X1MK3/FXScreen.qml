import CSI 1.0
import QtQuick 2.0

import "../../CSI/X1MK3/Defines"
import "Scripts/DisplayHelpers.js" as DisplayHelpers

Item {
  id: screen

  property int side: ScreenSide.Left;

  property string settingsPath: ""
  property string propertiesPath: ""

  width:  128
  height: 64
  clip:   true

  readonly property variant fxText: ["FX 1", "FX 2", "FX 3", "FX 4"]
  
  MappingProperty { id: deviceSetupStateProp; path: "mapping.state.device_setup_state" }
  property alias deviceSetupState: deviceSetupStateProp.value

  MappingProperty { id: fxSectionLayerProp; path: "mapping.state.fx_section_layer"; onValueChanged: onLayerChanged() }
  property alias fxSectionLayer: fxSectionLayerProp.value

  MappingProperty { id: primaryFxUnitProp; path: screen.propertiesPath + ".primary_fx_unit" }
  MappingProperty { id: secondaryFxUnitProp; path: screen.propertiesPath + ".secondary_fx_unit" }
  readonly property int fxUnitIdx: (fxSectionLayer === FXSectionLayer.fx_primary ? primaryFxUnitProp.value : secondaryFxUnitProp.value)

  MappingProperty { id: deckIdxProp; path: screen.propertiesPath + ".active_deck" }
  property alias deckIdx: deckIdxProp.value

  MappingProperty { id: knobsAreActiveProp; path: screen.propertiesPath + ".knobs_are_active" }
  property alias knobsAreActive: knobsAreActiveProp.value

  MappingProperty { id: lastTouchedKnobProp; path: screen.propertiesPath + ".last_active_knob" }
  property alias lastTouchedKnob: lastTouchedKnobProp.value

  MappingProperty { id: softTakeoverDirectionProp; path: screen.propertiesPath + ".softtakeover." + lastTouchedKnob + ".direction" }
  property alias softTakeoverDirection: softTakeoverDirectionProp.value

  // Effect unit properties
  AppProperty { id: fxUnitType; path: "app.traktor.fx." + fxUnitIdx + ".type"; onValueChanged: onFxChanged() }
  AppProperty { id: fxSelect1; path: "app.traktor.fx." + fxUnitIdx + ".select.1"; onValueChanged: onFxChanged() }
  AppProperty { id: fxSelect2; path: "app.traktor.fx." + fxUnitIdx + ".select.2" }
  AppProperty { id: fxSelect3; path: "app.traktor.fx." + fxUnitIdx + ".select.3" }
  AppProperty { id: fxDryWet; path: "app.traktor.fx." + fxUnitIdx + ".dry_wet" }
  AppProperty { id: fxParameterName1; path: "app.traktor.fx." + fxUnitIdx + ".knobs.1.name" }
  AppProperty { id: fxParameterName2; path: "app.traktor.fx." + fxUnitIdx + ".knobs.2.name" }
  AppProperty { id: fxParameterName3; path: "app.traktor.fx." + fxUnitIdx + ".knobs.3.name" }
  AppProperty { id: fxParameterValue1; path: "app.traktor.fx." + fxUnitIdx + ".parameters.1" }
  AppProperty { id: fxParameterValue2; path: "app.traktor.fx." + fxUnitIdx + ".parameters.2" }
  AppProperty { id: fxParameterValue3; path: "app.traktor.fx." + fxUnitIdx + ".parameters.3" }

  // Pattern Player properties
  AppProperty { id: currentKit;   path: "app.traktor.fx." + fxUnitIdx + ".kitSelect" }
  AppProperty { id: currentStep;  path: "app.traktor.fx." + fxUnitIdx + ".pattern_player.current_step" }
  AppProperty { id: currentSound; path: "app.traktor.fx." + fxUnitIdx + ".pattern_player.current_sound" }

  // Mixer Mode properties
  AppProperty { id: deckCue; path: "app.traktor.mixer.channels." + deckIdx + ".cue"  }
  AppProperty { id: deckVolume; path: "app.traktor.mixer.channels." + deckIdx + ".volume"  }
  AppProperty { id: deckEqHigh; path: "app.traktor.mixer.channels." + deckIdx + ".eq.high" }
  AppProperty { id: deckEqMid;  path: "app.traktor.mixer.channels." + deckIdx + ".eq.mid"  }
  AppProperty { id: deckEqLow;  path: "app.traktor.mixer.channels." + deckIdx + ".eq.low"  }

  function onFxChanged()
  {
    lastTouchedKnob = 1;
  }

  function onLayerChanged()
  {
    switch(fxSectionLayer)
    {
      case FXSectionLayer.fx_primary:
      case FXSectionLayer.fx_secondary:
        // Defaults to Dry/Wet
        lastTouchedKnob = 1;
        break;

      case FXSectionLayer.mixer:
        // Defaults to Volume
        lastTouchedKnob = 4;
        break;
    }
  }

  function hasParameter(knob)
  {
    switch (fxSectionLayer)
    {
      case FXSectionLayer.fx_primary:
      case FXSectionLayer.fx_secondary:
      {
        switch (fxUnitType.value)
        {
          case FxType.Group:
          {
            switch(knob)
            {
              case 1: return true;
              case 2: return fxSelect1.value !== 0;
              case 3: return fxSelect2.value !== 0;
              case 4: return fxSelect3.value !== 0;
            }

            break;
          }

          case FxType.Single:
          {
            if (fxSelect1.value === 0)
              return false;

            switch(knob)
            {
              case 1: return true;
              case 2: return fxParameterName1.value.length !== 0;
              case 3: return fxParameterName2.value.length !== 0;
              case 4: return fxParameterName3.value.length !== 0;
            }

            break;
          }

          case FxType.PatternPlayer:
            return true;
        }

        break;
      }

      case FXSectionLayer.mixer:
        return true;
    }

    return false;
  }

  function parameterName(knob)
  {
    switch (fxSectionLayer)
    {
      case FXSectionLayer.fx_primary:
      case FXSectionLayer.fx_secondary:
      {
        switch (fxUnitType.value)
        {
          case FxType.Group:
          {
            switch(knob)
            {
              case 1: return "D/W";
              case 2: return DisplayHelpers.effectName(fxSelect1.description);
              case 3: return DisplayHelpers.effectName(fxSelect2.description);
              case 4: return DisplayHelpers.effectName(fxSelect3.description);
            }

            break;
          }

          case FxType.Single:
          {
            return DisplayHelpers.parameterName(fxSelect1.description, knob);
          }

          case FxType.PatternPlayer:
          {
            switch(knob)
            {
              case 1: return "VOL";
              case 2: return "PTRN";
              case 3: return "PTCH";
              case 4: return "DCAY";
            }

            break;
          }
        }

        break;
      }

      case FXSectionLayer.mixer:
      {
        switch(knob)
        {
          case 1: return "HI";
          case 2: return "MID";
          case 3: return "LO";
          case 4: return "VOL";
        }
        break;
      }
    }

    return "";
  }

  function parameterValue(knob)
  {
    switch (fxSectionLayer)
    {
      case FXSectionLayer.fx_primary:
      case FXSectionLayer.fx_secondary:
      {
        switch(knob)
        {
          case 1: return fxDryWet.description;
          case 2: return fxParameterValue1.description;
          case 3: return fxParameterValue2.description;
          case 4: return fxParameterValue3.description;
        }

        break;
      }

      case FXSectionLayer.mixer:
      {
        switch(knob)
        {
          case 1: return (200.0 * deckEqHigh.value - 100.0).toFixed();
          case 2: return (200.0 * deckEqMid.value  - 100.0).toFixed();
          case 3: return (200.0 * deckEqLow.value  - 100.0).toFixed();
          case 4: return (100.0 * deckVolume.value).toFixed();
        }

        break;
      }
    }

    return "";
  }

  MappingProperty { id: blinkerProp; path: "mapping.state.blinker" }
  property alias blinkOnOff: blinkerProp.value

  readonly property bool isSingleGroupFx: (fxSectionLayer === FXSectionLayer.fx_primary || fxSectionLayer === FXSectionLayer.fx_secondary) && (fxUnitType.value !== FxType.PatternPlayer)
  readonly property bool isPatternPlayer: (fxSectionLayer === FXSectionLayer.fx_primary || fxSectionLayer === FXSectionLayer.fx_secondary) && (fxUnitType.value === FxType.PatternPlayer)

  Rectangle {
    color: "black"
    anchors.fill: parent

    Item
    {
      visible: deviceSetupState == DeviceSetupState.assigned
      anchors.fill: parent

      // Single/Group Fx Title
      ThickText {
        visible: isSingleGroupFx

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 0
            leftMargin: 1
        }

        text: fxUnitType.value === FxType.Single ? fxSelect1.description : "FX GROUP"
        wrapMode: Text.Wrap
      }

      // Pattern Player Kit
      ThickText {
        visible: isPatternPlayer

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 0
            leftMargin: 1
        }

        text: currentKit.description
        wrapMode: Text.NoWrap
      }

      // Pattern Player Sound
      ThickText {
        visible: isPatternPlayer

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 16
            leftMargin: 1
        }

        text: currentSound.description
        wrapMode: Text.NoWrap
      }

      // Pattern Player view
      Item
      {
        visible: isPatternPlayer && !knobsAreActive
        anchors.fill: parent

        Repeater
        {
          model: 16
          Rectangle
          {
            AppProperty { id: stepState;  path: "app.traktor.fx." + fxUnitIdx + ".pattern_player.steps." + (index + 1) + ".state"  }

            anchors {
              left: parent.left
              bottom: parent.bottom
              leftMargin: (index % 8) * 16
              bottomMargin: (index < 8) ? 16 : 0
            }
            border {
              width: 1
              color: "white"
            }

            width: 12
            height: 12
            color: stepState.value ? "white" : "black"

            Rectangle
            {
                visible: currentStep.value == index

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                width: 4
                height: 4
                color: stepState.value ? "black" : "white"
            }
          }
        }
      }

      // Parameter overlay
      Item
      {
        visible: knobsAreActive || !isPatternPlayer
        anchors.fill: parent

        Image {
          anchors {
              top: parent.top
              left: parent.left
          }

          source:    "Images/Indicator.png"
          fillMode:  Image.PreserveAspectFit
          visible: fxSectionLayer == FXSectionLayer.mixer && deckCue.value
        }

        ThinText {
            anchors {
                bottom: parent.bottom
                left: parent.left
                leftMargin: -13
                bottomMargin: -5
            }
            font.capitalization: Font.AllUppercase
            text: " " + (hasParameter(lastTouchedKnob) ? parameterName(lastTouchedKnob) : "EMPTY")
        }

        ThinText {
            id: valueText

            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: -5
                rightMargin: -3
            }
            font.capitalization: Font.AllUppercase
            text: " " + (hasParameter(lastTouchedKnob) ? parameterValue(lastTouchedKnob) : "")
        }

        AnimatedImage {
            anchors {
                bottom: parent.bottom
                right: valueText.left
                rightMargin: -10
            }
            visible:   (softTakeoverDirection !== 0) && hasParameter(lastTouchedKnob)
            source:    softTakeoverDirection === 1 ? "Images/SoftTakeoverUp.gif" : "Images/SoftTakeoverDown.gif"
            fillMode:  Image.PreserveAspectFit
        }
      }
    }

    // Deck assignment
    Item {
      visible: deviceSetupState == DeviceSetupState.unassigned
      anchors.fill: parent

      Rectangle {
        color: blinkOnOff ? "white" : "black"
        anchors {
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
        }

        width: 120
        height: 44

        ThinText {
          anchors {
            top: parent.top
            left: parent.left
            topMargin: -10
            leftMargin: -20
          }
          font.pixelSize: 60
          font.capitalization: Font.AllUppercase

          text: " " + fxText[primaryFxUnitProp.value - 1]
          color: blinkOnOff ? "black" : "white"
        }
      }
    }
  }
}
