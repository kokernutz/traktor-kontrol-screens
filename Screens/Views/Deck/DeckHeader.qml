import CSI 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0
import './../Definitions' as Definitions
import './../Widgets' as Widgets

//--------------------------------------------------------------------------------------------------------------------
//  DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

Item {
  id: deck_header
  
  // QML-only deck types
  readonly property int thruDeckType:  4

  // Placeholder variables for properties that have to be set in the elements for completeness - but are actually set
  // in the states
  readonly property int    _intSetInState:    0

  // Here all the properties defining the content of the DeckHeader are listed. They are set in DeckView.
  property int    deck_Id:          0
  property int    deckId:           deck_Id
  property string headerState:      "large" // this property is used to set the state of the header (large/small)
  
  readonly property variant deckLetters:        ["A",                         "B",                          "C",                  "D"                 ]
  readonly property variant textColors:         [colors.colorDeckBlueBright,  colors.colorDeckBlueBright,   colors.colorGrey232,  colors.colorGrey232 ]
  readonly property variant darkerTextColors:   [colors.colorDeckBlueDark,    colors.colorDeckBlueDark,     colors.colorGrey72,   colors.colorGrey72  ]
  // color for empty cover bg
  readonly property variant coverBgEmptyColors: [colors.colorDeckBlueDark,    colors.colorDeckBlueDark,     colors.colorGrey48,   colors.colorGrey48  ]
  // color for empty cover circles
  readonly property variant circleEmptyColors:  [colors.rgba(0, 37, 54, 255),  colors.rgba(0,  37, 54, 255),                       colors.colorGrey24,   colors.colorGrey24  ]

  readonly property variant loopText:           ["/32", "/16", "1/8", "1/4", "1/2", "1", "2", "4", "8", "16", "32"]
  readonly property variant emptyDeckCoverColor:["Blue", "Blue", "White", "White"] // deckId = 0,1,2,3

  // these variables can not be changed from outside
  readonly property int speed: 40  // Transition speed
  readonly property int smallHeaderHeight: 26
  readonly property int largeHeaderHeight: 64

  readonly property int fieldHeight:      20
  readonly property int fieldWidthNarrow: 50
  readonly property int fieldWidthWide:   65

  readonly property bool   isLoaded:    top_left_text.isLoaded
  readonly property int    deckType:    deckTypeProperty.value
  readonly property int    isInSync:    top_left_text.isInSync
  readonly property int    isMaster:    top_left_text.isMaster
  readonly property double syncPhase:   (headerPropertySyncPhase.value*2.0).toFixed(2)
  readonly property int    loopSizePos: headerPropertyLoopSize.value

  function hasTrackStyleHeader(deckType)      { return (deckType == DeckType.Track  || deckType == DeckType.Stem);  }

  // PROPERTY SELECTION
  // IMPORTANT: See 'stateMapping' in DeckHeaderText.qml for the correct Mapping from

  // the state-enum in c++ to the corresponding state
  // NOTE: For now, we set fix states in the DeckHeader! But we wanna be able to
  // change the states.

  property int topLeftState:            0                                       // headerSettingTopLeft.value
  property int bottomLeftState:         1                                       // headerSettingMidLeft.value
  property int extraBottomLeftState:    19                                      // headerSettingMidLeft.value

  property int topMiddleState:          hasTrackStyleHeader(deckType) ? 12 : 30 // headerSettingTopMid.value
  property int bottomMiddleState:       hasTrackStyleHeader(deckType) ? 11 : 29 // headerSettingMidMid.value

  property int topRightState:           23                                      // headerSettingTopRight.value
  property int bottomRightState:        24 // 25                                // headerSettingMidRight.value
  property int extraBottomRightState:   25

  property int originalBPMState:        15

  height: largeHeaderHeight
  clip:   false //true
  Behavior on height { NumberAnimation { duration: speed } }

  readonly property int warningTypeNone:    0
  readonly property int warningTypeWarning: 1
  readonly property int warningTypeError:   2

  property bool isError:   (deckHeaderWarningType.value == warningTypeError)
  

  //--------------------------------------------------------------------------------------------------------------------
  // Helper function
  function toInt(val) { return parseInt(val); }

  //--------------------------------------------------------------------------------------------------------------------
  //  DECK PROPERTIES
  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: deckKeyDisplay;     path: "app.traktor.decks." + (deckId+1) + ".track.key.key_for_display"; onValueChanged: { updateKeyColor() } }
  AppProperty { id: propMusicalKey;     path: "app.traktor.decks." + (deckId+1) + ".content.musical_key" }
  AppProperty { id: propSyncMasterDeck; path: "app.traktor.masterclock.source_id" }

  AppProperty { id: propElapsedTime;    path: "app.traktor.decks." + (deckId+1) + ".track.player.elapsed_time"; } 
  AppProperty { id: propNextCuePoint;   path: "app.traktor.decks." + (deckId+1) + ".track.player.next_cue_point"; }
  AppProperty { id: propMixerBpm;       path: "app.traktor.decks." + (deckId+1) + ".tempo.base_bpm" }

  AppProperty { id: deckTypeProperty;           path: "app.traktor.decks." + (deck_Id+1) + ".type" }

  AppProperty { id: directThru;                 path: "app.traktor.decks." + (deck_Id+1) + ".direct_thru"; onValueChanged: { updateHeader() } }
  AppProperty { id: headerPropertyCover;        path: "app.traktor.decks." + (deck_Id+1) + ".content.cover_md5" }
  AppProperty { id: headerPropertySyncPhase;    path: "app.traktor.decks." + (deck_Id+1) + ".tempo.phase"; }
  AppProperty { id: headerPropertyLoopActive;   path: "app.traktor.decks." + (deck_Id+1) + ".loop.active"; }
  AppProperty { id: headerPropertyLoopSize;     path: "app.traktor.decks." + (deck_Id+1) + ".loop.size"; }
  AppProperty { id: keyLockEnabled;             path: "app.traktor.decks." + (deck_Id+1) + ".track.key.lock_enabled" }

  AppProperty { id: deckHeaderWarningActive;       path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".active"; }
  AppProperty { id: deckHeaderWarningType;         path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".type";   }
  AppProperty { id: deckHeaderWarningMessage;      path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".long";   }
  AppProperty { id: deckHeaderWarningShortMessage; path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".short";  }

  //--------------------------------------------------------------------------------------------------------------------
  //  STATE OF THE DECK HEADER LABELS
  //--------------------------------------------------------------------------------------------------------------------
  AppProperty { id: headerSettingTopLeft;       path: "app.traktor.settings.deckheader.top.left";  }  
  AppProperty { id: headerSettingTopMid;        path: "app.traktor.settings.deckheader.top.mid";   }  
  AppProperty { id: headerSettingTopRight;      path: "app.traktor.settings.deckheader.top.right"; }
  AppProperty { id: headerSettingMidLeft;       path: "app.traktor.settings.deckheader.mid.left";  }  
  AppProperty { id: headerSettingMidMid;        path: "app.traktor.settings.deckheader.mid.mid";   }  
  AppProperty { id: headerSettingMidRight;      path: "app.traktor.settings.deckheader.mid.right"; }

  AppProperty { id: sequencerOn;   path: "app.traktor.decks." + (deckId + 1) + ".remix.sequencer.on" }
  readonly property bool showStepSequencer: (deckType == DeckType.Remix) && sequencerOn.value && (screen.flavor != ScreenFlavor.S5)
  onShowStepSequencerChanged: { updateLoopSize(); }

  //--------------------------------------------------------------------------------------------------------------------
  //  UPDATE VIEW
  //--------------------------------------------------------------------------------------------------------------------

  Component.onCompleted:  { updateHeader(); }
  onHeaderStateChanged:   { updateHeader(); }
  onIsLoadedChanged:      { updateHeader(); }
  onDeckTypeChanged:      { updateHeader(); }
  onSyncPhaseChanged:     { updateHeader(); }
  onIsMasterChanged:      { updateHeader(); }

  function updateHeader() {
    updateExplicitDeckHeaderNames();
    updateCoverArt();
    updateLoopSize();
    updatePhaseSyncBlinker();
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  PHASE SYNC BLINK
  //--------------------------------------------------------------------------------------------------------------------

  function updatePhaseSyncBlinker() {
    phase_sync_blink.enabled = (  headerState != "small" 
                               && isLoaded 
                               && !directThru.value
                               && !isMaster 
                               && deckType != DeckType.Live 
                               && bottom_right_text.text == "SYNC" 
                               && syncPhase != 0.0 ) ? 1 : 0;
  }

  Timer {
    id: phase_sync_blink
    property bool enabled: false
    interval: 200; running: true; repeat: true
    onTriggered: bottom_right_text.visible = enabled ? !bottom_right_text.visible : true
    onEnabledChanged: { bottom_right_text.visible = true }
  }
  
  //--------------------------------------------------------------------------------------------------------------------
  //  DECK HEADER TEXT
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: top_line;
    width:  deck_header.width 
    height: deck_Id >= 2 ? 1 : 0
    color:  textColors[deck_Id]
    visible: parent.parent.deckSize == "large" ? false : true // don't display when large
  }

  Rectangle {
    id: stem_text
    width:  35; height: 14
    y: 3
    x: top_left_text.x + top_left_text.paintedWidth + 5

    color:         colors.colorBgEmpty
    border.width:  1
    border.color:  textColors[deck_Id]
    radius:        3
    opacity:        0.6

    visible:       (deckType == DeckType.Stem) || showStepSequencer
    Text { x: showStepSequencer ? 5 : 3; y:1; text: showStepSequencer ? "STEP" : "STEM"; color: textColors[deck_Id]; font.pixelSize:fonts.miniFontSize }

    Behavior on opacity { NumberAnimation { duration: speed } }
  }

  // top_left_text: TITLE
  DeckHeaderText {
    id: top_left_text
    deckId: deck_Id
    explicitName: ""
//    maxTextWidth: ((deckType == DeckType.Stem) ? 200 - stem_text.width : 220) - cover_small.width
    textState: topLeftState
    color:     textColors[deck_Id]
    elide:     Text.ElideRight
    font.pixelSize:     fonts.largeFontSize // set in state
    anchors.top:        parent.top
    anchors.left:       cover_small.right
    anchors.right:      top_middle_text.left
    anchors.leftMargin: _intSetInState  // set by 'state'
    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
  }
  
  // bottom_left_text: ARTIST
  DeckHeaderText {
    id: bottom_left_text
    deckId: deck_Id
    explicitName: ""
//    maxTextWidth : (directThru.value ? 1000 : 220) - cover_small.width
    textState:  bottomLeftState
    color:      darkerTextColors[deck_Id]
    elide:      Text.ElideRight
    font.pixelSize:     fonts.middleFontSize
    anchors.top:        top_left_text.bottom
    anchors.left:       cover_small.right
    anchors.right:      top_middle_text.left
    anchors.leftMargin: 5
    anchors.rightMargin: 5
  }

  // extra_bottom_left_text: COMMENT
  DeckHeaderText {
    id: extra_bottom_left_text
    deckId: deck_Id
    explicitName: ""
//    maxTextWidth: directThru.value ? 1000 : (parent.width / 2) - cover_small.width
    textState:  extraBottomLeftState
    color:      darkerTextColors[deck_Id]
    elide:      Text.ElideRight
    opacity:    _intSetInState        // set by 'state'
    font.pixelSize:     fonts.middleFontSize
    visible: prefs.displayTrackComment
    anchors.top:        bottom_left_text.bottom
    anchors.left:       cover_small.right
    anchors.right:      original_tempo.left
    anchors.leftMargin: 5
    anchors.rightMargin: 5
    Behavior on opacity             { NumberAnimation { duration: speed } }
  }

  // top_middle_text: REMAINING TIME (BEAT COUNTDOWN)
  DeckHeaderText {
    id: top_middle_text
    explicitName: ""
    deckId:  deck_Id
    visible: isLoaded && prefs.displayBeatCountdown
    width:   fieldWidthWide
    height:  _intSetInState
    anchors.top:         parent.top
    anchors.right:       top_right_text.left
    textState:           topMiddleState
    color:          textColors[deck_Id]
    font.pixelSize: fonts.largeFontSize
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    Behavior on height             { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
  }

  // bottom_middle_text: ELAPSED TIME
  DeckHeaderText {
    id: bottom_middle_text
    deckId: deck_Id
    explicitName: ""
    maxTextWidth : 80
    textState:  bottomMiddleState
    color:      darkerTextColors[deck_Id]
    elide:      Text.ElideRight
    opacity:    _intSetInState        // set by 'state'
    font.pixelSize: fonts.middleFontSize
    horizontalAlignment: Text.AlignRight
    anchors.top:          top_line.bottom
    anchors.right:        parent.right
    anchors.topMargin:    20
    anchors.rightMargin:  0 // change this if it is ever used
    Behavior on opacity             { NumberAnimation { duration: speed } }
  }

  // top_right_text: BPM
  DeckHeaderText {
    id: top_right_text
    deckId: deck_Id
    explicitName: ""
    textState:  topRightState
    visible: isLoaded
    width:  fieldWidthWide
    height: fieldHeight
    anchors.top:   parent.top
    anchors.right: extra_bottom_right_text.left
    anchors.rightMargin: 3
    font.pixelSize: fonts.middleFontSize
    color: textColors[deck_Id]
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
  } 

  // bottom_right_text: (TEMPO OFFSET)
  DeckHeaderText {
    id: bottom_right_text
    deckId: deck_Id
    explicitName: ""
    textState:  bottomRightState
    visible: isLoaded
    width:  fieldWidthWide
    height: fieldHeight
    anchors.verticalCenter: parent.verticalCenter
    anchors.right: extra_bottom_right_text.left
    anchors.rightMargin: 3
    color:      darkerTextColors[deck_Id]
    opacity:    _intSetInState          // set by 'state'
    font.pixelSize: fonts.middleFontSize
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    onTextChanged: {updateHeader()}
    Behavior on opacity             { NumberAnimation { duration: speed } }
  }

  // ORIGINAL TEMPO
  DeckHeaderText {
    id: original_tempo
    deckId: deck_Id
    explicitName: ""
    textState:  originalBPMState
    visible: isLoaded
    width:  fieldWidthWide
    height: fieldHeight
    anchors.bottom: parent.bottom
    anchors.right: extra_bottom_right_text.left
    anchors.rightMargin: 3
    color:      darkerTextColors[deck_Id]
    opacity:    _intSetInState          // set by 'state'
    font.pixelSize: fonts.middleFontSize
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    Behavior on opacity             { NumberAnimation { duration: speed } }
  }

  // SYNC/MASTER
  DeckHeaderText {
    id: extra_bottom_right_text
    deckId: deck_Id
    explicitName: ""
    textState:  extraBottomRightState
    visible: isLoaded
    width:  fieldWidthNarrow
    height: fieldHeight
    anchors.bottom:           parent.bottom
    anchors.right:            parent.right
    anchors.bottomMargin:     0
    anchors.rightMargin:      3
    color: isMaster == 1 ? colors.color03Bright : isInSync == 1 ? "green" : "red"
    opacity: _intSetInState          // set by 'state'
    font.pixelSize: fonts.middleFontSize
    horizontalAlignment: Text.AlignRight
    anchors.verticalCenterOffset: 1
    onTextChanged: {updateHeader()}
    Behavior on opacity             { NumberAnimation { duration: speed } }
  }

  MappingProperty { id: showBrowserOnTouch; path: "mapping.settings.show_browser_on_touch"; onValueChanged: { updateExplicitDeckHeaderNames() } }

  function updateExplicitDeckHeaderNames()
  {
    if (directThru.value) {
      top_left_text.explicitName      = "Direct Thru";
      bottom_left_text.explicitName   = "The Mixer Channel is currently In Thru mode";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      bottom_middle_text.explicitName = " ";
      bottom_right_text.explicitName  = " ";
    }
    else if (deckType == DeckType.Live) {
      top_left_text.explicitName      = "Live Input";
      bottom_left_text.explicitName   = "Traktor Audio Passthru";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      bottom_middle_text.explicitName = " ";
      bottom_right_text.explicitName  = " ";
    }
    else if ((deckType == DeckType.Track)  && !isLoaded) {
      top_left_text.explicitName      = "No Track Loaded";
      bottom_left_text.explicitName   = showBrowserOnTouch.value ? "Touch Browse Knob" : "Push Browse Knob";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      bottom_middle_text.explicitName = " ";
      bottom_right_text.explicitName  = " ";
    }
    else if (deckType == DeckType.Stem && !isLoaded) {
      top_left_text.explicitName      = "No Stem Loaded";
      bottom_left_text.explicitName   = showBrowserOnTouch.value ? "Touch Browse Knob" : "Push Browse Knob";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      bottom_middle_text.explicitName = " ";
      bottom_right_text.explicitName  = " ";
    }
    else if (deckType == DeckType.Remix && !isLoaded) {
      top_left_text.explicitName      = " ";
      // Force the the following DeckHeaderText to be empty
      bottom_left_text.explicitName   = " ";
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      bottom_middle_text.explicitName = " ";
      bottom_right_text.explicitName  = " ";
    }
    else {
      // Switch off explicit naming!
      top_left_text.explicitName      = "";
      bottom_left_text.explicitName   = "";
      top_middle_text.explicitName    = "";
      top_right_text.explicitName     = "";
      bottom_middle_text.explicitName = "";
      bottom_right_text.explicitName  = "";
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Phase Meter
  //--------------------------------------------------------------------------------------------------------------------

  Widgets.PhaseMeter {
    id: phase_meter
    deckId: deck_Id
    visible: prefs.displayPhaseMeter
    width: fieldWidthWide
    height: fieldHeight
    anchors.verticalCenter: parent.verticalCenter
    anchors.right: bottom_right_text.left
    opacity: (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: speed } }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Cover Art
  //--------------------------------------------------------------------------------------------------------------------

  // Inner Border

  function updateCoverArt() {
    if (headerState == "small" || deckType == DeckType.Live || directThru.value) {
      cover_small.opacity       = 0;
      cover_small.width         = 0;
      cover_small.height        = cover_small.width;
      cover_innerBorder.opacity = 0;
    } else {
      cover_small.opacity       = 1;
      cover_small.width         = prefs.displayAlbumCover ? largeHeaderHeight - 2 : 0;
      cover_small.height        = prefs.displayAlbumCover ? largeHeaderHeight - 2 : 0;
      cover_innerBorder.opacity = (!isLoaded || (headerPropertyCover.value == "")) ? 0 :1;
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
    anchors.top: top_line.bottom
    anchors.left: parent.left
    anchors.topMargin: 1
    anchors.leftMargin: 0
    width:  prefs.displayAlbumCover ? largeHeaderHeight - 4 : 0;
    height: width;

    // if no cover can be found: blue / grey background (set in parent). Otherwise transparent
    opacity:  (headerPropertyCover.value == "") ? 1.0 : 0.0
    // visible: headerState == "large" && (opacity == 1.0)
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
      visible:!isLoaded && prefs.displayAlbumCover 
      color: circleEmptyColors[deck_Id]
    }

    Rectangle {
      id: dotEmptyCover
      height: 2
      width: height
      anchors.centerIn: parent
      visible: !isLoaded && prefs.displayAlbumCover 
      color:   colors.colorGrey08
    }

    Image {
      id: coverImage
      source: "image://covers/" + ((isLoaded) ? headerPropertyCover.value : "" )
      anchors.fill: parent
      sourceSize.width: width
      sourceSize.height: height
      visible: isLoaded
      opacity: (headerPropertyCover.value == "") ? 0.3 : 1.0
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

  //--------------------------------------------------------------------------------------------------------------------
  //  Loop Size
  //--------------------------------------------------------------------------------------------------------------------

  function updateLoopSize() {
    if ( isLoaded && (hasTrackStyleHeader(deckType) || (deckType == DeckType.Remix )) && !directThru.value ) {
      loop_size.opacity = 1.0;
      loop_size.opacity = showStepSequencer ? 0.0 : 1.0;
      stem_text.opacity = 0.6
    } else {
      loop_size.opacity = 0.0;
      stem_text.opacity = 0.0;
    }
  }

  Widgets.SpinningWheel {
    id: loop_size
    visible: isLoaded
    width: fieldHeight - 1 // 30
    height: width // 30
    anchors.top: parent.top
    anchors.topMargin: 1
    anchors.leftMargin: 7
    anchors.left: extra_bottom_right_text.left

    spinning: false
    opacity: loop_size.opacity
    textColor: headerPropertyLoopActive.value ? colors.colorGreen50 : textColors[deck_Id]
    Behavior on opacity             { NumberAnimation { duration: speed } }
    Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }

    Text {
      id: numberText
      text: loopText[loopSizePos]
      color: headerPropertyLoopActive.value ? colors.colorGreen : textColors[deck_Id]
      font.pixelSize: fonts.scale((loopSizePos < 5) ? 11 : 13)
      font.family: "Pragmatica MediumTT"
      anchors.fill: loop_size
      anchors.rightMargin: 1
      anchors.topMargin: 1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment:   Text.AlignVCenter
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Key & Lock indicator
  //--------------------------------------------------------------------------------------------------------------------

  function colorForKey(keyIndex) {
    return colors.musicalKeyColors[keyIndex]
  }

  Image {
    id: key_lock
    visible: isLoaded
    anchors.horizontalCenter:   loop_size.horizontalCenter
    anchors.verticalCenter:     parent.verticalCenter
    antialiasing:      false
    width:  fieldHeight
    height: fieldHeight
    source: "./../Images/Lock_Icon.svg"
  }

  ColorOverlay {
    id:           key_lock_overlay
    visible:      isLoaded
    color:        keyLockEnabled.value ? colors.colorWhite : colors.colorGrey64
    anchors.fill: key_lock
    source:       key_lock
  }

  Text {
    id:      key_text
    visible: isLoaded 
    height:  fieldHeight
    width:   fieldWidth / 2
    anchors.verticalCenter: parent.verticalCenter
    anchors.right:          parent.right
    anchors.rightMargin:    3
    anchors.verticalCenterOffset: 1
    horizontalAlignment:    Text.AlignRight
    font.pixelSize:         fonts.middleFontSize
    text:                   prefs.camelotKey ? utils.convertToCamelot(deckKeyDisplay.value) : deckKeyDisplay.value
    color:                  parent.colorForKey(utils.returnKeyIndex(deckKeyDisplay.value)) 
    onTextChanged:          { color = parent.border.color }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Deck Letter (A, B, C or D)
  //--------------------------------------------------------------------------------------------------------------------

  Image {
    id: deck_letter_large
    anchors.top: top_line.bottom
    anchors.right: parent.right
    anchors.rightMargin: 3
    width: 28 * .6
    height: 36 * .6
    visible: false
    clip: true
    fillMode: Image.Stretch
    source: "./../images/Deck_" + deckLetters[deck_Id] + ".png"
    Behavior on height { NumberAnimation { duration: speed } }
    Behavior on opacity { NumberAnimation { duration: speed } }
  }

  ColorOverlay {
    id: deck_letter_color_overlay
    color: textColors[deck_Id]
    anchors.fill: deck_letter_large
    source: deck_letter_large
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  WARNING MESSAGES
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: warning_box
    anchors.bottom:     parent.bottom
    anchors.topMargin:  20
    anchors.right:      deck_letter_large.left
    anchors.left:       cover_small.right
    anchors.leftMargin: 5
    height:             parent.height -1
    color:              colors.colorBlack
    visible:            deckHeaderWarningActive.value
    
    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }

    Text {
      id: top_warning_text
      color:              isError ? colors.colorRed : colors.colorOrange
      font.pixelSize:     fonts.largeFontSize // set in state

      text: deckHeaderWarningShortMessage.value

      anchors.top:        parent.top
      anchors.left:       parent.left
      anchors.topMargin:  -1 // set by 'state'
      Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
      Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    Text {
      id: bottom_warning_text
      color:      isError ? colors.colorRed : colors.colorOrangeDimmed
      elide:      Text.ElideRight
      font.pixelSize:     fonts.middleFontSize

      text: deckHeaderWarningMessage.value


      anchors.top:        parent.top
      anchors.left:       parent.left
      anchors.topMargin:  18
      Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
      Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }
  }

  Timer {
    id: warningTimer
    interval: 1200
    repeat: true
    running: deckHeaderWarningActive.value
    onTriggered: {
      if (warning_box.opacity == 1) {
        warning_box.opacity = 0;
      } else {
        warning_box.opacity = 1;
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  STATES FOR THE DIFFERENT HEADER SIZES
  //--------------------------------------------------------------------------------------------------------------------

  state: headerState

  states: [
    State {
      name: "small";
      PropertyChanges { target: deck_header;        height: smallHeaderHeight }

      PropertyChanges { target: top_warning_text;   font.pixelSize: fonts.middleFontSize; anchors.topMargin: -1 }
      PropertyChanges { target: bottom_warning_text;  opacity: 0; }

      PropertyChanges { target: top_left_text;      font.pixelSize: fonts.middleFontSize; anchors.leftMargin: 5 }
      PropertyChanges { target: bottom_left_text;   opacity: 0; }
      PropertyChanges { target: extra_bottom_left_text;   opacity: 0; }

      PropertyChanges { target: top_middle_text;      font.pixelSize: fonts.middleFontSize; height: fieldHeight}
      PropertyChanges { target: bottom_middle_text; opacity: 0; }

      PropertyChanges { target: bottom_right_text;  opacity: 0; }
      PropertyChanges { target: extra_bottom_right_text;   opacity: 0; }

      PropertyChanges { target: beat_indicators;        opacity: 0; }
      PropertyChanges { target: key_lock;               opacity: 0; }
      PropertyChanges { target: key_lock_overlay;       opacity: 0; }
      PropertyChanges { target: key_text;               opacity: 0; }
      PropertyChanges { target: original_tempo;         opacity: 0; }
      PropertyChanges { target: sync_master_indicator;  opacity: 0; }
    },
    State {
      name: "large"; //when: temporaryMouseArea.released
      PropertyChanges { target: deck_header;        height: largeHeaderHeight }

      PropertyChanges { target: top_warning_text;   font.pixelSize: fonts.largeFontSize; anchors.topMargin: -2 }

      PropertyChanges { target: top_left_text;      font.pixelSize: fonts.largeFontSize - 1; anchors.leftMargin: (deckType.description === "Live Input" || directThru.value) ? -1 : 5}
      PropertyChanges { target: bottom_left_text;   opacity: 1; anchors.leftMargin: (deckType.description === "Live Input" || directThru.value) ? -1 : 5}
      PropertyChanges { target: extra_bottom_left_text; opacity: 1; }

      PropertyChanges { target: top_middle_text;    font.pixelSize: fonts.largeFontSize; height: top_left_text.height}
      PropertyChanges { target: bottom_middle_text; opacity: 0; }

      PropertyChanges { target: bottom_right_text;  opacity: 1; }
      PropertyChanges { target: extra_bottom_right_text;  opacity: 1; }

      PropertyChanges { target: beat_indicators;         opacity: 1; }
      PropertyChanges { target: key_lock;                opacity: 1; }
      PropertyChanges { target: key_lock_overlay;        opacity: 1; }
      PropertyChanges { target: key_text;                opacity: 1; }
      PropertyChanges { target: original_tempo;          opacity: 1; }
      PropertyChanges { target: sync_master_indicator;   opacity: 1; }
    }
  ]
}
