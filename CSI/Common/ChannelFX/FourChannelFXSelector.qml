import CSI 1.0

Module
{
  id: module
  property bool cancelMultiSelection: false
  property int currentlySelectedFx: -1
  property string surface: ""

  readonly property string surfacePrefix: surface + ".mixer.channel_fx"

  // Mixer Effects Color Scheme
  readonly property variant colorScheme: [
    Color.LightOrange,  // Filter
    Color.Red,          // FX1
    Color.Green,        // FX2
    Color.Blue,         // FX3
    Color.Yellow        // FX4
  ]

   // Channel Fx
  ChannelFX
  {
    id: channel1
    name: "channel1"
    surface: module.surface
    index: 1
    onFxChanged : { module.cancelMultiSelection = true; }
    channelFxSelectorVal: module.currentlySelectedFx
  }

  ChannelFX
  {
    id: channel2
    name: "channel2"
    surface: module.surface
    index: 2
    onFxChanged : { module.cancelMultiSelection = true; }
    channelFxSelectorVal: module.currentlySelectedFx
  }

  ChannelFX
  {
    id: channel3
    name: "channel3"
    surface: module.surface
    index: 3
    onFxChanged : { module.cancelMultiSelection = true; }
    channelFxSelectorVal: module.currentlySelectedFx
  }

  ChannelFX
  {
    id: channel4
    name: "channel4"
    surface: module.surface
    index: 4
    onFxChanged : { module.cancelMultiSelection = true; }
    channelFxSelectorVal: module.currentlySelectedFx
  }

  function onFxSelectReleased(fxSelection)
  {
    if (!module.cancelMultiSelection)
    {
      channel1.selectedFx.value = fxSelection;
      channel2.selectedFx.value = fxSelection;
      channel3.selectedFx.value = fxSelection;
      channel4.selectedFx.value = fxSelection;
    }
    if (module.currentlySelectedFx == fxSelection)
      module.currentlySelectedFx = -1;
  }

  function onFxSelectPressed(fxSelection)
  {
    module.cancelMultiSelection = (module.currentlySelectedFx != -1);
    module.currentlySelectedFx = fxSelection;
  }

  function isFxUsed(index)
  {
    return channel1.selectedFx.value == index ||
           channel2.selectedFx.value == index ||
           channel3.selectedFx.value == index ||
           channel4.selectedFx.value == index;
  }

  function ledBrightness(on)
  {
    return on ? 1.0 : 0.0;
  }

  Wire
  {
    from: surfacePrefix + ".filter";
    to: ButtonScriptAdapter
    {
      onPress :
      {
        onFxSelectPressed(0)
      }
      onRelease :
      {
        onFxSelectReleased(0);
      }
      color: module.colorScheme[0]
      brightness: ledBrightness(isFxUsed(0))
    }
  }
  Wire
  {
    from: surfacePrefix + ".fx1";
    to: ButtonScriptAdapter
    {
      onPress :
      {
        onFxSelectPressed(1)
      }
      onRelease :
      {
        onFxSelectReleased(1);
      }
      color: module.colorScheme[1]
      brightness: ledBrightness(isFxUsed(1))
    }
  }
  Wire
  {
    from: surfacePrefix + ".fx2";
    to: ButtonScriptAdapter
    {
      onPress :
      {
        onFxSelectPressed(2)
      }
      onRelease :
      {
        onFxSelectReleased(2);
      }
      color: module.colorScheme[2]
      brightness: ledBrightness(isFxUsed(2))
    }
  }
  Wire
  {
    from: surfacePrefix + ".fx3";
    to: ButtonScriptAdapter
    {
      onPress :
      {
        onFxSelectPressed(3)
      }
      onRelease :
      {
        onFxSelectReleased(3);
      }
      color: module.colorScheme[3]
      brightness: ledBrightness(isFxUsed(3))
    }
  }
  Wire
  {
    from: surfacePrefix + ".fx4";
    to: ButtonScriptAdapter
    {
      onPress :
      {
        onFxSelectPressed(4)
      }
      onRelease :
      {
        onFxSelectReleased(4);
      }
      color: module.colorScheme[4]
      brightness: ledBrightness(isFxUsed(4))
    }
  }
}
