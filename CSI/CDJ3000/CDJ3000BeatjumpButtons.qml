import CSI 1.0

import "../../Defines"

Module {
    id: module

    property int deck: 1
    property bool shift: false
    property bool enabled: true

    WiresGroup {
        enabled: module.enabled

        Wire { from: "surface.display.beat_jump_setting"; to: ValuePropertyAdapter { path: "app.traktor.decks." + deck + ".move.size" } }

        WiresGroup {
            enabled: !shift

            Wire { from: "surface.beatjump_rev"; to: SetPropertyAdapter { path: "app.traktor.decks." + deck + ".move.mode"; value: 0; output: false } }
            Wire { from: "surface.beatjump_fwd"; to: SetPropertyAdapter { path: "app.traktor.decks." + deck + ".move.mode"; value: 0; output: false } }
            Wire { from: "surface.beatjump_rev"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".move"; value: -1 } }
            Wire { from: "surface.beatjump_fwd"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".move"; value: 1 } }
        }

        WiresGroup {
            enabled: shift

            Wire { from: "surface.beatjump_rev"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deck + ".move.size"; mode: RelativeMode.Decrement } }
            Wire { from: "surface.beatjump_fwd"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deck + ".move.size"; mode: RelativeMode.Increment } }
        }
    }
}
