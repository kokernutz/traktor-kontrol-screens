import CSI 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

import '../../../../Defines'
import '../Waveform' as WF

Item {
  id: trackDeck
  property int    deckId:          0
  property string deckSizeState:   "large"
  property color  deckColor:       colors.colorBgEmpty // transparent blue not possible for logo due to low bit depth of displays. was: // (deckId < 2) ? colors.colorDeckBlueBright12Full : colors.colorBgEmpty
  property bool   trackIsLoaded:   (primaryKey.value > 0)
  
  readonly property variant deckLetters: ["A", "B", "C", "D"]

  readonly property int waveformHeight: (deckSizeState == "small") ? 0 : ( parent ? ( (deckSizeState == "medium") ? (parent.height-55) : (parent.height-70) ) : 0 )

  readonly property int largeDeckBottomMargin: (waveformContainer.isStemStyleDeck) ? 6 : 6  
  readonly property int smallDeckBottomMargin: (deckId > 1) ? 9 : 6

  property bool showLoopSize: false
  property int  zoomLevel:    1
  property bool isInEditMode: false
  property int    stemStyle:    StemStyle.track
  property string propertiesPath: ""

  readonly property int minSampleWidth: 0x800
  readonly property int sampleWidth: minSampleWidth << zoomLevel

  readonly property variant hotcueColors: [colors.hotcue.hotcue, colors.colorRed, colors.hotcue.fade, colors.hotcue.load, colors.hotcue.grid, colors.hotcue.loop ]

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty   { id: deckType;          path: "app.traktor.decks." + (deckId + 1) + ".type"                    }
  AppProperty   { id: primaryKey;        path: "app.traktor.decks." + (deckId + 1) + ".track.content.entry_key" }

  AppProperty { id: trackLength;         path: "app.traktor.decks." + (deckId + 1) + ".track.content.track_length" }

  AppProperty { id: keyLockEnabled;             path: "app.traktor.decks." + (deckId+1) + ".track.key.lock_enabled" }


  //--------------------------------------------------------------------------------------------------------------------
  // Waveform
  //--------------------------------------------------------------------------------------------------------------------

  WF.WaveformContainer {
    id: waveformContainer

    deckId:         trackDeck.deckId
    deckSizeState:  trackDeck.deckSizeState
    sampleWidth:    trackDeck.sampleWidth
    propertiesPath: trackDeck.propertiesPath

    anchors.top:          parent.top
    anchors.left:         parent.left
    anchors.right:        parent.right
    anchors.bottom:       stripe.top

    showLoopSize:         trackDeck.showLoopSize
    isInEditMode:         trackDeck.isInEditMode
    stemStyle:            trackDeck.stemStyle

    anchors.topMargin:    30 // -2 
    anchors.bottomMargin: 5

    // the height of the waveform is defined as the remaining space of deckHeight - stripe.height - spacerWaveStripe.height
    height:  waveformHeight              
    visible: (trackIsLoaded && deckSizeState != "small") ? 1 : 0

    // Behavior on height { PropertyAnimation { duration: durations.deckTransition } }
  }
  

  //--------------------------------------------------------------------------------------------------------------------
  // Stripe
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: stripeGapFillerLeft
    anchors.left:   parent.left
    anchors.right:  stripe.left
    anchors.bottom: stripe.bottom
    height:         stripe.height
    color:          colors.colorBgEmpty
    visible:        trackDeck.trackIsLoaded // && deckSizeState != "small"
  }

  Rectangle {
    id: stripeGapFillerRight
    anchors.left:   stripe.right
    anchors.right:  parent.right
    anchors.bottom: stripe.bottom
    height:         stripe.height
    color:          colors.colorBgEmpty
    visible:        trackDeck.trackIsLoaded // && deckSizeState != "small"
  }

  //--------------------------------------------------------------------------------------------------------------------

  Rectangle
  {
    id: trackDeckIndicator

    anchors.left:      parent.left
    anchors.bottom:    stripe.bottom
    height:            stripe.height
    width:             20
    color:             colors.colorBgEmpty
    radius:            1
    antialiasing:      false
    opacity:           trackDeck.trackIsLoaded ? 1 : 0

    Image {
      id: deck_letter_large
      anchors.fill: parent
      fillMode: Image.Stretch
      source: "../Images/Deck_" + deckLetters[deckId] + ".png"
    }
  }

 //--------------------------------------------------------------------------------------------------------------------
  
  Rectangle
  {
    id: keyLockIndicatorBox

    anchors.right:     parent.right
    anchors.bottom:    stripe.bottom
    height:            stripe.height
    width:             20
    color:             keyLockEnabled.value ? colors.colorDeckBlueBright : colors.colorGrey40
    radius:            1
    antialiasing:      false
    opacity:           trackDeck.trackIsLoaded ? 1 : 0

    Image {
      id: key_lock
      width: 6
      height: 18
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      antialiasing:      false
      source: "../Images/QuarterNote.svg"
    }

    ColorOverlay {
      id:           key_lock_overlay
      color:        keyLockEnabled.value ? colors.colorGrey24 : colors.colorGrey200
      anchors.fill: key_lock
      source:       key_lock
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  WF.Stripe {
    id: stripe

    // readonly property int largeDeckBottomMargin: (waveformContainer.isStemStyleDeck) ? 6 : 12
    
    // readonly property int smallDeckBottomMargin: (deckId > 1) ? 9 : 6

    anchors.left:           trackDeckIndicator.right // trackDeck.left
    anchors.right:          keyLockIndicatorBox.left // trackDeck.right
    anchors.bottom:         hotcues.top              // trackDeck.bottom
    anchors.bottomMargin:   (deckSizeState == "large") ? largeDeckBottomMargin : smallDeckBottomMargin
    anchors.leftMargin:     9
    anchors.rightMargin:    9
    height:                 30 // 28
    opacity:                trackDeck.trackIsLoaded ? 1 : 0

    deckId:                 trackDeck.deckId
    windowSampleWidth:      trackDeck.sampleWidth

    audioStreamKey: deckTypeValid(deckType.value) ? ["PrimaryKey", primaryKey.value] : ["PrimaryKey", 0]

    function deckTypeValid(deckType)      { return (deckType == DeckType.Track || deckType == DeckType.Stem);  }

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

  Row {
    id: hotcues
    height: prefs.displayHotCueBar && deckSizeState != "small" ? 19 : 0
    visible: prefs.displayHotCueBar && deckSizeState != "small" && trackIsLoaded ? true : false
    spacing: 2
    anchors.bottom: parent.bottom
    anchors.bottomMargin: deckSizeState == "medium" ? 1 : 0
    anchors.left: parent.left
    anchors.right: parent.right

    Repeater {
      model: 8
      Rectangle {
        AppProperty { id: exists;  path: "app.traktor.decks." + (deckId+1) + ".track.cue.hotcues." + (index + 1) + ".exists" }
        AppProperty { id: name;    path: "app.traktor.decks." + (deckId+1) + ".track.cue.hotcues." + (index + 1) + ".name" }
        AppProperty { id: type;    path: "app.traktor.decks." + (deckId+1) + ".track.cue.hotcues." + (index + 1) + ".type" }

        width: (parent.width - 14) / 8
        height: parent.height
        color: exists.value > 0 ? hotcueColors[type.value] : colors.colorBgEmpty

        Text {
          width: parent.width - 6
          elide: Text.ElideRight
          text: (index + 1) + " " + (exists.value > 0 && name.value != "n.n." && name.value != "AutoGrid" ? name.value : "")
          color: exists.value > 0 ? colors.colorGrey24 : colors.colorGrey128
          font.family: "Pragmatica MediumTT"        
          font.pixelSize: fonts.smallFontSize // set in state
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
          // anchors.leftMargin: 5
          // anchors.rightMargin: 5
          verticalAlignment: Text.AlignVCenter
        }
      }
    }

    Behavior on height { PropertyAnimation {  duration: durations.deckTransition } }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Empty Deck
  //--------------------------------------------------------------------------------------------------------------------

  // Image (Logo) for empty Track Deck  --------------------------------------------------------------------------------

  Image {
    id: emptyTrackDeckImage
    anchors.fill:         parent
    anchors.bottomMargin: 18
    anchors.topMargin:    5
    visible:              false // visibility is handled through the emptyTrackDeckImageColorOverlay
    source:               "../../../Images/EmptyDeck.png"
    fillMode:             Image.PreserveAspectFit
  }

  // Deck color for empty deck image  ----------------------------------------------------------------------------------

  ColorOverlay {
    id: emptyTrackDeckImageColorOverlay
    anchors.fill: emptyTrackDeckImage
    color:        deckColor
    visible:      (!trackIsLoaded && deckSizeState != "small")
    source:       emptyTrackDeckImage
  }

}
