import CSI 1.0

Module
{
  id: module

  property int deck: 1
  property bool enabled: true
  property string deckProp: ""

  MappingPropertyDescriptor {
    id: remain
    path: deckProp + ".time_remain"
    type: MappingPropertyDescriptor.Boolean;
    value: true;
  }

  WiresGroup
  {
      enabled: module.enabled

      Wire { from: "surface.display.time_enable"; to: ValuePropertyAdapter { path: "app.traktor.decks." + module.deck + ".is_loaded" } }
      Wire { from: "surface.display.current_time"; to: DirectPropertyAdapter { path: "app.traktor.decks." + module.deck + ".track.player.elapsed_time" } }
      Wire { from: "surface.display.total_time"; to: DirectPropertyAdapter { path: "app.traktor.decks." + module.deck + ".track.content.track_length" } }
      Wire { from: "surface.display.bpm"; to: DirectPropertyAdapter { path: "app.traktor.decks." + module.deck + ".tempo.true_bpm" } }
      Wire { from: "surface.display.tempo"; to: DirectPropertyAdapter { path: "app.traktor.decks." + module.deck + ".track.player.sync_factor" } }
      Wire { from: "surface.display.tempo_range"; to: DirectPropertyAdapter { path: "app.traktor.decks." + module.deck + ".tempo.range_select" } }

      Wire { from: "surface.track_info.title";  to: ValuePropertyAdapter { path: "app.traktor.decks." + module.deck + ".content.title"  } }
      Wire { from: "surface.track_info.album";  to: ValuePropertyAdapter { path: "app.traktor.decks." + module.deck + ".content.album"  } }
      Wire { from: "surface.track_info.artist"; to: ValuePropertyAdapter { path: "app.traktor.decks." + module.deck + ".content.artist" } }
      Wire { from: "surface.track_info.bpm"; to: ValuePropertyAdapter { path: "app.traktor.decks." + module.deck + ".content.display_bpm" } }

      Wire { from: "surface.time_acue"; to: TogglePropertyAdapter { path: remain.path; defaultValue: false } }
  }

}
