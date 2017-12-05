import QtQuick 2.0
import './../Definitions/' as Definitions
import QtGraphicalEffects 1.0
import CSI 1.0


Item {
  id : phaseMeter

  property int              deckId:        0

  readonly property int     isMaster:      (propSyncMasterDeck.value == deckId) ? 1 : 0

  AppProperty { id: propSyncMasterDeck;    path: "app.traktor.masterclock.source_id" }
  AppProperty { id: propDeckAGridOffset;   path: "app.traktor.decks.1.content.grid_offset" }
  AppProperty { id: propDeckBGridOffset;   path: "app.traktor.decks.2.content.grid_offset" }
  AppProperty { id: propDeckCGridOffset;   path: "app.traktor.decks.3.content.grid_offset" }
  AppProperty { id: propDeckDGridOffset;   path: "app.traktor.decks.4.content.grid_offset" }
  AppProperty { id: propDeckAElapsedTime;  path: "app.traktor.decks.1.track.player.elapsed_time" }
  AppProperty { id: propDeckBElapsedTime;  path: "app.traktor.decks.2.track.player.elapsed_time" }
  AppProperty { id: propDeckCElapsedTime;  path: "app.traktor.decks.3.track.player.elapsed_time" }
  AppProperty { id: propDeckDElapsedTime;  path: "app.traktor.decks.4.track.player.elapsed_time" }
  AppProperty { id: propDeckANextCuePoint; path: "app.traktor.decks.1.track.player.next_cue_point" }
  AppProperty { id: propDeckBNextCuePoint; path: "app.traktor.decks.2.track.player.next_cue_point" }
  AppProperty { id: propDeckCNextCuePoint; path: "app.traktor.decks.3.track.player.next_cue_point" }
  AppProperty { id: propDeckDNextCuePoint; path: "app.traktor.decks.4.track.player.next_cue_point" }
  AppProperty { id: propDeckAMixerBpm;     path: "app.traktor.decks.1.tempo.base_bpm" }
  AppProperty { id: propDeckBMixerBpm;     path: "app.traktor.decks.2.tempo.base_bpm" }
  AppProperty { id: propDeckCMixerBpm;     path: "app.traktor.decks.3.tempo.base_bpm" }
  AppProperty { id: propDeckDMixerBpm;     path: "app.traktor.decks.4.tempo.base_bpm" }

  width:   148
  height:  20
  clip:    false

  Definitions.Colors { id: colors }
  Definitions.Font   { id: fonts  }


  // MASTER BEAT
  Repeater {
    id: master_beats
    model: 4

    Rectangle {
      width:  34
      height: 6
      y:      0
      x:      index * 38

      function getBeatColor(index) {
        if (propSyncMasterDeck.value == -1 || isMaster) return colors.colorGrey72;

        var beats = getBeats(propSyncMasterDeck.value);
        var beat  = parseInt(Math.abs(beats) % 4);
        if (beats < 0.0) beat = 3 - beat;

        if (beat != index) return colors.colorGrey72;

        return colors.colorGrey232;
      }
      color:  getBeatColor(index)
    }
  }

  // BEAT
  Repeater {
    id: beats
    model: 4

    Rectangle {
      width:  34
      height: 10
      y:      10
      x:      index * 38

      function getBeatColor(index) {
        var beats = getBeats(deckId);
        var beat  = parseInt(Math.abs(beats) % 4);
        if (beats < 0.0) beat = 3 - beat;

        if (beat != index) return colors.colorGreenInactive;

        return colors.colorGreenActive;
      }
      color:  getBeatColor(index)
    }
  }

  // MASTER BARS
  Text {
    width: 58
    y: -3
    x: 152
    font.pixelSize: fonts.smallFontSize
    font.family: "Pragmatica"
    horizontalAlignment: Text.AlignRight
    color: colors.colorGrey72
    visible: (propSyncMasterDeck.value > -1 && !isMaster)

    function getMasterBeatsString() {
      var beats = getBeats(propSyncMasterDeck.value);
      var bars  = parseInt(Math.abs(beats) / 4) + 1;

      return ((beats < 0.0) ? "-" : "") + bars.toString() + " BARS";
    }
    text: getMasterBeatsString()
  }

  // BARS
  Text {
    width: 58
    y: 10
    x: 152
    font.pixelSize: fonts.smallFontSize
    font.family: "Pragmatica"
    horizontalAlignment: Text.AlignRight
    color: colors.colorGreenActive

    function getBeatsString() {
      var beats = getBeats(deckId);
      var bars  = parseInt(Math.abs(beats) / 4) + 1;

      return ((beats < 0.0) ? "-" : "") + bars.toString() + " BARS";
    }
    text: getBeatsString()
  }


  //--------------------------------------------------------------------------------------------------------------------
  //  FUNCTIONS
  //--------------------------------------------------------------------------------------------------------------------

  function getBeats(deck) {
    switch (deck) {
      case 0: return ((propDeckAElapsedTime.value * 1000 - propDeckAGridOffset.value) * propDeckAMixerBpm.value) / 60000.0;
      case 1: return ((propDeckBElapsedTime.value * 1000 - propDeckBGridOffset.value) * propDeckBMixerBpm.value) / 60000.0;
      case 2: return ((propDeckCElapsedTime.value * 1000 - propDeckCGridOffset.value) * propDeckCMixerBpm.value) / 60000.0;
      case 3: return ((propDeckDElapsedTime.value * 1000 - propDeckDGridOffset.value) * propDeckDMixerBpm.value) / 60000.0;
    }
  }

  function getBeatsToCue(deck) {
    switch (deck) {
      case 0: return ((propDeckANextCuePoint.value - propDeckAElapsedTime.value * 1000) * propDeckAMixerBpm.value) / 60000.0;
      case 1: return ((propDeckBNextCuePoint.value - propDeckBElapsedTime.value * 1000) * propDeckBMixerBpm.value) / 60000.0;
      case 2: return ((propDeckCNextCuePoint.value - propDeckCElapsedTime.value * 1000) * propDeckCMixerBpm.value) / 60000.0;
      case 3: return ((propDeckDNextCuePoint.value - propDeckDElapsedTime.value * 1000) * propDeckDMixerBpm.value) / 60000.0;
    }
  }

}
