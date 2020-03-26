import CSI 1.0

Module
{
  id: module

  property bool enabled: true
  property alias selectedDeck: selectedDeckProp.value

  XDJDeckSelection { name: "deck_selection" }

  MappingPropertyDescriptor {
    id: selectedDeckProp
    path: "mapping.state.assigned_deck"
    type: MappingPropertyDescriptor.Integer;
    value: 0 // 0 means no deck selected
    min: 0
    max: 4
  }

  MappingPropertyDescriptor {
    id: browseEnabled
    path: "mapping.state.browse_enabled"
    type: MappingPropertyDescriptor.Boolean
  }
  Wire { from: "surface.info_enable"; to:  DirectPropertyAdapter{ path: browseEnabled.path } }

  WiresGroup
  {
      enabled: selectedDeck === 0 && module.enabled;
      Wire { from: "surface.browsing_info"; to: "deck_selection.info" }
      Wire { from: "surface.album_art"; to: "deck_selection.album_art" }
  }

  Wire { from: "surface.browse"; to: "deck_selection.select"; enabled: browseEnabled.value}
  Wire { enabled: module.enabled; from: "deck_selection.selected_deck"; to: ValuePropertyAdapter { path: selectedDeckProp.path } }

}
