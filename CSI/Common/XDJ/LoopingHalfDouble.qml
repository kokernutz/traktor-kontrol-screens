import CSI 1.0
import "../../../Defines"

Module
{
    id: module
    property int deck: 1
    property bool enabled: true

    readonly property string pathLoopSize: "app.traktor.decks." + deck + ".loop.size"
    AppProperty { id: loopActive; path: "app.traktor.decks." + deck + ".loop.active" }

    WiresGroup
    {
        enabled: module.enabled

        Wire { from: "surface.beat_loop_half"; to: RelativePropertyAdapter { path: module.pathLoopSize; mode: RelativeMode.Decrement } }
        Wire { from: "surface.beat_loop_double"; to: RelativePropertyAdapter { path: module.pathLoopSize; mode: RelativeMode.Increment } }
    }

    WiresGroup
    {
        enabled: module.enabled && loopActive.value

        Wire { from: "surface.call_prev"; to: RelativePropertyAdapter { path: module.pathLoopSize; mode: RelativeMode.Decrement } }
        Wire { from: "surface.call_next"; to: RelativePropertyAdapter { path: module.pathLoopSize; mode: RelativeMode.Increment } }
    }
}
