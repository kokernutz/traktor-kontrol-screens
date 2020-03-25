import CSI 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

import '../Widgets' as Widgets

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
  property int    deck_Id:           0
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

  readonly property int rightFieldMargin: 2
  readonly property int fieldHeight:      20
  readonly property int fieldWidth:       78
  readonly property int topRowHeight:     24
  readonly property int bottomRowsHeight: 19

  readonly property bool   isLoaded:    top_left_text.isLoaded
  readonly property int    deckType:    deckTypeProperty.value
  readonly property int    isInSync:    top_left_text.isInSync
  readonly property int    isMaster:    top_left_text.isMaster
  readonly property double syncPhase:   (headerPropertySyncPhase.value*2.0).toFixed(2)
  readonly property int    loopSizePos: headerPropertyLoopSize.value

  function hasTrackStyleHeader(deckType)      { return (deckType == DeckType.Track  || deckType == DeckType.Stem);  }

  // PROPERTY SELECTION
  // IMPORTANT: See 'stateMapping' in DeckHeaderText.qml for the correct Mapping from
  //            the state-enum in c++ to the corresponding state
  // NOTE: For now, we set fix states in the DeckHeader! But we wanna be able to
  //       change the states.
  property int topLeftState:      prefs.topLeftText                       // headerSettingTopLeft.value
  property int topCenterState:    hasTrackStyleHeader(deckType) ? prefs.topCenterText : 30 // headerSettingTopMid.value
  property int topRightState:     prefs.topRightText                                // headerSettingTopRight.value

  property int middleLeftState:   prefs.middleLeftText                                 // headerSettingMidLeft.value
  property int middleCenterState: hasTrackStyleHeader(deckType) ? prefs.middleCenterText : 29 // headerSettingMidMid.value
  property int middleRightState:  prefs.middleRightText                                // headerSettingMidRight.value

  property int bottomLeftState:   prefs.bottomLeftText
  property int bottomCenterState: prefs.bottomCenterText
  property int bottomRightState:  prefs.bottomRightText

  height: largeHeaderHeight
  clip: false //true
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

  AppProperty { id: mixerFX;       path: "app.traktor.mixer.channels." + (deck_Id+1) + ".fx.select" }
  AppProperty { id: mixerFXOn;     path: "app.traktor.mixer.channels." + (deck_Id+1) + ".fx.on" }

  AppProperty { id: deckRunning;   path: "app.traktor.decks." + (deck_Id+1) + ".running" } 

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
                               && middle_right_text.text == "SYNC" 
                               && syncPhase != 0.0 ) ? 1 : 0;
  }

  Timer {
    id: phase_sync_blink
    property bool enabled: false
    interval: 200; running: true; repeat: true
    onTriggered: middle_right_text.visible = enabled ? !middle_right_text.visible : true
    onEnabledChanged: { middle_right_text.visible = true }
  }


  
  //--------------------------------------------------------------------------------------------------------------------
  //  DECK HEADER TEXT
  //--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id:top_line;
    width:  deck_header.width 
    height: deck_Id >= 2 ? 1 : 0
    color:  colors.colorBgEmpty
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

  // first row

  // top_left_text: TOP LEFT
  DeckHeaderText {
    id: top_left_text
    deckId: deck_Id
    explicitName: ""
    height: topRowHeight
    textState: topLeftState
    color:      textState == 17 || textState == 18 || textState == 31 ? 
      parent.colorForKey(utils.returnKeyIndex(deckKeyDisplay.value)) : textColors[deck_Id]
    elide:     Text.ElideRight
    font.pixelSize:     fonts.largeFontSize // set in state
    anchors.top:        parent.top
    anchors.left:       cover_small.right
    anchors.right:      top_middle_text.left
    anchors.leftMargin: _intSetInState  // set by 'state'
    verticalAlignment: Text.AlignVCenter
    Behavior on anchors.left { NumberAnimation { duration: speed } }
    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
  }
  
  // top_middle_text: TOP CENTER
  DeckHeaderText {
    id: top_middle_text
    deckId: deck_Id
    explicitName: ""
    width: fieldWidth
    height: topRowHeight
    textState:  topCenterState
    color:      textState == 17 || textState == 18 || textState == 31 ? 
      parent.colorForKey(utils.returnKeyIndex(deckKeyDisplay.value)) : textColors[deck_Id]
    font.pixelSize: fonts.largeFontSize
    anchors.top:          parent.top
    anchors.right:        top_right_text.left
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    // Behavior on height             { NumberAnimation { duration: speed } }
    // Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    visible: isLoaded
  }

  // top_right_text: TOP RIGHT
  DeckHeaderText {
    id: top_right_text
    deckId: deck_Id
    explicitName: ""
    width: fieldWidth 
    height: topRowHeight
    textState:  topRightState
    color:      textState == 17 || textState == 18 || textState == 31 ? 
      parent.colorForKey(utils.returnKeyIndex(deckKeyDisplay.value)) : textColors[deck_Id]
    font.pixelSize: fonts.largeFontSize
    anchors.top:          parent.top
    anchors.right:        parent.right
    anchors.rightMargin:  rightFieldMargin
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    visible: isLoaded
  }

  // second row

  // middle_left_text: MIDDLE LEFT
  DeckHeaderText {
    id: middle_left_text
    deckId: deck_Id
    explicitName: ""
    height: bottomRowsHeight
    textState:  middleLeftState
    color:      textState == 17 || textState == 18 || textState == 31 ? 
      parent.colorForKey(utils.returnKeyIndex(deckKeyDisplay.value)) : darkerTextColors[deck_Id]
    elide:      Text.ElideRight
    font.pixelSize:     fonts.middleFontSize
    anchors.top:        top_left_text.bottom
    anchors.left:       cover_small.right
    anchors.right:      top_middle_text.left
    anchors.leftMargin: 5
    anchors.rightMargin: 5
    verticalAlignment: Text.AlignVCenter
  }

    // middle_center_text: MIDDLE CENTER
  DeckHeaderText {
    id: middle_center_text
    deckId: deck_Id
    explicitName: ""
    width: fieldWidth
    height: bottomRowsHeight
    textState:  middleCenterState
    visible: isLoaded
    color:      textState == 17 || textState == 18 || textState == 31 ? 
      parent.colorForKey(utils.returnKeyIndex(deckKeyDisplay.value)) : darkerTextColors[deck_Id]
    elide:      Text.ElideRight
    opacity:    _intSetInState        // set by 'state'
    font.pixelSize: fonts.middleFontSize
    anchors.top:          top_middle_text.bottom
    anchors.right:        middle_right_text.left
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    Behavior on opacity             { NumberAnimation { duration: speed } }
  }

    // middle_right_text: MIDDLE RIGHT
  DeckHeaderText {
    id: middle_right_text
    deckId: deck_Id
    explicitName: ""
    width: fieldWidth
    height: bottomRowsHeight
    textState: middleRightState
    visible: isLoaded
    anchors.top: top_right_text.bottom
    anchors.right:        parent.right
    anchors.rightMargin:  rightFieldMargin
    color:      textState == 17 || textState == 18 || textState == 31 ? 
      parent.colorForKey(utils.returnKeyIndex(deckKeyDisplay.value)) : darkerTextColors[deck_Id]
    opacity:    _intSetInState          // set by 'state'
    font.pixelSize: fonts.middleFontSize
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    onTextChanged: {updateHeader()}
    Behavior on opacity             { NumberAnimation { duration: speed } }
  }

  // third row

  // extra_middle_left_text: BOTTOM LEFT
  DeckHeaderText {
    id: extra_middle_left_text
    deckId: deck_Id
    explicitName: ""
    height: bottomRowsHeight
    textState:  bottomLeftState
    color:      textState == 17 || textState == 18 || textState == 31 ? 
      parent.colorForKey(utils.returnKeyIndex(deckKeyDisplay.value)) : darkerTextColors[deck_Id]
    elide:      Text.ElideRight
    opacity:    _intSetInState        // set by 'state'
    font.pixelSize:     fonts.middleFontSize
    anchors.top:        middle_left_text.bottom
    anchors.left:       cover_small.right
    anchors.right:      original_tempo.left
    anchors.leftMargin: 5
    anchors.rightMargin: 5
    verticalAlignment: Text.AlignVCenter
    Behavior on opacity             { NumberAnimation { duration: speed } }
  }

  // BOTTOM CENTER
  DeckHeaderText {
    id: bottom_center
    deckId: deck_Id
    explicitName: ""
    height: bottomRowsHeight
    textState: bottomCenterState
    visible: isLoaded
    width:  fieldWidth
    anchors.bottom:           parent.bottom
    anchors.right:            bottom_right.left
    color:      textState == 17 || textState == 18 || textState == 31 ? 
      parent.colorForKey(utils.returnKeyIndex(deckKeyDisplay.value)) : darkerTextColors[deck_Id]
    opacity: _intSetInState          // set by 'state'
    font.pixelSize: fonts.middleFontSize
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    Behavior on opacity             { NumberAnimation { duration: speed } }
    onTextChanged: {updateHeader()}
  }

 // BOTTOM RIGHT
  DeckHeaderText {
    id: bottom_right
    deckId: deck_Id
    explicitName: ""
    textState: bottomRightState
    visible: isLoaded
    width:  fieldWidth
    height: bottomRowsHeight
    anchors.bottom: parent.bottom
    anchors.right:        parent.right
    anchors.rightMargin:  rightFieldMargin
    color:      textState == 17 || textState == 18 || textState == 31 ? 
      parent.colorForKey(utils.returnKeyIndex(deckKeyDisplay.value)) : darkerTextColors[deck_Id]
    opacity:    _intSetInState          // set by 'state'
    font.pixelSize: fonts.middleFontSize
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    Behavior on opacity             { NumberAnimation { duration: speed } }
  }

  MappingProperty { id: showBrowserOnTouch; path: "mapping.settings.show_browser_on_touch"; onValueChanged: { updateExplicitDeckHeaderNames() } }

  // deck header footer

  Item {
    id: deck_header_footer
    height: fieldHeight
    width: parent.width
    anchors.top: deck_header.bottom
    anchors.topMargin: 5

    Rectangle {
      id: sync_indicator
      width: 62
      height: parent.height
      anchors.top: parent.top
      color: deckRunning.value && isInSync ? colors.colorDeckBlueBright : colors.colorGrey40

      Text {
        anchors.fill: parent
        text: "SYNC"
        color: isInSync ? (deckRunning.value ? colors.colorGrey24 : colors.colorDeckBlueBright) : colors.colorGrey128
        font.family: "Pragmatica MediumTT"
        font.pixelSize: fonts.smallFontSize + 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
      }
    }

    Rectangle {
      id: master_indicator
      width: 62
      height: parent.height
      anchors.top: parent.top
      anchors.left: sync_indicator.right
      anchors.leftMargin: 2
      color: deckRunning.value && isMaster ? colors.colorDeckBlueBright : colors.colorGrey40

      Text {
        anchors.fill: parent
        text: "MASTER"
        color: isMaster ? (deckRunning.value ? colors.colorGrey24 : colors.colorDeckBlueBright) : colors.colorGrey128
        font.family: "Pragmatica MediumTT"
        font.pixelSize: fonts.smallFontSize + 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
      }
    }

    Rectangle {
      id: mixerfx_indicator
      width: 62
      height: parent.height
      anchors.top: parent.top
      anchors.right: loop_indicator.left
      anchors.rightMargin: 2
      color: mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.colorGrey40

      Text {
        anchors.fill: parent
        text: prefs.mixerFXNames[mixerFX.value]
        color: mixerFXOn.value ? colors.colorGrey40 : colors.mixerFXColors[mixerFX.value]
        font.family: "Pragmatica MediumTT"
        font.pixelSize: fonts.smallFontSize + 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
      }
    }

    Rectangle {
      id: loop_indicator
      width: 62
      height: parent.height
      anchors.top: parent.top
      anchors.right: parent.right
      color: colors.colorGrey40 // deckRunning.value && isMaster ? colors.colorDeckBlueBright : colors.colorGrey40

      Text {
        anchors.fill: parent
        text: "LOOP "  + loopText[loopSizePos]
        color: colors.colorGrey200 // isMaster ? (deckRunning.value ? colors.colorGrey24 : colors.colorDeckBlueBright) : colors.colorGrey200
        font.family: "Pragmatica" //MediumTT"
        font.pixelSize: fonts.smallFontSize + 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
      }
    }

    Widgets.PhaseMeter {
      id: phase_meter
      deckId: deck_Id
      visible: prefs.displayPhaseMeter
      width: parent.width - 4 - ((master_indicator.width + 2)* 4)
      height: parent.height - 4
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
      // opacity: (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
    }

    visible: isLoaded
    Behavior on opacity { NumberAnimation { duration: speed } }
  }

  function updateExplicitDeckHeaderNames()
  {
    if (directThru.value) {
      top_left_text.explicitName      = "Direct Thru";
      middle_left_text.explicitName   = "The Mixer Channel is currently In Thru mode";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      middle_center_text.explicitName = " ";
      middle_right_text.explicitName  = " ";
    }
    else if (deckType == DeckType.Live) {
      top_left_text.explicitName      = "Live Input";
      middle_left_text.explicitName   = "Traktor Audio Passthru";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      middle_center_text.explicitName = " ";
      middle_right_text.explicitName  = " ";
    }
    else if ((deckType == DeckType.Track)  && !isLoaded) {
      top_left_text.explicitName      = "No Track Loaded";
      middle_left_text.explicitName   = showBrowserOnTouch.value ? "Touch Browse Knob" : "Push Browse Knob";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      middle_center_text.explicitName = " ";
      middle_right_text.explicitName  = " ";
    }
    else if (deckType == DeckType.Stem && !isLoaded) {
      top_left_text.explicitName      = "No Stem Loaded";
      middle_left_text.explicitName   = showBrowserOnTouch.value ? "Touch Browse Knob" : "Push Browse Knob";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      middle_center_text.explicitName = " ";
      middle_right_text.explicitName  = " ";
    }
    else if (deckType == DeckType.Remix && !isLoaded) {
      top_left_text.explicitName      = " ";
      // Force the the following DeckHeaderText to be empty
      middle_left_text.explicitName   = " ";
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      middle_center_text.explicitName = " ";
      middle_right_text.explicitName  = " ";
    }
    else {
      // Switch off explicit naming!
      top_left_text.explicitName      = "";
      middle_left_text.explicitName   = "";
      top_middle_text.explicitName    = "";
      top_right_text.explicitName     = "";
      middle_center_text.explicitName = "";
      middle_right_text.explicitName  = "";
    }
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
    } else {
      cover_small.opacity       = 1;
      cover_small.width         = prefs.displayAlbumCover ? largeHeaderHeight - 2 : 0;
      cover_small.height        = prefs.displayAlbumCover ? largeHeaderHeight - 2 : 0;
    }
  }

  Rectangle {
    id: cover_small
    anchors.top: top_line.bottom
    anchors.left: parent.left
    anchors.topMargin: 1
    anchors.leftMargin: 0
    width:  prefs.displayAlbumCover ? largeHeaderHeight - 4 : 0
    height: width

    // if no cover can be found: blue / grey background (set in parent). Otherwise transparent
    opacity:  (headerPropertyCover.value == "") ? 1.0 : 0.0
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

  //--------------------------------------------------------------------------------------------------------------------
  //  Loop Size
  //--------------------------------------------------------------------------------------------------------------------

  function updateLoopSize() {
    if (  headerState == "large" && isLoaded && (hasTrackStyleHeader(deckType) || (deckType == DeckType.Remix )) && !directThru.value ) {
      loop_size.opacity = 1.0;
      loop_size.opacity = showStepSequencer ? 0.0 : 1.0;
      stem_text.opacity = 0.6
    } else {
      loop_size.opacity = 0.0;
      stem_text.opacity = 0.0;
    }
  }

   //--------------------------------------------------------------------------------------------------------------------
  //  Key & Lock indicator
  //--------------------------------------------------------------------------------------------------------------------

  function colorForKey(keyIndex) {
    return colors.musicalKeyColors[keyIndex]
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

      PropertyChanges { target: top_left_text;      anchors.leftMargin: 5 }
      PropertyChanges { target: top_warning_text;   font.pixelSize: fonts.middleFontSize; anchors.topMargin: -1 }

      PropertyChanges { target: middle_left_text;   opacity: 0; }
      PropertyChanges { target: bottom_warning_text;  opacity: 0; }

      PropertyChanges { target: middle_center_text; opacity: 0; }
      PropertyChanges { target: middle_right_text;  opacity: 0; }

      PropertyChanges { target: extra_middle_left_text;   opacity: 0; }
      PropertyChanges { target: bottom_center;   opacity: 0; }

      PropertyChanges { target: deck_header_footer;        opacity: 0; }

      PropertyChanges { target: beat_indicators;        opacity: 0; }
      PropertyChanges { target: key_lock;               opacity: 0; }
      PropertyChanges { target: key_lock_overlay;       opacity: 0; }
      PropertyChanges { target: key_text;               opacity: 0; }
      PropertyChanges { target: bottom_right;         opacity: 0; }
      PropertyChanges { target: middle_center_text;  opacity: 0; }
    },
    State {
      name: "large"; //when: temporaryMouseArea.released
      PropertyChanges { target: deck_header;        height: largeHeaderHeight }

      PropertyChanges { target: top_left_text;      anchors.leftMargin: (deckType.description === "Live Input" || directThru.value) ? -1 : 5}
      PropertyChanges { target: top_warning_text;   font.pixelSize: fonts.largeFontSize; anchors.topMargin: -2 }

      PropertyChanges { target: middle_center_text; opacity: 0; }
      PropertyChanges { target: middle_left_text;   opacity: 1;                                                  anchors.leftMargin: (deckType.description === "Live Input" || directThru.value) ? -1 : 5}

      PropertyChanges { target: middle_right_text;  opacity: 1; }

      PropertyChanges { target: extra_middle_left_text; opacity: 1; }
      PropertyChanges { target: bottom_center;  opacity: 1; }

      PropertyChanges { target: deck_header_footer;         opacity: 1; }

      PropertyChanges { target: beat_indicators;         opacity: 1; }
      PropertyChanges { target: key_lock;                opacity: 1; }
      PropertyChanges { target: key_lock_overlay;        opacity: 1; }
      PropertyChanges { target: key_text;                opacity: 1; }
      PropertyChanges { target: bottom_right;          opacity: 1; }
      PropertyChanges { target: middle_center_text;   opacity: 1; }
    }
  ]
}
