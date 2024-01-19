import CSI 1.0

Module {
    id: module

    property int deck: 1
    property bool shift: false
    property bool enabled: true

    Hotcues { name: "hotcues"; channel: deck }
    CuePointsProvider { name: "cuepoints_provider"; channel: deck }

    WiresGroup {
        enabled: module.enabled

        Wire { from: "surface.cue_points"; to: "cuepoints_provider.output" }

        WiresGroup {
            enabled: !shift
            Wire { from: "surface.hotcue_a"; to: "hotcues.1.trigger" }
            Wire { from: "surface.hotcue_b"; to: "hotcues.2.trigger" }
            Wire { from: "surface.hotcue_c"; to: "hotcues.3.trigger" }
            Wire { from: "surface.hotcue_d"; to: "hotcues.4.trigger" }
            Wire { from: "surface.hotcue_e"; to: "hotcues.5.trigger" }
            Wire { from: "surface.hotcue_f"; to: "hotcues.6.trigger" }
            Wire { from: "surface.hotcue_g"; to: "hotcues.7.trigger" }
            Wire { from: "surface.hotcue_h"; to: "hotcues.8.trigger" }
        }

        WiresGroup {
            enabled: shift
            Wire { from: "surface.hotcue_a"; to: "hotcues.1.delete" }
            Wire { from: "surface.hotcue_b"; to: "hotcues.2.delete" }
            Wire { from: "surface.hotcue_c"; to: "hotcues.3.delete" }
            Wire { from: "surface.hotcue_d"; to: "hotcues.4.delete" }
            Wire { from: "surface.hotcue_e"; to: "hotcues.5.delete" }
            Wire { from: "surface.hotcue_f"; to: "hotcues.6.delete" }
            Wire { from: "surface.hotcue_g"; to: "hotcues.7.delete" }
            Wire { from: "surface.hotcue_h"; to: "hotcues.8.delete" }
        }
    }
}
