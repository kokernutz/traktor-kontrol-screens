import CSI 1.0

import "../../../Defines"

Module {
    id: module

    property int deck: 1
    property bool enabled: true

    Loop { name: "loop";  channel: deck }
    ButtonSection { name: "loop_roll_pads"; buttons: 11; stateHandling: ButtonSection.External }

    MappingPropertyDescriptor { path: "mapping.settings.loop_roll_1_32"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_32 }
    MappingPropertyDescriptor { path: "mapping.settings.loop_roll_1_16"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_16 }
    MappingPropertyDescriptor { path: "mapping.settings.loop_roll_1_8"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_8 }
    MappingPropertyDescriptor { path: "mapping.settings.loop_roll_1_4"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_4 }
    MappingPropertyDescriptor { path: "mapping.settings.loop_roll_1_2"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_2 }
    MappingPropertyDescriptor { path: "mapping.settings.loop_roll_1"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1 }
    MappingPropertyDescriptor { path: "mapping.settings.loop_roll_2"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_2 }
    MappingPropertyDescriptor { path: "mapping.settings.loop_roll_4"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_4 }
    MappingPropertyDescriptor { path: "mapping.settings.loop_roll_8"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_8 }
    MappingPropertyDescriptor { path: "mapping.settings.loop_roll_16"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_16 }
    MappingPropertyDescriptor { path: "mapping.settings.loop_roll_32"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_32 }


    WiresGroup {
        enabled: module.enabled

        Wire { from: DirectPropertyAdapter { path: "mapping.settings.loop_roll_1_32"; input: false } to: "loop_roll_pads.button1.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.loop_roll_1_16"; input: false } to: "loop_roll_pads.button2.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.loop_roll_1_8"; input: false } to: "loop_roll_pads.button3.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.loop_roll_1_4"; input: false } to: "loop_roll_pads.button4.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.loop_roll_1_2"; input: false } to: "loop_roll_pads.button5.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.loop_roll_1"; input: false } to: "loop_roll_pads.button6.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.loop_roll_2"; input: false } to: "loop_roll_pads.button7.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.loop_roll_4"; input: false } to: "loop_roll_pads.button8.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.loop_roll_8"; input: false } to: "loop_roll_pads.button9.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.loop_roll_16"; input: false } to: "loop_roll_pads.button10.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.loop_roll_32"; input: false } to: "loop_roll_pads.button11.value" }

        Wire { from: "surface.beat_loop_1_32"; to: "loop_roll_pads.button1" }
        Wire { from: "surface.beat_loop_1_16"; to: "loop_roll_pads.button2" }
        Wire { from: "surface.beat_loop_1_8"; to: "loop_roll_pads.button3" }
        Wire { from: "surface.beat_loop_1_4"; to: "loop_roll_pads.button4" }
        Wire { from: "surface.beat_loop_1_2"; to: "loop_roll_pads.button5" }
        Wire { from: "surface.beat_loop_1"; to: "loop_roll_pads.button6" }
        Wire { from: "surface.beat_loop_2"; to: "loop_roll_pads.button7" }
        Wire { from: "surface.beat_loop_4"; to: "loop_roll_pads.button8" }
        Wire { from: "surface.beat_loop_8"; to: "loop_roll_pads.button9" }
        Wire { from: "surface.beat_loop_16"; to: "loop_roll_pads.button10" }
        Wire { from: "surface.beat_loop_32"; to: "loop_roll_pads.button11" }

        Wire { from: "loop_roll_pads.value"; to: "loop.autoloop_size" }
        Wire { from: "loop_roll_pads.active"; to: "loop.autoloop_active" }
    }
}
