import CSI 1.0
import "../../../Defines"

Module
{
    id: module
    property int deck: 1
    property bool enabled: true

    XDJLoop { name: "loop"; channel: deck; }

    WiresGroup
    {
        enabled: module.enabled
        Wire { from: "surface.loop_in"; to: "loop.loop_in" }
        Wire { from: "surface.loop_out"; to: "loop.loop_out" }
        Wire { from: "surface.reloop"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deck + ".loop.active" } }

        Wire { from: "surface.loop_info"; to: "loop.loop_info" }
    }
}
