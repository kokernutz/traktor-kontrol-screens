import CSI 1.0
import "../../../Defines"

Module
{
    id: module
    property int deck: 1
    property bool enabled: true

    readonly property string pathAutoLoopWithSize: "app.traktor.decks." + deck + ".loop.set.auto_with_size"

    WiresGroup
    {
        enabled: module.enabled

        Wire { from: "surface.beat_loop_1_2";     to: SetPropertyAdapter { path: module.pathAutoLoopWithSize; value: LoopSize.loop_1_2 } }
        Wire { from: "surface.beat_loop_1";       to: SetPropertyAdapter { path: module.pathAutoLoopWithSize; value: LoopSize.loop_1 } }
        Wire { from: "surface.beat_loop_2";       to: SetPropertyAdapter { path: module.pathAutoLoopWithSize; value: LoopSize.loop_2 } }
        Wire { from: "surface.beat_loop_4";       to: SetPropertyAdapter { path: module.pathAutoLoopWithSize; value: LoopSize.loop_4 } }
        Wire { from: "surface.beat_loop_8";       to: SetPropertyAdapter { path: module.pathAutoLoopWithSize; value: LoopSize.loop_8 } }
        Wire { from: "surface.beat_loop_16";      to: SetPropertyAdapter { path: module.pathAutoLoopWithSize; value: LoopSize.loop_16 } }
    }
}
