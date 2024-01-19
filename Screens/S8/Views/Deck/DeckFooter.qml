import CSI 1.0
import QtQuick 2.0
import Qt5Compat.GraphicalEffects

//--------------------------------------------------------------------------------------------------------------------
//  DECK FOOTER
//--------------------------------------------------------------------------------------------------------------------

Item {
  id: deck_footer
  
  // QML-only deck types
  readonly property int thruDeckType:  4

  // Here all the properties defining the content of the DeckFooter are listed. They are set in DeckView.
  property int    deck_Id:           0
  property string footerState:      "large" // this property is used to set the state of the footer (large/small)
  
  // color for empty cover bg
  readonly property variant coverBgEmptyColors: [colors.colorDeckBlueDark,    colors.colorDeckBlueDark,     colors.colorGrey48,   colors.colorGrey48  ]
  // color for empty cover circles
  readonly property variant circleEmptyColors:  [colors.rgba(0, 37, 54, 255),  colors.rgba(0,  37, 54, 255),                       colors.colorGrey24,   colors.colorGrey24  ]

  readonly property variant loopText:           ["/32", "/16", "1/8", "1/4", "1/2", "1", "2", "4", "8", "16", "32"]
  readonly property variant emptyDeckCoverColor:["Blue", "Blue", "White", "White"] // deckId = 0,1,2,3

  // these variables can not be changed from outside
  readonly property int speed: 40  // Transition speed

  readonly property int    deckType:    propDeckType.value
  readonly property bool   isLoaded:    (primaryKey.value > 0) || (deckType == DeckType.Remix)
  readonly property int    isInSync:    propIsInSync.value
  readonly property int    isMaster:    (propSyncMasterDeck.value == deck_Id) ? 1 : 0
  readonly property int    loopSizePos: footerPropertyLoopSize.value

  height: 40
  opacity: (primaryKey.value > 0 && footerState != "small") ? 1 : 0
  clip: false //true
  Behavior on opacity { NumberAnimation { duration: speed } }
  

  //--------------------------------------------------------------------------------------------------------------------
  // Helper function
  function toInt(val) { return parseInt(val); }

  //--------------------------------------------------------------------------------------------------------------------
  //  DECK PROPERTIES
  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: propDeckType;               path: "app.traktor.decks." + (deck_Id+1) + ".type" }
  AppProperty { id: primaryKey;                 path: "app.traktor.decks." + (deck_Id+1) + ".track.content.entry_key" }
  AppProperty { id: propIsInSync;               path: "app.traktor.decks." + (deck_Id+1) + ".sync.enabled"; }
  AppProperty { id: propSyncMasterDeck;         path: "app.traktor.masterclock.source_id" }
  AppProperty { id: propSnap;                   path: "app.traktor.snap" }

  AppProperty { id: directThru;                 path: "app.traktor.decks." + (deck_Id+1) + ".direct_thru"; onValueChanged: { updateFooter() } }
  AppProperty { id: footerPropertyCover;        path: "app.traktor.decks." + (deck_Id+1) + ".content.cover_md5" }
  AppProperty { id: footerPropertyIsLooping;    path: "app.traktor.decks." + (deck_Id+1) + ".loop.is_in_active_loop"; }
  AppProperty { id: footerPropertyLoopActive;   path: "app.traktor.decks." + (deck_Id+1) + ".loop.active"; }
  AppProperty { id: footerPropertyLoopSize;     path: "app.traktor.decks." + (deck_Id+1) + ".loop.size"; }

  AppProperty { id: propTrackLength;            path: "app.traktor.decks." + (deck_Id+1) + ".track.content.track_length"; }
  AppProperty { id: propElapsedTime;            path: "app.traktor.decks." + (deck_Id+1) + ".track.player.elapsed_time"; }
  AppProperty { id: propMixerBpm;               path: "app.traktor.decks." + (deck_Id+1) + ".tempo.base_bpm" }
  AppProperty { id: propTempo;                  path: "app.traktor.decks." + (deck_Id+1) + ".tempo.tempo_for_display" }
  AppProperty { id: propKeyEnabled;             path: "app.traktor.decks." + (deck_Id+1) + ".track.key.lock_enabled" }


  //--------------------------------------------------------------------------------------------------------------------
  //  UPDATE VIEW
  //--------------------------------------------------------------------------------------------------------------------

  Component.onCompleted:  { updateFooter(); }
  onFooterStateChanged:   { updateFooter(); }
  onIsLoadedChanged:      { updateFooter(); }
  onDeckTypeChanged:      { updateFooter(); }
  onIsMasterChanged:      { updateFooter(); }

  function updateFooter() {
    updateCoverArt();
  }


  
  //--------------------------------------------------------------------------------------------------------------------
  //  DECK FOOTER TEXT
  //--------------------------------------------------------------------------------------------------------------------

  // LOOP SIZE
  Rectangle {
    width: 34
    height: 28
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.rightMargin: 317
    color: "transparent"

    Text {
      anchors.top: parent.top
      anchors.topMargin: -1
      anchors.left: parent.left
      color: footerPropertyLoopActive.value ? colors.colorGreen : "white"
      font.pixelSize: fonts.scale(9)
      font.family: "Pragmatica MediumTT"
      text: "↻"
    }
    Text {
      anchors.top: parent.top
      anchors.right: parent.right
      color: footerPropertyLoopActive.value ? colors.colorGreen : "white"
      font.pixelSize: fonts.scale(9)
      font.family: "Pragmatica MediumTT"
      text: "LOOP"
    }
    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      width: parent.width
      height: 16
      color: footerPropertyIsLooping.value ? colors.colorGreen : "transparent"
      border.color: footerPropertyLoopActive.value ? colors.colorGreen : "gray"
      border.width: 1
      radius: 2

      Text {
        anchors.fill: parent
        anchors.topMargin: 1
        color: footerPropertyIsLooping.value ? "black" : (footerPropertyLoopActive.value ? colors.colorGreen : "gray")
        font.pixelSize: fonts.scale(13)
        font.family: "Pragmatica MediumTT"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: loopText[loopSizePos]
      }
    }
  }

  // REMAINING TIME
  Rectangle {
    width: 90
    height: 28
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.rightMargin: 195
    color: "transparent"

    // Label
    Text {
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.leftMargin: 1
      color: "white"
      font.pixelSize: fonts.scale(9)
      font.family: "Pragmatica MediumTT"
      text: "REMAIN"
    }
    // Milliseconds Value
    Text {
      id: time_anchor
      anchors.bottom: parent.bottom
      anchors.bottomMargin: -2
      anchors.right: parent.right
      color: "white"
      font.pixelSize: fonts.middleFontSize
      font.family: "Pragmatica"

      text: {
        var seconds = propTrackLength.value - propElapsedTime.value;
        if (seconds < 0) seconds = 0;

        var ms = Math.floor((seconds % 1) * 1000);

        var msStr = ms.toString();
        if (ms < 10) msStr = "0" + msStr;
        if (ms < 100) msStr = "0" + msStr;

        return "." + msStr;
      }
    }
    // Minutes and Seconds Value
    Text {
      anchors.bottom: parent.bottom
      anchors.bottomMargin: -3
      anchors.right: time_anchor.left
      color: "white"
      font.pixelSize: fonts.largeValueFontSize
      font.family: "Pragmatica"

      text: {
        var seconds = propTrackLength.value - propElapsedTime.value;
        if (seconds < 0) seconds = 0;

        var sec = Math.floor(seconds % 60);
        var min = (Math.floor(seconds) - sec) / 60;

        var secStr = sec.toString();
        if (sec < 10) secStr = "0" + secStr;

        var minStr = min.toString();
        if (min < 10) minStr = "0" + minStr;

        return minStr + ":" + secStr;
      }
    }

    // Quantize
    Text {
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.rightMargin: 1
      color: "red"
      font.pixelSize: fonts.scale(9)
      font.family: "Pragmatica MediumTT"
      text: "QUANTIZE"
      visible: propSnap.value
    }
  }

  // TEMPO
  Rectangle {
    width: 70
    height: 28
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.rightMargin: 93
    color: "transparent"

    // Label
    Text {
      anchors.top: parent.top
      anchors.left: parent.left
      color: "white"
      font.pixelSize: fonts.scale(9)
      font.family: "Pragmatica MediumTT"
      text: "TEMPO"
    }
    // Percent Sign
    Text {
      id: tempo_anchor
      anchors.bottom: parent.bottom
      anchors.bottomMargin: -2
      anchors.right: parent.right
      color: "white"
      font.pixelSize: fonts.smallFontSize
      font.family: "Pragmatica"
      text: "%"
    }
    // Value
    Text {
      anchors.bottom: parent.bottom
      anchors.bottomMargin: -3
      anchors.right: tempo_anchor.left
      color: "white"
      font.pixelSize: fonts.largeValueFontSize
      font.family: "Pragmatica"

      text: {
        var tempo = propTempo.value - 1;
        return ((tempo <= 0) ? "" : "+") + (tempo * 100).toFixed(2).toString();
      }
    }

    // Key Lock
    Text {
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.rightMargin: 1
      color: "red"
      font.pixelSize: fonts.scale(9)
      font.family: "Pragmatica MediumTT"
      text: "LOCK"
      visible: propKeyEnabled.value
    }
  }

  // BPM
  Rectangle {
    width: 60
    height: 28
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.rightMargin: 1
    color: "transparent"

    // Label
    Text {
      anchors.top: parent.top
      anchors.left: parent.left
      color: "white"
      font.pixelSize: fonts.scale(9)
      font.family: "Pragmatica MediumTT"
      text: "BPM"
    }
    // Master BPM
    Text {
      anchors.top: parent.top
      anchors.right: parent.right
      color: "orange"
      font.pixelSize: fonts.scale(9)
      font.family: "Pragmatica MediumTT"
      text: "MASTER"
      visible: isMaster
    }
    // Decimal Value
    Text {
      id: bpm_anchor
      anchors.bottom: parent.bottom
      anchors.bottomMargin: -2
      anchors.right: parent.right
      color: isMaster ? "orange" : "white"
      font.pixelSize: fonts.middleFontSize
      font.family: "Pragmatica"

      text: {
        var bpm = propMixerBpm.value * propTempo.value;
        var dec = Math.round((bpm % 1) * 100);
        if (dec == 100) dec = 0;

        var decStr = dec.toString();
        if (dec < 10) decStr = "0" + decStr;

        return "." + decStr;
      }
    }
    // Whole Number Value
    Text {
      anchors.bottom: parent.bottom
      anchors.bottomMargin: -3
      anchors.right: bpm_anchor.left
      color: isMaster ? "orange" : "white"
      font.pixelSize: fonts.largeValueFontSize
      font.family: "Pragmatica"

      text: {
        return Math.floor((propMixerBpm.value * propTempo.value).toFixed(2)).toString();
      }
    }

    // Synced BPM
    Rectangle {
      anchors.top: parent.top
      anchors.topMargin: 1
      anchors.right: parent.right
      width: 27
      height: 9
      color: "white"
      radius: 2
      visible: isInSync && !isMaster

      Text {
        anchors.centerIn: parent
        color: "black"
        font.pixelSize: fonts.scale(9)
        font.family: "Pragmatica MediumTT"
        text: "SYNC"
      }
    }
  }


  //--------------------------------------------------------------------------------------------------------------------
  //  Cover Art
  //--------------------------------------------------------------------------------------------------------------------

  // Inner Border

  function updateCoverArt() {
    if (footerState == "small" || deckType == DeckType.Live || directThru.value) {
      cover_small.opacity       = 0;
      cover_innerBorder.opacity = 0;
    } else {
      cover_small.opacity       = 1;
      cover_innerBorder.opacity = (!isLoaded || (footerPropertyCover.value == "")) ? 0 :1;
    }
  }

  Rectangle {
    id: blackBorder
    color: "black"
    anchors.fill: cover_small
    anchors.margins: -1
  }

  DropShadow {
    anchors.fill: blackBorder
    cached: false
    fast: false
    horizontalOffset: 0
    verticalOffset: 0
    radius: 3.0
    samples: 32
    spread: 0.5
    color: "#000000"
    transparentBorder: true
    source: blackBorder
  }

  Rectangle {
    id: cover_small
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: 1
    width:  42
    height: 42

    // if no cover can be found: blue / grey background (set in parent). Otherwise transparent
    opacity:  (footerPropertyCover.value == "") ? 1.0 : 0.0
    //visible: footerState == "large" && (opacity == 1.0)
    color:  coverBgEmptyColors[deck_Id]
    Behavior on opacity { NumberAnimation { duration: speed } }
    Behavior on width { NumberAnimation { duration: speed } }
    Behavior on height { NumberAnimation { duration: speed } }

    Rectangle {
      id: circleEmptyCover
      height: 18
      width: height
      radius: height * 0.5
      anchors.centerIn: parent
      visible:!isLoaded
      color: circleEmptyColors[deck_Id]
    }

    Rectangle {
      id: dotEmptyCover
      height: 2
      width: height
      anchors.centerIn: parent
      visible: !isLoaded
      color:   colors.colorGrey08
    }

    Image {
      id: coverImage
      source: "image://covers/" + ((isLoaded) ? footerPropertyCover.value : "" )
      anchors.fill: parent
      sourceSize.width: width
      sourceSize.height: height
      visible: isLoaded
      opacity: (footerPropertyCover.value == "") ? 0.3 : 1.0
      fillMode: Image.PreserveAspectCrop
      Behavior on height   { NumberAnimation { duration: speed } }
    }
  }

  Rectangle {
    id: cover_innerBorder
    color: "transparent"
    border.width: 1
    border.color: colors.colorWhite16
    height: cover_small.height
    width: height
    anchors.top: cover_small.top
    anchors.left: cover_small.left
  }
}
