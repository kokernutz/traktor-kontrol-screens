import CSI 1.0
import QtQuick

//--------------------------------------------------------------------------------------------------------------------
//  DECK HEADER TEXT
//--------------------------------------------------------------------------------------------------------------------

Text {
  id: header_text

  property int              maxTextWidth : 200
  property int              textState: 0       // this property sets the state of this label (artist, album, bpm, ...)
  property int              deckId: 0
  property double           syncLabelOpacity: 0.6

  // by setting this string, we can suppres the properties below and expicit define a name
  property string           explicitName: " "  
  
  readonly property int     deckType:  propDeckType.value
  readonly property int     isLoaded:  (primaryKey.value > 0) || (deckType == DeckType.Remix)
  readonly property double  cuePos:    (propNextCuePoint.value >= 0) ? propNextCuePoint.value : propTrackLength.value*1000
  readonly property int     isInSync:  propIsInSync.value
  readonly property int     isMaster:  (propSyncMasterDeck.value == deckId) ? 1 : 0

  readonly property string  fontForNumber: "Pragmatica"
  readonly property string  fontForString: "Pragmatica MediumTT"
  readonly property variant keyIndex:      {"1d": 0, "8d": 1, "3d": 2, "10d": 3, "5d": 4, "12d": 5,
                                            "7d": 6, "2d": 7, "9d": 8, "4d": 9, "11d": 10, "6d": 11,
                                            "10m": 12, "5m": 13, "12m": 14, "7m": 15, "2m": 16, "9m": 17,
                                            "4m": 18, "11m": 19, "6m": 20, "1m": 21, "8m": 22, "3m": 23}
  readonly property variant keyText:       {"1d": "8B", "8d": "3B", "3d": "10B", "10d": "5B", "5d": "12B", "12d": "7B",
                                            "7d": "2B", "2d": "9B", "9d": "4B", "4d": "11B", "11d": "6B", "6d": "1B",
                                            "10m": "5A", "5m": "12A", "12m": "7A", "7m": "2A", "2m": "9A", "9m": "4A",
                                            "4m": "11A", "11m": "6A", "6m": "1A", "1m": "8A", "8m": "3A", "3m": "10A"}


  // Properties of the TextItem itself. Anchors are set from outside
  x:        0
  y:        0
  width:       (maxTextWidth == 0 || text.paintedWidth > maxTextWidth) ? text.paintedWidth : maxTextWidth
  text:        "" 
  font.family: fontForString


  //--------------------------------------------------------------------------------------------------------------------
  //  DECK PROPERTIES
  //--------------------------------------------------------------------------------------------------------------------
  AppProperty { id: propDeckType;       path: "app.traktor.decks." + (deckId+1) + ".type" }
  AppProperty { id: primaryKey;         path: "app.traktor.decks." + (deckId+1) + ".track.content.entry_key" }
  AppProperty { id: keyDisplay;         path: "app.traktor.decks." + (deckId+1) + ".track.key.resulting.precise" }
  
  AppProperty { id: propTitle;          path: "app.traktor.decks." + (deckId+1) + ".content.title" }
  AppProperty { id: propArtist;         path: "app.traktor.decks." + (deckId+1) + ".content.artist" }
  AppProperty { id: propAlbum;          path: "app.traktor.decks." + (deckId+1) + ".content.album" }
  AppProperty { id: propGenre;          path: "app.traktor.decks." + (deckId+1) + ".content.genre" }
  AppProperty { id: propComment;        path: "app.traktor.decks." + (deckId+1) + ".content.comment" }
  AppProperty { id: propComment2;       path: "app.traktor.decks." + (deckId+1) + ".content.comment2" }
  AppProperty { id: propLabel;          path: "app.traktor.decks." + (deckId+1) + ".content.label" }
  AppProperty { id: propMix;            path: "app.traktor.decks." + (deckId+1) + ".content.mix" }
  AppProperty { id: propRemixer;        path: "app.traktor.decks." + (deckId+1) + ".content.remixer" }
  AppProperty { id: propCatNo;          path: "app.traktor.decks." + (deckId+1) + ".content.catalog_number" }
  AppProperty { id: propGridOffset;     path: "app.traktor.decks." + (deckId+1) + ".content.grid_offset" }
  AppProperty { id: propBitrate;        path: "app.traktor.decks." + (deckId+1) + ".content.bitrate"; } 

  AppProperty { id: propTrackLength;    path: "app.traktor.decks." + (deckId+1) + ".track.content.track_length"; }
  AppProperty { id: propElapsedTime;    path: "app.traktor.decks." + (deckId+1) + ".track.player.elapsed_time"; } 
  AppProperty { id: propNextCuePoint;   path: "app.traktor.decks." + (deckId+1) + ".track.player.next_cue_point"; }

  AppProperty { id: propMusicalKey;       path: "app.traktor.decks." + (deckId+1) + ".content.musical_key" }
  AppProperty { id: propLegacyKey;        path: "app.traktor.decks." + (deckId+1) + ".content.legacy_key" }
  AppProperty { id: propPitchRange;       path: "app.traktor.decks." + (deckId+1) + ".tempo.range_value" }
  AppProperty { id: propTempoAbsolute;    path: "app.traktor.decks." + (deckId+1) + ".tempo.absolute" }  
  AppProperty { id: propMixerBpm;         path: "app.traktor.decks." + (deckId+1) + ".tempo.base_bpm" }
  AppProperty { id: propMixerStableBpm;   path: "app.traktor.decks." + (deckId+1) + ".tempo.true_bpm" }
  AppProperty { id: propMixerStableTempo; path: "app.traktor.decks." + (deckId+1) + ".tempo.true_tempo" }
  AppProperty { id: propTempo;            path: "app.traktor.decks." + (deckId+1) + ".tempo.tempo_for_display" } 
  AppProperty { id: propMixerTotalGain;   path: "app.traktor.decks." + (deckId+1) + ".content.total_gain" }
  
  AppProperty { id: propKeyDisplay;     path: "app.traktor.decks." + (deckId+1) + ".track.key.resulting.precise" }
  AppProperty { id: propIsInSync;       path: "app.traktor.decks." + (deckId+1) + ".sync.enabled"; }  
  AppProperty { id: propSyncMasterDeck; path: "app.traktor.masterclock.source_id" }

  //--- Special Remix Deck Properties   
  AppProperty { id: propRemixBeatPos;     path: "app.traktor.decks." + (deckId+1) + ".remix.current_beat_pos"; }
  AppProperty { id: propRemixQuantize;    path: "app.traktor.decks." + (deckId+1) + ".remix.quant_index"; }
  AppProperty { id: propRemixIsQuantize;  path: "app.traktor.decks." + (deckId+1) + ".remix.quant"; }
  //property string propRemixQuantize: "1/4"

  AppProperty { id: deckAKeyDisplay; path: "app.traktor.decks.1.track.key.resulting.precise" }
  AppProperty { id: deckBKeyDisplay; path: "app.traktor.decks.2.track.key.resulting.precise" }
  AppProperty { id: deckCKeyDisplay; path: "app.traktor.decks.3.track.key.resulting.precise" }
  AppProperty { id: deckDKeyDisplay; path: "app.traktor.decks.4.track.key.resulting.precise" }

  //--------------------------------------------------------------------------------------------------------------------
  //  MAPPING FROM TRAKTOR ENUM TO QML-STATE!
  //--------------------------------------------------------------------------------------------------------------------
  readonly property variant stateMapping:  ["title", "artist", "release", 
                                            "mix", "label", "catNo", 
                                            "genre", "trackLength", "bitrate", 
                                            "bpmTrack", "gain", "elapsedTime", 
                                            "remainingTime", "beats", "beatsToCue", 
                                            "bpm", "tempo", "key", 
                                            "keyText", "comment", "comment2",
                                            "remixer", "pitchRange", "bpmStable", 
                                            "tempoStable", "sync", "off", 
                                            "off", "bpmTrack", "remixBeats", 
                                            "remixQuantize", "keyDisplay"]

/*
  readonly property variant stateMapping:  [0:  "title",          1: "artist",       2:  "release", 
                                            3:  "mix",            4: "label",        5:  "catNo", 
                                            6:  "genre",          7: "trackLength",  8:  "bitrate", 
                                            9:  "bpmTrack",      10: "gain",        11: "elapsedTime", 
                                            12: "remainingTime", 13: "beats",       14: "beatsToCue", 
                                            15: "bpm",           16: "tempo",       17: "key", 
                                            18: "keyText",       19: "comment",     20: "comment2",
                                            21: "remixer",       22: "pitchRange",  23: "bpmStable", 
                                            24: "tempoStable",   25: "sync",        26: "off", 
                                            27: "off",           28: "bpmTrack"     29: "remixBeats"
                                            30: "remixQuantize", 31: "keyDisplay"]
*/
  //--------------------------------------------------------------------------------------------------------------------
  //  STATES FOR THE LABELS IN THE DECK HEADER
  //--------------------------------------------------------------------------------------------------------------------

  state: (explicitName == "") ? stateMapping[textState] : "explicitName"

  states: [
    State { 
      name: "explicitName";     
      PropertyChanges { target: header_text;  text: explicitName } 
    },
    //------------------------------------------------------------------------------------------------------------------
    State { 
      name: "off";     
      PropertyChanges { target: header_text;  text: "" } 
    },
    State { 
      name: "title"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propTitle.value; }
    },
    State { 
      name: "artist";   // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propArtist.value; }
    },
    State { 
      name: "release"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;  
                        text:   (!isLoaded)?"":propAlbum.value; }
    },
    State { 
      name: "genre";   // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;  
                        text:   (!isLoaded)?"":propGenre.value; }
    },
    State { 
      name: "comment"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;  
                        text:   (!isLoaded)?"":propComment.value; }
    },
    State { 
      name: "comment2";// Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;  
                        text:   (!isLoaded)?"":propComment2.value; }
    },
    State { 
      name: "label";// Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;  
                        text:   (!isLoaded)?"":propLabel.value; }
    },
    State { 
      name: "mix";     // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;  
                        text:   (!isLoaded)?"":propMix.value; }
    },
    State { 
      name: "remixer"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString; 
                        text:   (!isLoaded)?"":propRemixer.value; }
    },
    State { 
      name: "catNo"; 
      PropertyChanges { target: header_text; font.family: fontForString;  
                        text:   (!isLoaded)?"":propCatNo.value }
    },
  //--------------------------------------------------------------------------------------------------------------------
    State { 
      name: "trackLength"; 
      PropertyChanges { target: header_text; font.family: fontForNumber;  
                        text:   (!isLoaded)?"":utils.convertToTimeString(propTrackLength.value); }
    },
    State { 
      name: "elapsedTime"; 
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        text:   (!isLoaded)?"":utils.convertToTimeString(propElapsedTime.value); }
    },
    State { 
      name: "remainingTime"; 
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        text:   (!isLoaded)?"":utils.computeRemainingTimeString(propTrackLength.value, propElapsedTime.value); }
    },
  //--------------------------------------------------------------------------------------------------------------------
    State { 
      name: "key"; 
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        color:  getTrackKeyColor(propKeyDisplay.value);
                        text:   (!isLoaded)?"":"♪"+getTrackKeyText(propKeyDisplay.value); }
    },
    State { 
      name: "keyText"; 
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        text:   (!isLoaded)?"":propLegacyKey.value.toString(); }
    },
    State { 
      name: "pitchRange"; 
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        text:   (!isLoaded)?"":toInt_round(propPitchRange.value*100).toString() + "%"; }
    },
    State { 
      name: "bpm"; 
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        text:   (!isLoaded)?"":propMixerBpm.value.toFixed(2).toString(); }
    },
    State { 
      name: "bpmStable"; 
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"": propMixerStableBpm.value.toFixed(2).toString(); }
    },
    State { 
      name: "bpmTrack";
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        text:   (!isLoaded)?"":propMixerStableBpm.value.toFixed(2).toString();  }
    },
    State { 
      name: "tempo"; 
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        text:   (!isLoaded)?"":((propTempo.value-1 <= 0)?"":"+") + ((propTempo.value-1)*100).toFixed(1).toString() + "%"; }
    },
    State { 
      name: "tempoStable"; 
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   getStableTempoString(); }
    },
    State { 
      name: "gain";
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        text:   (!isLoaded)?"":convertToDb(propMixerTotalGain.value).toFixed(1).toString() + "dB"; }
    },
  //--------------------------------------------------------------------------------------------------------------------
    State { 
      name: "beats"; 
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":computeBeatCounterStringFromPosition(((propElapsedTime.value*1000-propGridOffset.value)*propMixerBpm.value)/60000.0); }
    },
    State { 
      name: "beatsToCue";
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        color:  computeBeatsToCueColor();
                        text:   (!isLoaded)?"":computeBeatsToCueString(); }
    },
    State { 
      name: "bitrate"; 
      PropertyChanges { target: header_text;  font.family: fontForNumber; 
                        text:   (!isLoaded)?"":toInt(propBitrate.value / 1000).toString(); }
    },
    
    State { 
      name: "sync";
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        text:  getSyncStatusString(); }
    },
    State { 
      name: "remixBeats";
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        text:  (!isLoaded)?"":computeBeatCounterStringFromPosition(propRemixBeatPos.value); }
    },
    State { 
      name: "remixQuantize";
      PropertyChanges { target: header_text; font.family: fontForNumber; 
                        text:  (!isLoaded) ? "" : ((propRemixIsQuantize.value)? "Q " + propRemixQuantize.description : "Off"); }
    },
    State { 
      name: "keyDisplay"; 
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text: (!isLoaded)?"":(prefs.camelotKey ? utils.convertToCamelot(keyDisplay.value) : keyDisplay.value); }
    }
  ]


  //--------------------------------------------------------------------------------------------------------------------
  //  CONVERSION FUNCTIONS
  //--------------------------------------------------------------------------------------------------------------------
  function toInt(val)       { return parseInt(val); }
  function toInt_round(val) { return parseInt(val+0.5); }
  function log10(num)       { return Math.log(num) / Math.LN10; }

  function convertToDb(gain) {
    var level0dB = 1.0;
    var norm = gain / level0dB;
    if (norm <= 0.0)
      return -0.0000000001;
    
    return 20.0*log10(norm);
  }


  function computeBeatCounterStringFromPosition(beat) {
    var phraseLen = prefs.phraseLength;
    var curBeat  = Math.abs(beat);

    if (beat < 0.0)
      curBeat = curBeat*-1;

    var value1 = Math.floor(((curBeat/4)/phraseLen)+1);
    var value2 = Math.floor(((curBeat/4)%phraseLen)+1);
    var value3 = Math.floor( (curBeat%4)+1);

    if (beat < 0.0)
      return "- " + value1.toString() + "." + value2.toString() + "." + value3.toString();

    return value1.toString() + "." + value2.toString() + "." + value3.toString();
  }


  function getStableTempoString() {
    var tempo = propMixerStableTempo.value - 1;
    return   ((tempo <= 0) ? "" : "+") + (tempo * 100).toFixed(1).toString() + "%";
  }


  function getSyncStatusString() {
    if ( !isLoaded ) 
      return " ";
    else if (isMaster)
      return "MASTER";
    else if (isInSync)
      return "SYNC";

    // Show the decks current pitch value in the area of the Master/Sync indicator 
    // if a deck is neither synced nor set to maste (TP-8070)
    return getStableTempoString();
  }


  function computeBeatsToCueColor() {
    if (propNextCuePoint.value < 0) return parent.textColors[deckId];

    var beats = ((propNextCuePoint.value - propElapsedTime.value * 1000) * propMixerBpm.value) / 60000.0;
    if (beats < 0 || beats > 256) return parent.textColors[deckId];

    var bars = Math.floor(beats / 4);
    if (bars < 4) return "red";

    return parent.textColors[deckId];
  }


  function computeBeatsToCueString() {
    if (propNextCuePoint.value < 0) return "——.—";

    var beats = ((propNextCuePoint.value - propElapsedTime.value * 1000) * propMixerBpm.value) / 60000.0;
    if (beats < 0 || beats > 256) return "——.—";

    var bars = Math.floor(beats / 4);
    var beat = Math.floor(beats % 4) + 1;

    var barsStr = bars.toString();
    if (bars < 10) barsStr = "0" + barsStr;

    return barsStr + "." + beat.toString();
  }


  function getMasterKey() {
    switch (propSyncMasterDeck.value) {
      case 0: return deckAKeyDisplay.value;
      case 1: return deckBKeyDisplay.value;
      case 2: return deckCKeyDisplay.value;
      case 3: return deckDKeyDisplay.value;
    }

    return "";
  }


  function getTrackKeyColor(trackKey) {
    if (isMaster) {
      return parent.textColors[deckId];
    }

    var keyOffset = utils.getMasterKeyOffset(getMasterKey(), trackKey);
    if (keyOffset == 0) {
      return colors.color04MusicalKey; // Yellow
    }
    if (keyOffset == 1 || keyOffset == -1) {
      return colors.color02MusicalKey; // Orange
    }
    if (keyOffset == 2 || keyOffset == 7) {
      return colors.color07MusicalKey; // Green
    }
    if (keyOffset == -2 || keyOffset == -7) {
      return colors.color10MusicalKey; // Blue
    }

    return parent.textColors[deckId];
  }

  function getTrackKeyText(trackKey) {
    return trackKey.replace(
      /(~ )?(\d+(d|m))/,
      function (match, prefix, key) {
        return keyText[key] || key;
      }
    );
  }
}
