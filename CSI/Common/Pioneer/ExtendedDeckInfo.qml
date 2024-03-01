import CSI 1.0

Module
{
  id: module

  property int deck: 1
  property bool enabled: true
  property string deckProp: ""
  property bool jogTouch: false

  DeckAlbumArtProvider { name: "deck_album_art"; channel: module.deck }

  readonly property real timeTolerance: 0.001 // seconds
  AppProperty { id: isRunning; path: "app.traktor.decks." + deck + ".running" }
  AppProperty { id: activeCuePosition; path: "app.traktor.decks." + deck + ".track.cue.active.start_pos" }
  AppProperty { id: playheadPosition; path: "app.traktor.decks."  + deck + ".track.player.playhead_position" }
  AppProperty { id: keyLockEnabled; path: "app.traktor.decks." + deck + ".track.key.lock_enabled" }
  AppProperty { id: keyAdjust; path: "app.traktor.decks." + deck + ".track.key.adjust" }

  property bool activeCueWithPlayhead: Math.abs(activeCuePosition.value - playheadPosition.value) < timeTolerance

  WiresGroup
  {
      enabled: module.enabled

      Wire { from: "surface.display.pause_state_active"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: (!isRunning.value && !activeCueWithPlayhead) || jogTouch } }

      Wire { from: "surface.display.current_cue_enable"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deck + ".is_loaded" } }
      Wire { from: "surface.display.current_cue_time"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deck + ".track.cue.active.start_pos" } }
      Wire { from: "surface.display.jog_cue_point_time"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deck + ".track.cue.active.start_pos" } }

      Wire { from: "surface.display.slip_state_active"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deck + ".flux.enabled" } }
      Wire { from: "surface.display.slip_current_time"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deck + ".track.player.flux_position" } }

      Wire { from: "surface.track_info.album_art"; to: "deck_album_art.output" }

      Wire { from: "surface.display.original_key_index"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deck + ".content.key_index" } }
      Wire { from: "surface.display.current_key_index"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deck + ".track.key.final_id" } }
      Wire { from: "surface.display.key_shift_value"; to: ExpressionAdapter { type: ExpressionAdapter.Float; expression: keyLockEnabled.value ? keyAdjust.value : 0  } }
  }

}
