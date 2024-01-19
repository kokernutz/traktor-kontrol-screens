import CSI 1.0

Module {
  id: module

  property int deck: 1
  property bool enabled: true

  TransportSection { name: "transport"; channel: deck }

  WiresGroup {
      enabled: module.enabled
      Wire { from: "surface.slip"; to: "transport.flux" }
      Wire { from: "surface.slip_reverse"; to: "transport.flux_reverse" }
      Wire { from: "surface.reverse"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deck + ".reverse" } }
  }
}
