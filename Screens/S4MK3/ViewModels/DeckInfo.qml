import QtQuick 2.5
import CSI 1.0

//----------------------------------------------------------------------------------------------------------------------
//  Track Deck Model - provide data for the track deck view
//----------------------------------------------------------------------------------------------------------------------

Item
{
  id: viewModel

  function isLeftScreen(deckId)
  {
    return deckId == 1 || deckId == 3;
  }

  ////////////////////////////////////
  /////// Track info properties //////
  ////////////////////////////////////

  property int deckId: 1
  readonly property bool    trackEndWarning:      propTrackEndWarning.value
  readonly property bool    shift:                propShift.value
  readonly property string  artistString:         propArtist.value
  readonly property string  bpmString:            isLoaded ? propBPM.value.toFixed(2).toString() : "0.00"
  readonly property real    elapsedTime:          propElapsedTime.value 
  readonly property bool    hightlightLoop:       !shift
  readonly property bool    hightlightKey:        shift
  readonly property int     isLoaded:             (propTrackLength.value > 0) || (deckType === DeckType.Remix)
  readonly property string  resultingKeyStr:      prefs.camelotKey ? utils.convertToCamelot(propKeyForDisplay.value) : propKeyForDisplay.value // propKeyForDisplay.value
  readonly property int     resultingKeyIdx:      propFinalKeyId.value
  readonly property bool    hasKey:               isLoaded && resultingKeyIdx >= 0
  readonly property bool    isKeyLockOn:          propKeyLockOn.value
  readonly property bool    loopActive:           propLoopActive.value
  readonly property string  loopSizeString:       loopSizeText[propLoopSizeIdx.value]
  readonly property string  primaryKey:           propPrimaryKey.value
  readonly property string  remainingTimeString:  (!isLoaded) ? "00:00" : utils.computeRemainingTimeString(propTrackLength.value, propElapsedTime.value)
  readonly property string  titleString:          isLoaded ? propTitle.value : "No Track Loaded"
  readonly property int     trackLength:          propTrackLength.value
  readonly property real    phase:                propPhase.value
  readonly property bool    touchKey:             false // TODO map shift encoder touch event
  readonly property bool    touchTime:            false // TODO map shift encoder touch event
  readonly property bool    touchLoop:            false // TODO map shift encoder touch event

  readonly property int     deckType:             propDeckType.value
  readonly property string  keyAdjustFloatText:   (keyAdjustVal < 0 ? "" : "+") + keyAdjustVal.toFixed(2).toString()
  readonly property string  keyAdjustIntText:     (keyAdjustVal < 0 ? "" : "+") + keyAdjustVal.toFixed(0).toString()
  readonly property real    keyAdjustVal:         propKeyAdjust.value*12
  readonly property variant loopSizeText:         ["1/32", "1/16", "1/8", "1/4", "1/2", "1", "2", "4", "8", "16", "32"]

  AppProperty { id: propDeckType;               path: "app.traktor.decks." + deckId + ".type" }
  AppProperty { id: propTitle;                  path: "app.traktor.decks." + deckId + ".content.title" }
  AppProperty { id: propArtist;                 path: "app.traktor.decks." + deckId + ".content.artist" }
  AppProperty { id: propKeyForDisplay;          path: "app.traktor.decks." + deckId + ".track.key.resulting.quantized" }
  AppProperty { id: propFinalKeyId;             path: "app.traktor.decks." + deckId + ".track.key.final_id" }
  AppProperty { id: propKeyAdjust;              path: "app.traktor.decks." + deckId + ".track.key.adjust" }
  AppProperty { id: propKeyLockOn;              path: "app.traktor.decks." + deckId + ".track.key.lock_enabled" }
  AppProperty { id: propBPM;                    path: "app.traktor.decks." + deckId + ".tempo.true_bpm" }
  AppProperty { id: propPhase;                  path: "app.traktor.decks." + deckId + ".tempo.phase"; }
  AppProperty { id: propLoopSizeIdx;            path: "app.traktor.decks." + deckId + ".loop.size" }
  AppProperty { id: propLoopActive;             path: "app.traktor.decks." + deckId + ".loop.active"; }
  AppProperty { id: propTrackLength;            path: "app.traktor.decks." + deckId + ".track.content.track_length"; }
  AppProperty { id: propElapsedTime;            path: "app.traktor.decks." + deckId + ".track.player.elapsed_time"; }
  AppProperty { id: propertyCover;              path: "app.traktor.decks." + deckId + ".content.cover_md5" }
  AppProperty { id: propPrimaryKey;             path: "app.traktor.decks." + deckId + ".track.content.entry_key"; }
  AppProperty { id: propTrackEndWarning;        path: "app.traktor.decks." + deckId + ".track.track_end_warning" }

  MappingProperty { id: propShift;     path: "mapping.state." + (isLeftScreen(deckId) ? "left" : "right") + ".shift" }

  ///////////////////////////////////////////////////
  /////// Remix Deck properties /////////////////////
  ///////////////////////////////////////////////////

  readonly property string  beatPositionString:   propBeatPosition.description
  readonly property bool    rmxQuantizeOn:        propRemixQuantOn.value
  readonly property string  rmxQuantizeIndex:     propRemixQuantIndex.description
  readonly property bool    isSequencerRecOn:     propSequencerRecOn.value
  readonly property int     remixActiveSlot:      propRemixActiveSlot.value
  readonly property bool    remixSampleBrowsing:  propRemixSampleBrowsing.value
  
  AppProperty { id: propBeatPosition;                path: "app.traktor.decks." + deckId + ".remix.current_beat_pos"}
  AppProperty { id: propRemixQuantOn;                path: "app.traktor.decks." + deckId + ".remix.quant"}
  AppProperty { id: propRemixQuantIndex;             path: "app.traktor.decks." + deckId + ".remix.quant_index"}
  AppProperty { id: propSequencerRecOn;              path: "app.traktor.decks." + deckId + ".remix.sequencer.rec.on"}

  MappingProperty { id: propRemixActiveSlot; path: "mapping.state." + (isLeftScreen(deckId) ? "left." : "right.") + deckId + ".active_slot";  }
  MappingProperty { id: propRemixSampleBrowsing; path: "mapping.state." + (isLeftScreen(deckId) ? "left." : "right.") + deckId + ".sample_browsing";  }

  property var slot1 : Slot { slotId: 1; deckId: viewModel.deckId }
  property var slot2 : Slot { slotId: 2; deckId: viewModel.deckId }
  property var slot3 : Slot { slotId: 3; deckId: viewModel.deckId }
  property var slot4 : Slot { slotId: 4; deckId: viewModel.deckId }

  property var slots : [slot1, slot2, slot3, slot4]

  function getSlot( slotId ) { return slots[ slotId-1 ]; }

  ///////////////////////////////////////////////////
  /////// Stem Deck properties //////////////////////
  ///////////////////////////////////////////////////

  MappingProperty { id: propStemActive; path: "mapping.state." + (isLeftScreen(deckId) ? "left." : "right.") + deckId + ".stems.active_stem";  }

  readonly property bool isStemsActive: propStemActive.value != 0
  readonly property int stemSelected:   isStemsActive ? propStemActive.value : 1 // default value is 1

  readonly property string  stemSelectedName:         isStemsActive ? propStemSelectedName.value      : ""
  readonly property real    stemSelectedVolume:       isStemsActive ? propStemSelectedVolume.value    : 0.0
  readonly property bool    stemSelectedMuted:        isStemsActive ? propStemSelectedMuted.value     : false
  readonly property real    stemSelectedFilterValue:  isStemsActive ? propStemSelectedFilter.value    : 0.5
  readonly property bool    stemSelectedFilterOn:     isStemsActive ? propStemSelectedFilterOn.value  : false
  readonly property color   stemSelectedBrightColor:  isStemsActive ? colors.palette(1., propStemSelectedColorId.value) : "grey"
  readonly property color   stemSelectedMidColor:     isStemsActive ? colors.palette(0.5, propStemSelectedColorId.value) : "black"

  function selectedStemPath() { return "app.traktor.decks." + deckId + ".stems." + stemSelected;}

  AppProperty { id: propStemSelectedName;     path: selectedStemPath() + ".name" }
  AppProperty { id: propStemSelectedVolume;   path: selectedStemPath() + ".volume" }
  AppProperty { id: propStemSelectedMuted;    path: selectedStemPath() + ".muted" }
  AppProperty { id: propStemSelectedFilter;   path: selectedStemPath() + ".filter_value" }
  AppProperty { id: propStemSelectedFilterOn; path: selectedStemPath() + ".filter_on" }
  AppProperty { id: propStemSelectedColorId;  path: selectedStemPath() + ".color_id" }

  ///////////////////////////////////////////////////
  /////// Stripe properties /////////////////////////
  ///////////////////////////////////////////////////
 
  readonly property alias hotcues: hotcuesModel

  HotCues { id: hotcuesModel; deckId: viewModel.deckId }
}
