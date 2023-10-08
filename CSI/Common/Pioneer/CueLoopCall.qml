import CSI 1.0

import "../../../Defines"

Module {
    id: module

    property int deck: 1
    property bool enabled: true
    property bool loopControls: false

    AppProperty { id: isPlaying; path: "app.traktor.decks." + deck + ".play" }
    AppProperty { id: loopActive; path: "app.traktor.decks." + deck + ".loop.active"}
    AppProperty { id: isInActiveLoop; path: "app.traktor.decks." + deck + ".loop.is_in_active_loop" }

    WiresGroup {
        enabled: module.enabled

        // Cue controls
        Wire { from: "surface.cue_memory"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deck + ".track.cue.store" } }
        Wire { from: "surface.cue_delete"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deck + ".track.cue.delete" } }

        WiresGroup {
            enabled: !loopControls || !isInActiveLoop.value || !isPlaying.value

            Wire { from: "surface.call_prev"; to: SetPropertyAdapter { path: "app.traktor.decks." + deck + ".play"; value: false } }
            Wire { from: "surface.call_next"; to: SetPropertyAdapter { path: "app.traktor.decks." + deck + ".play"; value: false } }
            Wire { from: "surface.call_prev"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".track.cue.jump_to_next_prev"; value: -1 } }
            Wire { from: "surface.call_next"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".track.cue.jump_to_next_prev"; value: 1 } }
        }

        // Loop controls
        WiresGroup {
            enabled: loopControls && isInActiveLoop.value && isPlaying.value

            Wire { from: "surface.call_prev"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deck + ".loop.size"; mode: RelativeMode.Decrement } }
            Wire { from: "surface.call_next"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deck + ".loop.size"; mode: RelativeMode.Increment } }
        }
    }
}
