import CSI 1.0
import "../../../Defines"

Module
{
    id: module
    property string deckProp: ""
    property int deck: 1
    property int lines: 0
    property bool useHeader: false
    property bool enabled: true

    MappingPropertyDescriptor {
      id: browseEnabled
      path: deckProp + ".browse_enabled"
      type: MappingPropertyDescriptor.Boolean
    }
    Wire { from: "surface.info_enable"; to:  DirectPropertyAdapter{ path: deckProp + ".browse_enabled" } }

    PioneerBrowser { name: "browser"; channel: module.deck; lines: module.lines; useHeader: module.useHeader }

    WiresGroup {
        enabled: browseEnabled.value && module.enabled
        Wire { from: "surface.browse"; to: "browser.navigation" }
        Wire { from: "surface.tag_track"; to: "browser.tag_track" }
        Wire { from: "surface.back"; to: "browser.back" }
        Wire { from: "surface.browsing_info"; to: "browser.info" }
        Wire { from: "surface.album_art"; to: "browser.album_art" }
    }
}
