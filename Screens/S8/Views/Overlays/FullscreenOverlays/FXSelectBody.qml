import QtQuick 2.0
import Qt5Compat.GraphicalEffects
import CSI 1.0

import '../../../../../Defines'


Item {
  id: fxSelectBody

  property string propertiesPath: ""
  property int  navMenuValue:    0
  property int  preNavMenuValue: 0
  property bool navMenuSelected: false
  property int  fxUnitId:        0
  property int  activeTab:       1
  property int  currentView:     (activeTab === FxOverlay.upper_button_1) ? 2 : ((activeTab < FxOverlay.lower_button_1) || (fxViewSelectProp.value === FxType.Group) ? 1 : 0)
  readonly property bool patternPlayerFxViewSelected: (fxViewSelectProp.value === FxType.PatternPlayer)

  readonly property int delegateHeight:   27
  readonly property int emptyView:        0
  readonly property int tableView:        1
  readonly property int settingsView:     2
  readonly property int macroEffectChar:  0x00B6

  clip:                 true
  anchors.margins:      5
  anchors.bottomMargin: 10

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { 
    id: fxSelectProp 
    path: "app.traktor.fx." + (fxUnitId+1) + ".select." + Math.max(1, activeTab)
    onValueChanged: { updateFxSelection(); }
  }
  
  AppProperty {
    id: kitSelectProp
    path: "app.traktor.fx." + (fxUnitId+1) + ".kitSelect"
    onValueChanged: { updateFxSelection(); }
  }

  AppProperty { id: patternPlayerEnabled; path: "app.traktor.settings.pro.plus.pattern_player" }

  MappingProperty{ id: screenOverlay;  path: propertiesPath + ".overlay" }

  onVisibleChanged: { updateFxSelection(); }

  function updateFxSelection() {
    if ((currentView === tableView) && (fxSelectProp.value !== undefined))
    {
      preNavMenuValue     = navMenuValue; 
      navMenuValue        = patternPlayerFxViewSelected ? kitSelectProp.value : fxSelectProp.value;
      fxList.currentIndex = patternPlayerFxViewSelected ? kitSelectProp.value : fxSelectProp.value;
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  // effects list
  ListView {
    id: fxList
    anchors.top:       parent.top
    anchors.left:      parent.left
    anchors.right:     parent.right
    anchors.topMargin: 33
    height:            189
    clip:              true

    preferredHighlightBegin:     3*delegateHeight //- 6
    preferredHighlightEnd:       4*delegateHeight //- 6
    highlightRangeMode :         ListView.ApplyRange
    highlightMoveVelocity:     800
    highlightMoveDuration:       10
    highlightFollowsCurrentItem: true

    visible: (currentView === tableView)
    model:   patternPlayerFxViewSelected ? kitSelectProp.valuesDescription : fxSelectProp.valuesDescription

    delegate:
    Item {
      anchors.horizontalCenter: parent.horizontalCenter
      height: delegateHeight // item (= line) height
      width: fxList.width
      
      readonly property bool isMacroFx: (modelData.charCodeAt(0) === macroEffectChar)

      // Macro FX
      Image {
        id: macroIcon
        source:              "./../../Images/Fx_Multi_Icon_Large.png"
        fillMode:            Image.PreserveAspectCrop
        width:               sourceSize.width
        height:              sourceSize.height
        anchors.right:       fxName.left
        anchors.top:         parent.top
        anchors.rightMargin: 5
        anchors.topMargin:   5
        visible:             false  
        smooth:              false    
      }

      // grey color overlay (overwritten by selected color overlay)
      ColorOverlay {
        anchors.fill: macroIcon
        source: macroIcon
        color:  colors.colorGrey56
        visible: isMacroFx
      }

      Text {
        id: fxName
        anchors.centerIn: parent

        anchors.horizontalCenterOffset: isMacroFx ? 10 : 0
        font.pixelSize: fonts.largeFontSize
        font.capitalization: Font.AllUppercase
        color: colors.colorFontsListFx
        text: isMacroFx? modelData.substr(1) : modelData
      }

      Component.onCompleted: {
        z = -1
      }
    }


    // selection
    highlight: 
    Item {
      // This item is only used as a marker, so that it can later be reference by the color overlay that has
      // to be defined outside of the list view
      id: highlightItem
      width: fxList.width
    }
  }

  Rectangle {
    id: highlightRect
    visible: (currentView === tableView)

    color: "black"
    width: fxList.width
    height: fxList.highlightItem ? fxList.highlightItem.height - 2 : 0.0
    x: fxList.highlightItem ? fxList.highlightItem.x + fxList.x : 0.0
    y: fxList.highlightItem ? fxList.highlightItem.y + fxList.y - fxList.contentY : 0.0

    clip: true

    ColorOverlay {
      color: colors.colorOrange
      width: fxList.width
      height: fxList.height
      y: fxList.highlightItem ? fxList.contentY - fxList.highlightItem.y : 0.0
      source: fxList
    }
    // top line
    Rectangle { 
      width:              parent.width
      height:             1
      anchors.top:        parent.top
      color:              colors.colorOrange
    }
    // bottom line
    Rectangle { 
      width:              parent.width
      height:             1
      anchors.bottom:     parent.bottom
      color:              colors.colorOrange
    }
  }

  //------------------------------------------------------------------------------------------------------------------
  // This is the FX UNIT settings View 
  Item {
    id: setting

    property int currentBtn:   0
    property int currentIndex: setting.btnToIndexMap[ setting.currentBtn ]

    property var btnToProperty: [fxViewSelectProp, fxRoutingProp, fxStoreProp, fxViewSelectProp, fxRoutingProp, null, fxViewSelectProp, fxRoutingProp]
    property var btnToValue: [FxType.Group, FxRouting.Send, true, FxType.Single, FxRouting.Insert, null, patternPlayerEnabled.value ? FxType.PatternPlayer : null, FxRouting.PostFader]

    readonly property var btnNames: [ "Group" , "Send" , "Snapshot" , "Single" , "Insert" , "-" , patternPlayerEnabled.value ? "Pattern Player" : "-" , "Post Fader" , "-" ]
    readonly property var btnToIndexMap: patternPlayerEnabled.value ? [ 0 , 3 , patternPlayerBtn , 1 , 4 , 7 , snapshotBtn ] : [ 0 , 3 , 1 , 4 , 7 , snapshotBtn ]
    readonly property int snapshotBtn: 2
    readonly property int patternPlayerBtn: 6
    readonly property int buttonCount: btnToIndexMap.length

    anchors.fill:      parent
    visible:           (currentView === settingsView)

    Grid {
      columns: 3
      rows:    3
      columnSpacing: 27
      rowSpacing:    5
      anchors.centerIn: parent
      anchors.verticalCenterOffset: 3

      Repeater {
        model: 9

        // buttons
        Rectangle {
          width: 130
          height: 29
          color: colors.colorGrey16
          border.width: 1
          opacity: (setting.btnNames[ index ] !== "-") ? 1 : 0
          border.color: (index===setting.currentIndex) ? colors.colorOrange : colors.colorGrey32

          Text {
            anchors.horizontalCenter: (index === setting.snapshotBtn) ? parent.horizontalCenter : undefined 
            anchors.verticalCenter: parent.verticalCenter
            x: 9
            font.pixelSize: fonts.middleFontSize
            text: setting.btnNames[index]
            color: (index === setting.currentIndex) ? colors.colorOrange : colors.colorFontFxHeader
          }

          // radio buttons
          Rectangle {
            visible: (index !== setting.snapshotBtn)
            width: 8
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -1
            anchors.right: parent.right
            anchors.rightMargin: 9
            radius: 4
            border.width: 1
            border.color: (isButtonAtIndexSelected(index) || index === setting.currentIndex) ? colors.colorOrange : colors.colorGrey72
            color: isButtonAtIndexSelected(index) ? colors.colorOrange : "transparent"
          }
        }
      }
    }
  }


  //------------------------------------------------------------------------------------------------------------------

  onNavMenuSelectedChanged: 
  {
    if (navMenuSelected)
    {
      if (currentView === settingsView)
      {
        setting.btnToProperty[setting.currentIndex].value = setting.btnToValue[setting.currentIndex];
      }
      else if (currentView === tableView)
      {
        if (patternPlayerFxViewSelected)
        {
            kitSelectProp.value = fxList.currentIndex;
        }
        else
        {
            fxSelectProp.value = fxList.currentIndex;
        }
        // auto close for single & group fx
        screenOverlay.value = Overlay.none;
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------

  onNavMenuValueChanged: { 
    var delta = navMenuValue - preNavMenuValue;
    preNavMenuValue = navMenuValue;

    if (currentView === settingsView) 
    {
      var btn            = setting.currentBtn;
      btn                = (btn + delta) % setting.buttonCount;
      setting.currentBtn = (btn < 0) ? setting.buttonCount + btn : btn;
    }
    else if (currentView === tableView)
    {
      var index = fxList.currentIndex + delta;
      fxList.currentIndex = clamp(index, 0, fxList.count-1);
    }
  }

  //------------------------------------------------------------------------------------------------------------------

  function clamp(value, min, max) {
    return Math.max(min, Math.min(value, max));
  }

  //------------------------------------------------------------------------------------------------------------------

  function isButtonAtIndexSelected(index) 
  {
    // Treat snapshot property different as it's only write accesible (you can't read .value)
    if (index === setting.snapshotBtn)
    {
      return false;
    }

    // Some buttons are hidden and have no property or value to assign
    // Thus they can't be selected
    if (setting.btnToProperty[index] == null || setting.btnToValue[index] == null)
    {
      return false;
    }

    return setting.btnToProperty[index].value === setting.btnToValue[index]
  }
}
