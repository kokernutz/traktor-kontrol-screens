pragma Singleton

import QtQuick 2.0

// Constants for Hotcues Button actions
QtObject {
    // Browse encoder actions
    readonly property int browse_tree:      0
    readonly property int browse_favorites: 1

    // Browse shift + push
    readonly property int browse_expand_tree:        0
    readonly property int browse_toggle_full_screen: 1
}
