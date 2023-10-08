import CSI 1.0

Module {
  id: module

  property int deck: 1
  property bool enabled: true

  WiresGroup {
      enabled: module.enabled
      Wire { from: "surface.slip"; to: TogglePropertyAdapter { path: "app.traktor.decks." + module.deck + ".flux.enabled" } }
      Wire { from: "surface.reverse"; to: HoldPropertyAdapter { path: "app.traktor.decks." + module.deck + ".reverse" } }
  }
}
