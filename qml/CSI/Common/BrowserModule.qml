import CSI 1.0

Module
{
  id: module
  property string surface: ""
  property int deckIdx: 0
  property bool shift: false
  property bool navigateFavoritesOnShift: true

  Browser { name: "browser" }

  WiresGroup
  {
    enabled: !shift

    Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckIdx + ".load.selected" } }
    Wire { from: "%surface%.browse.encoder"; to: "browser.list_navigation" }
    Wire { from: "%surface%.browse.back"; to: "browser.add_remove_from_prep_list" }
  }

  WiresGroup
  {
    enabled: shift

    Wire { from: "%surface%.browse.encoder"; to: "browser.favorites_navigation"; enabled:  navigateFavoritesOnShift }
    Wire { from: "%surface%.browse.encoder"; to: "browser.tree_navigation";      enabled: !navigateFavoritesOnShift }

    Wire { from: "%surface%.browse.back"; to: "browser.jump_to_prep_list" }
  }

  Wire { from: "%surface%.browse.mode";    to: "browser.full_screen" }
}
