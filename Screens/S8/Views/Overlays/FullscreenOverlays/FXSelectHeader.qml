import QtQuick 2.0
import CSI 1.0

// draws the header area respecting selected fx and selection
Item {
  id: header
  property int fxUnitId: 0

  property          string  fxUnitName:  "FX UNIT " + (fxUnitId + 1)   // used to compose the selcted fxunit name for header tab
  readonly property variant headerNames: getHeaderTexts()

  readonly property int macroEffectChar:  0x00B6

  AppProperty { id: fxSelectProp1;    path: "app.traktor.fx." + (fxUnitId + 1) + ".select.1" }
  AppProperty { id: fxSelectProp2;    path: "app.traktor.fx." + (fxUnitId + 1) + ".select.2" }
  AppProperty { id: fxSelectProp3;    path: "app.traktor.fx." + (fxUnitId + 1) + ".select.3" }
  AppProperty { id: patternPlayerKitSelection; path: "app.traktor.fx." + (fxUnitId + 1) + ".pattern_player.kit_shortname" }
  AppProperty { id: patternPlayerEnabled; path: "app.traktor.settings.pro.plus.pattern_player" }

  Row {
    spacing: 1
    anchors.fill: parent
    Repeater {
      model: 4

      Rectangle {
        width: ( index == 0 ) ? 120 : 119 // 1st tab 1px wider
        height: 19
        color: (index==fxSelect.activeTab) ? colors.colorOrange : colors.colorFxHeaderBg

        readonly property bool isMacroFx: (headerNames[index].charCodeAt(0) == macroEffectChar)

        Rectangle {
          id: macroIcon
          anchors.verticalCenter: parent.verticalCenter
          anchors.left: parent.left
          anchors.leftMargin: 5
          width: 12
          height: 11
          radius: 1
          visible: isMacroFx && ( (index<2) || (fxViewSelectProp.value==FxType.Group) )
          color: (index == fxSelect.activeTab) ? colors.colorBlack85 : colors.colorGrey80

          Text {
            anchors.fill: parent
            anchors.topMargin: -1
            anchors.leftMargin: 1
            text: "M"
            font.pixelSize: fonts.miniFontSize
            color: (index == fxSelect.activeTab) ? colors.colorOrange : colors.colorBlack
            visible: isMacroFx && ( (index<2) || (fxViewSelectProp.value==FxType.Group) )
          }
        }

        Text {
          visible: (index<2) || (fxViewSelectProp.value==FxType.Group)
          anchors.centerIn: parent
          anchors.fill: parent
          anchors.topMargin: 2
          anchors.leftMargin: (headerNames[index].charCodeAt(0) == macroEffectChar)? 20 : 5
          anchors.rightMargin: 3
          font.pixelSize: fonts.smallFontSize
          font.capitalization: Font.AllUppercase
          color: (index==fxSelect.activeTab) ? colors.colorBlack : colors.colorFontBrowserHeader
          text: isMacroFx ? headerNames[index].substr(1) : headerNames[index]
          clip: true
          elide: Text.ElideRight
        }
      }
    }
  }

  function getHeaderTexts()
  {
    if (patternPlayerEnabled.value && fxViewSelectProp.value == FxType.PatternPlayer)
    {
      return [fxUnitName, patternPlayerKitSelection.description, "", ""];
    }

    return [fxUnitName, fxSelectProp1.description, fxSelectProp2.description, fxSelectProp3.description];
  }
}
