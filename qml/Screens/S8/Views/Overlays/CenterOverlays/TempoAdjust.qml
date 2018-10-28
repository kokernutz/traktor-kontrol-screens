import QtQuick 2.0
import CSI 1.0

import '../../../../Defines' as Defines


// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: tempoAdjust

  Defines.Margins {id: customMargins }

  property int deckId: 0

  readonly property bool isSyncedToOtherDeck: (masterDeckId.value != deckId) && isSynced.value
  readonly property bool isSyncedToMasterClock: (masterDeckId.value == -1) && isSynced.value
  
  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: isSynced;   path: "app.traktor.decks." + (deckId+1) + ".sync.enabled" }
  AppProperty { id: stableBpm;  path: "app.traktor.decks." + (deckId+1) + ".tempo.true_bpm" }
  AppProperty { id: baseBpm;    path: "app.traktor.decks." + (deckId+1) + ".tempo.base_bpm" }
  
  AppProperty { id: masterDeckId;   path: "app.traktor.masterclock.source_id" }
  AppProperty { id: masterClockBpm; path: "app.traktor.masterclock.tempo" }
  
  //--------------------------------------------------------------------------------------------------------------------

  function titleForBPMOverlay(masterId, synced)
  {
    if ((masterId == -1) && synced)
    {
      return "MASTER CLOCK BPM";
    }
    else if (masterId == deckId)
    {
      return "MASTER BPM";
    }
    else if (synced)
    {
      return "SYNCED BPM";
    }
    else
    {
      return "BPM";
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  // headline
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        customMargins.topMarginCenterOverlayHeadline
    font.pixelSize:           fonts.largeFontSize
    color:                    colors.colorCenterOverlayHeadline
    text: titleForBPMOverlay(masterDeckId.value, isSynced.value)
  }

  // value
  Text {
    readonly property real dispBpm: isSyncedToMasterClock ? masterClockBpm.value : stableBpm.value
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        47
    font.pixelSize:           fonts.superLargeValueFontSize
    font.family   :           "Pragmatica"
    color:                    colors.colorWhite    
    text:                     dispBpm.toFixed(2).toString()
  }
  
  // footline
  Text {
    anchors.bottom:           parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin:     14.0
    font.pixelSize:           fonts.smallFontSize
    color:                    colors.colorGrey104
    text:                     "Hold BACK to reset"
    visible:                  !isSyncedToMasterClock && !isSyncedToOtherDeck
  }

}
