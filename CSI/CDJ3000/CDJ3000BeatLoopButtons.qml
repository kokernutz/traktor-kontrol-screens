import CSI 1.0

import "../../Defines"

Module {
    id: module

    property int deck: 1
    property bool enabled: true

    AppProperty { id: isInActiveLoop; path: "app.traktor.decks." + deck + ".loop.is_in_active_loop" }

    WiresGroup {
        enabled: module.enabled

        WiresGroup {
            enabled: !isInActiveLoop.value

            Wire { from: "surface.4_beat_loop"; to: SetPropertyAdapter { path: "app.traktor.decks." + deck + ".loop.set.auto_with_size"; value: LoopSize.loop_4 } }
            Wire { from: "surface.8_beat_loop"; to: SetPropertyAdapter { path: "app.traktor.decks." + deck + ".loop.set.auto_with_size"; value: LoopSize.loop_8 } }
        }

        WiresGroup {
            enabled: isInActiveLoop.value

            Wire { from: "surface.4_beat_loop"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deck + ".loop.size"; mode: RelativeMode.Decrement } }
            Wire { from: "surface.8_beat_loop"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deck + ".loop.size"; mode: RelativeMode.Increment } }
        }
    }
}
