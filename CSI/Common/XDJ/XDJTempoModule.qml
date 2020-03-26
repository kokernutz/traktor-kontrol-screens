import CSI 1.0

Module
{
    id: module
    property string deckProp: ""
    property int deck: 1
    property bool enabled: true

    function enforceSupportedRange()
    {
        tempoRangeSwitch.enforceSupportedRange();
    }

    XDJTempoRangeSwitch { id: tempoRangeSwitch; name: "tempo_range"; deck: module.deck; enabled: module.enabled }

    MappingPropertyDescriptor
    {
        id: faderMode
        path: deckProp + "tempo_fader_relative";
        type: MappingPropertyDescriptor.Boolean;
        value: false;
    }

    DirectPropertyAdapter { name: "tempo_fader_relative"; path: faderMode.path; input: false }
    Wire{ from: "tempo_fader_relative"; to: "tempo_control.enable_relative_mode"; enabled: module.enabled }

    TempoControl { name: "tempo_control"; channel: deck }
    WiresGroup
    {
        enabled: module.enabled
        Wire { from: "surface.master_tempo";  to: TogglePropertyAdapter { path: "app.traktor.decks." + module.deck + ".track.key.lock_enabled"; } }
        Wire { from: "surface.tempo_fader";   to: "tempo_control.adjust" }
    }
}
