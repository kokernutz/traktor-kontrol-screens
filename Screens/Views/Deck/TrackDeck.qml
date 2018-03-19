import CSI 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

import '../../../Defines'
import './../Waveform' as WF
import './../Definitions' as Definitions

Item {
  id: trackDeck
  property int    deckId:          0
  property string deckSizeState:   "large"
  property color  deckColor:       colors.colorBgEmpty // transparent blue not possible for logo due to low bit depth of displays. was: // (deckId < 2) ? colors.colorDeckBlueBright12Full : colors.colorBgEmpty
  property bool   trackIsLoaded:   (primaryKey.value > 0)
  
  readonly property int waveformHeight: (deckSizeState == "small") ? 0 : ( parent ? ( (deckSizeState == "medium") ? (parent.height-50) : (parent.height-60) ) : 0 )

  readonly property int largeDeckBottomMargin: (waveformContainer.isStemStyleDeck) ? 6 : 12  
  readonly property int smallDeckBottomMargin: (deckId > 1) ? 9 : 6

  property bool showLoopSize: false
  property int  zoomLevel:    1
  property bool isInEditMode: false
  property int    stemStyle:    StemStyle.track
  property string propertiesPath: ""

  readonly property int minSampleWidth: 0x800
  readonly property int sampleWidth: minSampleWidth << zoomLevel


  //--------------------------------------------------------------------------------------------------------------------

  AppProperty   { id: deckType;          path: "app.traktor.decks." + (deckId + 1) + ".type"                         }
  AppProperty   { id: primaryKey;        path: "app.traktor.decks." + (deckId + 1) + ".track.content.primary_key" }

  AppProperty { id: trackLength;         path: "app.traktor.decks." + (deckId + 1) + ".track.content.track_length" }
  AppProperty { id: elapsedTime;         path: "app.traktor.decks." + (deckId + 1) + ".track.player.elapsed_time" }

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
    showLoopSize:         trackDeck.showLoopSize
    isInEditMode:         trackDeck.isInEditMode
    stemStyle:            trackDeck.stemStyle

    anchors.topMargin:    5

    // the height of the waveform is defined as the remaining space of deckHeight - stripe.height - spacerWaveStripe.height
    height:  waveformHeight              
    visible: (trackIsLoaded && deckSizeState != "small") ? 1 : 0

    Behavior on height { PropertyAnimation { duration: durations.deckTransition } }
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
    visible:        trackDeck.trackIsLoaded
  }

  Rectangle {
    id: stripeGapFillerRight
    anchors.left:   stripe.right
    anchors.right:  parent.right
    anchors.bottom: stripe.bottom
    height:         stripe.height
    color:          colors.colorBgEmpty
    visible:        trackDeck.trackIsLoaded
  }

  //--------------------------------------------------------------------------------------------------------------------
  
  Rectangle
  {
    id: timeLeftIndicatorBox

    anchors.right:     parent.right
    anchors.bottom:    stripe.bottom
    height:            stripe.height
    width:             50
    color:             colors.colorBgEmpty
    radius:            1
    antialiasing:      false
    opacity:           prefs.displayTimeLeft && trackDeck.trackIsLoaded ? 1 : 0

    Text
    {
      font.family:         "Pragmatica"
      font.pixelSize:      fonts.middleFontSize 
      anchors.fill:        parent
      anchors.rightMargin: 3
      horizontalAlignment: Text.AlignRight
      verticalAlignment:   Text.AlignVCenter
      color:               colors.textColors[deckId]
      text:                utils.computeRemainingTimeString(trackLength.value, elapsedTime.value)
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  WF.Stripe {
    id: stripe

    anchors.left:           trackDeck.left
    anchors.right:          prefs.displayTimeLeft ? timeLeftIndicatorBox.left : trackDeck.right
    anchors.bottom:         trackDeck.bottom
    anchors.bottomMargin:   (deckSizeState == "large") ? largeDeckBottomMargin : smallDeckBottomMargin
    anchors.leftMargin:     9
    anchors.rightMargin:    9
    height:                 28
    opacity:                trackDeck.trackIsLoaded ? 1 : 0

    deckId:                 trackDeck.deckId
    windowSampleWidth:      trackDeck.sampleWidth

    audioStreamKey: deckTypeValid(deckType.value) ? ["PrimaryKey", primaryKey.value] : ["PrimaryKey", 0]

    function deckTypeValid(deckType)      { return (deckType == DeckType.Track || deckType == DeckType.Stem);  }

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
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
    source:               "./../images/EmptyDeck.png"
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
