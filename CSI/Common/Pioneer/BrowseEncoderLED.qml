import CSI 1.0
import QtQuick 2.5

Module {
    id: module

    property int deck: 1
    property bool enabled: true

    // LEDs brightness constants
    readonly property real bright: 1.0
    readonly property real dimmed: 0.0

    Blinker { name: "BrowseBlinker"; cycle: 250; repetitions: 4; defaultBrightness: bright; blinkBrightness: dimmed }
    Wire { from: "surface.browse.LED"; to: "BrowseBlinker"; enabled: module.enabled }

    Timer { id: deckLoaded_countdown; interval: 1000 }
    AppProperty { path: "app.traktor.decks." + deck + ".is_loaded_signal"; onValueChanged: { deckLoaded_countdown.restart() } }
    Wire { from: "BrowseBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: deckLoaded_countdown.running } enabled: module.enabled }
}
