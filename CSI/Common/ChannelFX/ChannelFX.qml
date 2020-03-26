import CSI 1.0
import "../../../Defines"

Module
{
  id: module
  property int index: 1
  property alias selectedFx: fxSelect
  property int channelFxSelectorVal: -1
  property string surface: ""

  signal fxChanged()

  // helpers
  readonly property string surface_prefix: surface + ".mixer.channels." + module.index + "."
  readonly property string app_prefix: "app.traktor.mixer.channels." + module.index + "."

  AppProperty { id: fxSelect; path: app_prefix + "fx.select"; }
  AppProperty { id: fxOn;     path: app_prefix + "fx.on" }

  readonly property variant currentColor: colorScheme[fxSelect.value]

  // Channel FX Knob + Enable
  Wire { from: surface_prefix + "channel_fx.amount"; to: DirectPropertyAdapter { path: app_prefix + "fx.adjust" } }

  Wire
  {
    enabled: module.channelFxSelectorVal == -1;
    from: surface_prefix + "channel_fx.on";
    to: TogglePropertyAdapter
    {
      path: app_prefix + "fx.on";
      color: module.currentColor;
    }
  }

  Wire
  {
    enabled: module.channelFxSelectorVal != -1;
    from: surface_prefix + "channel_fx.on";
    to: ButtonScriptAdapter
    {
      onPress :
      {
        module.selectedFx.value = module.channelFxSelectorVal;
        fxChanged();
      }
      color: module.currentColor;
      brightness: fxOn.value ? 1.0 : 0.5
    }
  }
}
