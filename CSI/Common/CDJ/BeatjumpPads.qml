import CSI 1.0

import "../../../Defines"

Module {
    id: module

    property int deck: 1
    property bool enabled: true

    WiresGroup {
        enabled: module.enabled

        Wire { from: "surface.beatjump_rev1_2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.bwd_1_2 } }
        Wire { from: "surface.beatjump_rev1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.bwd_1 } }
        Wire { from: "surface.beatjump_rev2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.bwd_2 } }
        Wire { from: "surface.beatjump_rev4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.bwd_4 } }
        Wire { from: "surface.beatjump_rev8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.bwd_8 } }
        Wire { from: "surface.beatjump_rev16"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.bwd_16 } }
        Wire { from: "surface.beatjump_rev32"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.bwd_32 } }

        Wire { from: "surface.beatjump_fwd1_2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.fwd_1_2 } }
        Wire { from: "surface.beatjump_fwd1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.fwd_1 } }
        Wire { from: "surface.beatjump_fwd2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.fwd_2 } }
        Wire { from: "surface.beatjump_fwd4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.fwd_4 } }
        Wire { from: "surface.beatjump_fwd8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.fwd_8 } }
        Wire { from: "surface.beatjump_fwd16"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.fwd_16 } }
        Wire { from: "surface.beatjump_fwd32"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".beatjump"; value: JumpSize.fwd_32 } }
    }
}
