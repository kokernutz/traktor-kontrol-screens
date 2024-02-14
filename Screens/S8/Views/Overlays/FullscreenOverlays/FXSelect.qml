import CSI 1.0
import QtQuick 2.0

import '../../../../../Defines'


Rectangle {
  id: fxSelect
  property string  propertiesPath:  ""
  property alias   navMenuValue:    body.navMenuValue
  property alias   navMenuSelected: body.navMenuSelected
  property variant deckIds:         (isLeftScreen) ? [0, 2] : [1, 3]
  property int     fxUnitId:        deckIds[ ((fxSelectionState.value < FxOverlay.lower_button_1) || (fx4Mode.value == FxMode.TwoFxUnits)) ? 0 : 1 ] // denotes if upper or lower fx unit is seleted
  property int     activeTab:       FxOverlay.upper_button_1

  anchors.fill: parent
  color:        colors.colorBlack

  //--------------------------------------------------------------------------------------------------------------------
  
  AppProperty { id: fxStoreProp;      path: "app.traktor.fx." + (fxUnitId + 1) + ".store" }
  AppProperty { id: fxRoutingProp;    path: "app.traktor.fx." + (fxUnitId + 1) + ".routing" }
  AppProperty { id: fxViewSelectProp; path: "app.traktor.fx." + (fxUnitId + 1) + ".type"; onValueChanged: { updateActiveTab(); } } 
  AppProperty { id: fx4Mode;          path: "app.traktor.fx.4fx_units" }

  MappingProperty { id: fxSelectionState; path: propertiesPath +  ".fx_button_selection"; onValueChanged: { updateActiveTab(); } }

  //--------------------------------------------------------------------------------------------------------------------
         
  // the list with the fx area 
  FXSelectBody {
    id: body
    anchors.fill:         parent
    fxUnitId:             fxSelect.fxUnitId
    activeTab:            fxSelect.activeTab 
    propertiesPath:       fxSelect.propertiesPath
  }

  //--------------------------------------------------------------------------------------------------------------------
  // draws the header area respecting selected fx and selection

  FXSelectHeader {
    id: header
    width:    overlay.width
    height:   30
    fxUnitId: fxSelect.fxUnitId
  }

  //--------------------------------------------------------------------------------------------------------------------

  function updateActiveTab()
  {
    if (fxSelectionState.value != undefined)
    {
      activeTab = fxSelectionState.value % FxOverlay.lower_button_1;
      if(fxViewSelectProp.value != FxType.Group)
      {
        if(activeTab > FxOverlay.upper_button_2) 
        {
          activeTab = FxOverlay.upper_button_2;
        }
      }
    }
  }
}
