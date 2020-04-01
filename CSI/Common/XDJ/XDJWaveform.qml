import CSI 1.0

Module
{
    id: module

    property int deck: 1
    property bool enabled: true
    property string deckProp: ""

    // Waveform Data

    WaveformProvider { name: "waveform_provider"; channel: module.deck }
    WiresGroup
    {
        enabled: module.enabled
        Wire { from: "surface.grid_info"; to: "waveform_provider.grid" }
        Wire { from: "surface.waveform_info"; to: "waveform_provider.waveform" }
        Wire { from: "waveform_provider.color"; to: ValuePropertyAdapter { path: "app.traktor.settings.waveform.color"; input: false } }
    }

    // Loop Information

    AppProperty { id: loopActive;     path: "app.traktor.decks." + deck + ".loop.active"        }
    AppProperty { id: activeCueType;   path: "app.traktor.decks." + deck + ".track.cue.active.type"      }
    AppProperty { id: activeCueStart;  path: "app.traktor.decks." + deck + ".track.cue.active.start_pos" }
    AppProperty { id: activeCueLength; path: "app.traktor.decks." + deck + ".track.cue.active.length"    }

    readonly property bool loopInfoAvailable: activeCueType.value === CueType.Loop
    readonly property real activeCueEnd: activeCueStart.value + activeCueLength.value

    WiresGroup
    {
        enabled: module.enabled
        Wire { from: "surface.display.waveform_draw_loop"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: loopInfoAvailable } }

        WiresGroup
        {
            enabled: loopInfoAvailable;
            Wire { from: "surface.display.waveform_loop_start";  to: ValuePropertyAdapter { path: activeCueStart.path } }
            Wire { from: "surface.display.waveform_loop_end"; to: ExpressionAdapter { type: ExpressionAdapter.Float; expression: activeCueEnd } }
            Wire { from: "surface.display.waveform_loop_active"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: !loopActive.value } }
        }
    }

}
