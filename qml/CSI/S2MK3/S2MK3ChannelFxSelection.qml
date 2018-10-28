import CSI 1.0

Module
{
  id: module

  // Monolithic Channel FX Selection Property:
  // Is wired to the buttons, a change will be applied to the application.

  MappingPropertyDescriptor {
    id: channelFxSelection;
    path: "mapping.state.channelFxSelection";
    type: MappingPropertyDescriptor.Integer;
    value: 0;
    onValueChanged: {
      if(channelFxSelection.value == 0)
      {
        fxOn1.value = false;
        fxOn2.value = false;
      }
      else
      {
        fxOn1.value = true;
        fxOn2.value = true;
        fxSelect1.value = channelFxSelection.value;
        fxSelect2.value = channelFxSelection.value;
      }
    }
  }

  Wire { from: "s2mk3.mixer.channel_fx.fx1";            to: TogglePropertyAdapter { path: "mapping.state.channelFxSelection"; value: 1 } }
  Wire { from: "s2mk3.mixer.channel_fx.fx2";            to: TogglePropertyAdapter { path: "mapping.state.channelFxSelection"; value: 2 } }
  Wire { from: "s2mk3.mixer.channel_fx.fx3";            to: TogglePropertyAdapter { path: "mapping.state.channelFxSelection"; value: 3 } }
  Wire { from: "s2mk3.mixer.channel_fx.fx4";            to: TogglePropertyAdapter { path: "mapping.state.channelFxSelection"; value: 4 } }

  AppProperty { id: fxSelect1; path: "app.traktor.mixer.channels.1.fx.select" }
  AppProperty { id: fxSelect2; path: "app.traktor.mixer.channels.2.fx.select" }
  AppProperty { id: fxOn1;     path: "app.traktor.mixer.channels.1.fx.on" }
  AppProperty { id: fxOn2;     path: "app.traktor.mixer.channels.2.fx.on" }
}
