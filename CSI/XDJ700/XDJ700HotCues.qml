import CSI 1.0

Module
{
    id: module
    property string deckProp: ""
    property int deck: 1
    property bool enabled: true

    Hotcues { name: "hotcues"; channel: deck }

    CuePointsProvider { name: "cuepoints_provider"; channel: module.deck }
    Wire { from: "surface.cue_points"; to: "cuepoints_provider.output"; enabled: module.enabled }

    MappingPropertyDescriptor {
      id: cuePointDelete
      path: deckProp + ".cue_delete"
      type: MappingPropertyDescriptor.Boolean;
    }

    Wire
    {
        from: "surface.delete"
        to: TogglePropertyAdapter { path: deckProp + ".cue_delete" }
        enabled: module.enabled
    }

    WiresGroup
    {
      enabled: !cuePointDelete.value && module.enabled
      Wire { from: "surface.hotcue_a";   to: "hotcues.1.trigger" }
      Wire { from: "surface.hotcue_b";   to: "hotcues.2.trigger" }
      Wire { from: "surface.hotcue_c";   to: "hotcues.3.trigger" }
    }

    AppProperty { path: "app.traktor.decks." + deck + ".track.cue.hotcues.1.exists"; id: hotcue1exists }
    AppProperty { path: "app.traktor.decks." + deck + ".track.cue.hotcues.2.exists"; id: hotcue2exists }
    AppProperty { path: "app.traktor.decks." + deck + ".track.cue.hotcues.3.exists"; id: hotcue3exists }

    WiresGroup
    {
      enabled: cuePointDelete.value && module.enabled
      Wire { from: "surface.hotcue_a";   to: TriggerPropertyAdapter{ path: "app.traktor.decks." + deck + ".track.cue.hotcues.1.delete";  color: Color.Red } enabled: hotcue1exists.value }
      Wire { from: "surface.hotcue_b";   to: TriggerPropertyAdapter{ path: "app.traktor.decks." + deck + ".track.cue.hotcues.2.delete";  color: Color.Red } enabled: hotcue2exists.value }
      Wire { from: "surface.hotcue_c";   to: TriggerPropertyAdapter{ path: "app.traktor.decks." + deck + ".track.cue.hotcues.3.delete";  color: Color.Red } enabled: hotcue3exists.value }
    }
}
