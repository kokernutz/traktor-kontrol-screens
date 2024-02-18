import CSI 1.0

Module {
  id: module

  property int deck: 1
  property bool enabled: true

  readonly property int trackSearchRepeatMs: 300
  readonly property real timeTolerance: 0.001 // seconds

  TransportSection { name: "transport"; channel: deck }

  WiresGroup {
      enabled: module.enabled

      Wire { from: "surface.play_pause"; to: "transport.play" }
      Wire { from: "surface.cue"; to: "transport.cue" }
      Wire { from: "surface.master"; to: "transport.master" }
      Wire { from: "surface.sync"; to: "transport.sync" }

      Wire { from: "surface.quantize"; to: TogglePropertyAdapter { path: "app.traktor.snap" } }
  }

  TrackSeek { name: "track_seek"; channel: deck }

  AppProperty { id: elapsedTime;     path: "app.traktor.decks." + deck + ".track.player.elapsed_time" }
  readonly property bool isAtBeginning: elapsedTime.value < timeTolerance

  WiresGroup {
      enabled: module.enabled
      Wire { from: "surface.jogwheel"; to: "track_seek.fast_seek" }
      Wire { from: "surface.search_fwd"; to: "track_seek.seek_forward" }
      Wire { from: "surface.search_rev"; to: "track_seek.seek_reverse" }
      Wire { from: "surface.needle_search"; to: "track_seek.needle_search" }

      Wire { from: "surface.track_next"; to: TriggerPeriodicPropertyAdapter { path: "app.traktor.decks." + deck + ".load.next"; intervalMs: trackSearchRepeatMs } }
      Wire { enabled:  isAtBeginning; from: "surface.track_prev"; to: TriggerPeriodicPropertyAdapter { path: "app.traktor.decks." + deck + ".load.previous"; intervalMs: trackSearchRepeatMs } }
      Wire { enabled: !isAtBeginning; from: "surface.track_prev"; to: SetPropertyAdapter { path: "app.traktor.decks." + deck + ".seek"; value: 0 } }
  }

}
