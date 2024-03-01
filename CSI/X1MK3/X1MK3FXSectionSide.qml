import CSI 1.0

import "Defines"

Module
{
  id: module
  property bool shift: false
  property bool active: false
  property int layer: 0
  property int deckIdx: 0
  property int primaryUnitIdx: 0
  property int secondaryUnitIdx: 0
  property string surface: ""
  property string propertiesPath: ""

  //------------------------SUBMODULES----------------------------

  MappingPropertyDescriptor { path: module.propertiesPath + ".active_deck"; type: MappingPropertyDescriptor.Integer; value: module.deckIdx }
  MappingPropertyDescriptor { path: module.propertiesPath + ".primary_fx_unit"; type: MappingPropertyDescriptor.Integer; value: module.primaryUnitIdx }
  MappingPropertyDescriptor { path: module.propertiesPath + ".secondary_fx_unit"; type: MappingPropertyDescriptor.Integer; value: module.secondaryUnitIdx }

  MappingPropertyDescriptor { id: lastActiveKnobProp; path: module.propertiesPath + ".last_active_knob"; type: MappingPropertyDescriptor.Integer; value: 1 }

  // Screen
  KontrolScreen { name: "fx_screen"; propertiesPath: module.propertiesPath; flavor: ScreenFlavor.X1MK3_FX }
  Wire { from: "fx_screen.output"; to: "%surface%.display" }

  MappingPropertyDescriptor { path: module.propertiesPath + ".knobs_are_active"; type: MappingPropertyDescriptor.Boolean; value: false }
  SwitchTimer { name: "knobs_activity_timer"; setTimeout: 0; resetTimeout: 1000 }

  // Knobs activity
  WiresGroup
  {
    enabled: module.active

    Wire {
      from: Or
      {
        inputs:
        [
          "%surface%.knobs.1.is_turned",
          "%surface%.knobs.2.is_turned",
          "%surface%.knobs.3.is_turned",
          "%surface%.knobs.4.is_turned"
        ]
      }
      to: "knobs_activity_timer.input"
    }

    Wire { from: "knobs_activity_timer.output.value"; to: ValuePropertyAdapter { path: module.propertiesPath + ".knobs_are_active"; output: false } }

    Wire { from: "%surface%.knobs.1"; to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 1 } } }
    Wire { from: "%surface%.knobs.2"; to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 2 } } }
    Wire { from: "%surface%.knobs.3"; to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 3 } } }
    Wire { from: "%surface%.knobs.4"; to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 4 } } }
  }

  // Soft takeover
  SoftTakeover { name: "softtakeover1" }
  SoftTakeover { name: "softtakeover2" }
  SoftTakeover { name: "softtakeover3" }
  SoftTakeover { name: "softtakeover4" }

  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.1.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.2.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.3.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.4.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }

  WiresGroup
  {
    enabled: module.active

    Wire { from: "%surface%.knobs.1"; to: "softtakeover1.input" }
    Wire { from: "%surface%.knobs.2"; to: "softtakeover2.input" }
    Wire { from: "%surface%.knobs.3"; to: "softtakeover3.input" }
    Wire { from: "%surface%.knobs.4"; to: "softtakeover4.input" }

    Wire { from: "softtakeover1.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.1.direction" } }
    Wire { from: "softtakeover2.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.2.direction" } }
    Wire { from: "softtakeover3.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.3.direction" } }
    Wire { from: "softtakeover4.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.4.direction" } }
  }

  // FX units
  FxUnit { name: "fx_unit_1"; channel: 1 }
  FxUnit { name: "fx_unit_2"; channel: 2 }
  FxUnit { name: "fx_unit_3"; channel: 3 }
  FxUnit { name: "fx_unit_4"; channel: 4 }

  AppProperty { id: fxUnit1Type; path: "app.traktor.fx.1.type" }
  AppProperty { id: fxUnit2Type; path: "app.traktor.fx.2.type" }
  AppProperty { id: fxUnit3Type; path: "app.traktor.fx.3.type" }
  AppProperty { id: fxUnit4Type; path: "app.traktor.fx.4.type" }

  WiresGroup
  {
    enabled: module.active

    WiresGroup
    {
      enabled: (module.layer === FXSectionLayer.fx_primary && module.primaryUnitIdx === 1) ||
               (module.layer === FXSectionLayer.fx_secondary && module.secondaryUnitIdx === 1)

      WiresGroup
      {
        enabled: !shift

        Wire { from: "%surface%.buttons.1";   to: "fx_unit_1.enabled" }
        Wire { from: "%surface%.buttons.2";   to: "fx_unit_1.button1" }
        Wire { from: "%surface%.buttons.3";   to: "fx_unit_1.button2" }
        Wire { from: "%surface%.buttons.4";   to: "fx_unit_1.button3" }

        Wire { from: "softtakeover1.output"; to: "fx_unit_1.dry_wet" }
        Wire { from: "softtakeover2.output"; to: "fx_unit_1.knob1" }
        Wire { from: "softtakeover3.output"; to: "fx_unit_1.knob2" }
        Wire { from: "softtakeover4.output"; to: "fx_unit_1.knob3" }
      }

      WiresGroup
      {
        enabled: shift

        WiresGroup
        {
          enabled: fxUnit1Type.value == FxType.Single

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.type"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.select.1"; mode: RelativeMode.Decrement; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
        }

        WiresGroup
        {
          enabled: fxUnit1Type.value == FxType.Group

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.type"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.select.2"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.4";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.select.3"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
        }

        WiresGroup
        {
          enabled: fxUnit1Type.value == FxType.PatternPlayer

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.type"; mode: RelativeMode.Increment; wrap: true; color: Color.Mint } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.kitSelect"; mode: RelativeMode.Decrement; wrap: true; color: Color.Mint } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.kitSelect"; mode: RelativeMode.Increment; wrap: true; color: Color.Mint } }
        }
      }
    }

    WiresGroup
    {
      enabled: (module.layer === FXSectionLayer.fx_primary && module.primaryUnitIdx === 2) ||
               (module.layer === FXSectionLayer.fx_secondary && module.secondaryUnitIdx === 2)

      WiresGroup
      {
        enabled: !shift

        Wire { from: "%surface%.buttons.1";   to: "fx_unit_2.enabled" }
        Wire { from: "%surface%.buttons.2";   to: "fx_unit_2.button1" }
        Wire { from: "%surface%.buttons.3";   to: "fx_unit_2.button2" }
        Wire { from: "%surface%.buttons.4";   to: "fx_unit_2.button3" }

        Wire { from: "softtakeover1.output"; to: "fx_unit_2.dry_wet" }
        Wire { from: "softtakeover2.output"; to: "fx_unit_2.knob1" }
        Wire { from: "softtakeover3.output"; to: "fx_unit_2.knob2" }
        Wire { from: "softtakeover4.output"; to: "fx_unit_2.knob3" }
      }

      WiresGroup
      {
        enabled: shift

        WiresGroup
        {
          enabled: fxUnit2Type.value == FxType.Single

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.type"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.select.1"; mode: RelativeMode.Decrement; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
        }

        WiresGroup
        {
          enabled: fxUnit2Type.value == FxType.Group

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.type"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.select.2"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.4";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.select.3"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
        }

        WiresGroup
        {
          enabled: fxUnit2Type.value == FxType.PatternPlayer

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.type"; mode: RelativeMode.Increment; wrap: true; color: Color.Mint } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.kitSelect"; mode: RelativeMode.Decrement; wrap: true; color: Color.Mint } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.kitSelect"; mode: RelativeMode.Increment; wrap: true; color: Color.Mint } }
        }
      }
    }

    WiresGroup
    {
      enabled: (module.layer === FXSectionLayer.fx_primary && module.primaryUnitIdx === 3) ||
               (module.layer === FXSectionLayer.fx_secondary && module.secondaryUnitIdx === 3)

      WiresGroup
      {
        enabled: !shift

        Wire { from: "%surface%.buttons.1";   to: "fx_unit_3.enabled" }
        Wire { from: "%surface%.buttons.2";   to: "fx_unit_3.button1" }
        Wire { from: "%surface%.buttons.3";   to: "fx_unit_3.button2" }
        Wire { from: "%surface%.buttons.4";   to: "fx_unit_3.button3" }

        Wire { from: "softtakeover1.output"; to: "fx_unit_3.dry_wet" }
        Wire { from: "softtakeover2.output"; to: "fx_unit_3.knob1" }
        Wire { from: "softtakeover3.output"; to: "fx_unit_3.knob2" }
        Wire { from: "softtakeover4.output"; to: "fx_unit_3.knob3" }
      }

      WiresGroup
      {
        enabled: shift

        WiresGroup
        {
          enabled: fxUnit3Type.value == FxType.Single

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.type"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.select.1"; mode: RelativeMode.Decrement; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
        }

        WiresGroup
        {
          enabled: fxUnit3Type.value == FxType.Group

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.type"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.select.2"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.4";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.select.3"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
        }

        WiresGroup
        {
          enabled: fxUnit3Type.value == FxType.PatternPlayer

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.type"; mode: RelativeMode.Increment; wrap: true; color: Color.Mint } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.kitSelect"; mode: RelativeMode.Decrement; wrap: true; color: Color.Mint } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.kitSelect"; mode: RelativeMode.Increment; wrap: true; color: Color.Mint } }
        }
      }
    }

    WiresGroup
    {
      enabled: (module.layer === FXSectionLayer.fx_primary && module.primaryUnitIdx === 4) ||
               (module.layer === FXSectionLayer.fx_secondary && module.secondaryUnitIdx === 4)

      WiresGroup
      {
        enabled: !shift

        Wire { from: "%surface%.buttons.1";   to: "fx_unit_4.enabled" }
        Wire { from: "%surface%.buttons.2";   to: "fx_unit_4.button1" }
        Wire { from: "%surface%.buttons.3";   to: "fx_unit_4.button2" }
        Wire { from: "%surface%.buttons.4";   to: "fx_unit_4.button3" }

        Wire { from: "softtakeover1.output"; to: "fx_unit_4.dry_wet" }
        Wire { from: "softtakeover2.output"; to: "fx_unit_4.knob1" }
        Wire { from: "softtakeover3.output"; to: "fx_unit_4.knob2" }
        Wire { from: "softtakeover4.output"; to: "fx_unit_4.knob3" }
      }

      WiresGroup
      {
        enabled: shift

        WiresGroup
        {
          enabled: fxUnit4Type.value == FxType.Single

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.type"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.select.1"; mode: RelativeMode.Decrement; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
        }

        WiresGroup
        {
          enabled: fxUnit4Type.value == FxType.Group

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.type"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.select.2"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
          Wire { from: "%surface%.buttons.4";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.select.3"; mode: RelativeMode.Increment; wrap: true; color: Color.LightOrange } }
        }

        WiresGroup
        {
          enabled: fxUnit4Type.value == FxType.PatternPlayer

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.type"; mode: RelativeMode.Increment; wrap: true; color: Color.Mint } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.kitSelect"; mode: RelativeMode.Decrement; wrap: true; color: Color.Mint } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.kitSelect"; mode: RelativeMode.Increment; wrap: true; color: Color.Mint } }
        }
      }
    }
  }

  // Mixer Mode
  readonly property string mixer_prefix: "app.traktor.mixer.channels."

  WiresGroup
  {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 1)

    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.kill_high"; color: Color.Blue } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.kill_mid";  color: Color.Blue } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.kill_low";  color: Color.Blue } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.cue";          color: Color.Blue } }
  }

  WiresGroup
  {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 2)

    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.kill_high"; color: Color.Blue } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.kill_mid";  color: Color.Blue } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.kill_low";  color: Color.Blue } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.cue";          color: Color.Blue } }
  }

  WiresGroup
  {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 3)

    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.kill_high"; color: Color.Blue } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.kill_mid";  color: Color.Blue } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.kill_low";  color: Color.Blue } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.cue";          color: Color.Blue } }
  }

  WiresGroup
  {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 4)

    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.kill_high"; color: Color.Blue } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.kill_mid";  color: Color.Blue } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.kill_low";  color: Color.Blue } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.cue";          color: Color.Blue } }
  }
}
