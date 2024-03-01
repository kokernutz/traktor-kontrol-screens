import CSI 1.0

import "Defines"

Module
{
  id: module
  property bool shift: false
  property bool active: false 
  property string surface: ""
  property string propertiesPath: ""

  property int leftDeckIdx: 0
  property int rightDeckIdx: 0

  property int leftPrimaryFxIdx: 0
  property int rightPrimaryFxIdx: 0
  property int leftSecondaryFxIdx: 0
  property int rightSecondaryFxIdx: 0

  //------------------------SUBMODULES----------------------------

  MappingPropertyDescriptor { id: layerProp; path: module.propertiesPath + ".fx_section_layer"; type: MappingPropertyDescriptor.Integer; value: FXSectionLayer.fx_primary }
  property alias layer: layerProp.value

  MappingPropertyDescriptor { path: module.propertiesPath + ".left_deck_index"; type: MappingPropertyDescriptor.Integer; value: module.leftDeckIdx }
  MappingPropertyDescriptor { path: module.propertiesPath + ".right_deck_index"; type: MappingPropertyDescriptor.Integer; value: module.rightDeckIdx }
  MappingPropertyDescriptor { path: module.propertiesPath + ".left_fx_index"; type: MappingPropertyDescriptor.Integer; value: leftFxUnit(module.layer) }
  MappingPropertyDescriptor { path: module.propertiesPath + ".right_fx_index"; type: MappingPropertyDescriptor.Integer; value: rightFxUnit(module.layer) }

  function leftFxUnit(layer)
  {
    switch(layer)
    {
      case FXSectionLayer.fx_primary: return module.leftPrimaryFxIdx;
      case FXSectionLayer.fx_secondary: return module.leftSecondaryFxIdx;

      default: return 1;
    }
  }

  function rightFxUnit(layer)
  {
    switch(layer)
    {
      case FXSectionLayer.fx_primary: return module.rightPrimaryFxIdx;
      case FXSectionLayer.fx_secondary: return module.rightSecondaryFxIdx;

      default: return 1;
    }
  }

  Wire
  {
    enabled: module.active
    from: "%surface%.mode"
    to: ButtonScriptAdapter {
            color: Color.LightOrange
            onPress: {
              switch (module.layer)
              {
                case FXSectionLayer.fx_primary:
                  module.layer = (fxMode.value == FxMode.TwoFxUnits ? FXSectionLayer.mixer : FXSectionLayer.fx_secondary);
                  break;

                case FXSectionLayer.fx_secondary:
                  module.layer = FXSectionLayer.mixer;
                  break;

                case FXSectionLayer.mixer:
                  module.layer = FXSectionLayer.fx_primary;
                  break;
              }
            }
      }
  }

  // Effects Mode
  AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units"; onValueChanged: fxModeChanged(); }

  function fxModeChanged()
  {
    if (fxMode.value == FxMode.TwoFxUnits && module.layer == FXSectionLayer.fx_secondary)
    {
      module.layer = FXSectionLayer.fx_primary;
    }
  }

  X1MK3FXSectionSide
  {
    name: "left_side"

    shift: module.shift
    active: module.active
    surface: module.surface + ".left.fx"
    propertiesPath: module.propertiesPath + ".left.fx"

    layer: module.layer
    deckIdx: module.leftDeckIdx
    primaryUnitIdx: module.leftPrimaryFxIdx
    secondaryUnitIdx: module.leftSecondaryFxIdx
  }

  X1MK3FXSectionSide
  {
    name: "right_side"

    shift: module.shift
    active: module.active
    surface: module.surface + ".right.fx"
    propertiesPath: module.propertiesPath + ".right.fx"

    layer: module.layer
    deckIdx: module.rightDeckIdx
    primaryUnitIdx: module.rightPrimaryFxIdx
    secondaryUnitIdx: module.rightSecondaryFxIdx
  }
}
