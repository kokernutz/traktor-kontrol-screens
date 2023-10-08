import CSI 1.0

Module {
    id: module

    property int deck: 1
    property bool enabled: true

    AppProperty { id: keyLockEnabled; path: "app.traktor.decks." + deck + ".track.key.lock_enabled" }

    WiresGroup {
        enabled: module.enabled

        Wire { from: "surface.key_shift_up"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deck + ".track.key.transpose"; step: 1; mode: RelativeMode.Increment } }
        Wire { from: "surface.key_shift_down"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deck + ".track.key.transpose"; step: 1; mode: RelativeMode.Decrement } }
        Wire { from: "surface.key_reset"; to: SetPropertyAdapter { path: "app.traktor.decks." + deck + ".track.key.adjust"; value: 0 } enabled: keyLockEnabled.value; }

        // When keylock is disabled pushing an up/down button will automatically enable it
        WiresGroup {
            enabled: !keyLockEnabled.value
            Wire { from: "surface.key_shift_up"; to: SetPropertyAdapter { path: "app.traktor.decks." + deck + ".track.key.lock_enabled"; value: true } }
            Wire { from: "surface.key_shift_down"; to: SetPropertyAdapter { path: "app.traktor.decks." + deck + ".track.key.lock_enabled"; value: true } }
        }
    }
}
