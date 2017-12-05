import QtQuick 2.0
import CSI 1.0
import Traktor.Gui 1.0 as Traktor

Traktor.Beatgrid {
  id: view
  //-------------------------------------------------------------------------------------------------------------------- 
  // Properties of Traktor.Beatgrid (see QBeatgrid.h)
  //--------------------------------------------------------------------------------------------------------------------

  property var    waveformPosition
  property string propertiesPath: ""

  property real   curMoveKnobValue: 0.0

  // these are waveform width/position in edit mode (independent of playhead)
  property          int  firstBeatPosOnEdit: 0
  readonly property int  posOnEdit:   firstBeatPosOnEdit - overlayWidthInSamples
  readonly property int  widthOnEdit: samplesPerBeat * visibleNumberOfBeats
 
  // ------------------------------------------------------------------------------------------------------------------
  // Variables for the BeatgridEdit View
  //
  // The position of the beatmarkers is fix in this mode. Just the waveform beneath should change. Therefore, it is 
  // important to keep this view independent of the "bpm" resp. "samplesPerBeat". By doing this, we avoid jittering of 
  // the beatmarkers, when changing the BPM fast.
  // ------------------------------------------------------------------------------------------------------------------
  readonly property int focusedNumberOfBeats: (zoomedView.value ? 1 : 4)
  readonly property int visibleNumberOfBeats: 1.25 * focusedNumberOfBeats

  readonly property int beatWidth: Math.floor(view.width / visibleNumberOfBeats)
  
  readonly property int overlayWidth:          Math.floor(view.width / 10)
  readonly property int overlayWidthInSamples: Math.floor(widthOnEdit / 10)
  
  // Receive Knob Values for scrolling in the waveform while in GridEdit Mode
  MappingProperty {
    id: scanControl
    path: propertiesPath + ".beatgrid.scan_control" 
    onValueChanged: { curMoveKnobValue = curMoveKnobValue + 20.0 * value; }
  }

  MappingProperty { id: zoomedView;      path: propertiesPath + ".beatgrid.zoomed_view" }
  MappingProperty { id: scanBeatsOffset; path: propertiesPath + ".beatgrid.scan_beats_offset" }

  //-------------------------------------------------------------------------------------------------------------------- 
  // Find Waveform Position when enabling BeatgridEdit Mode
  //--------------------------------------------------------------------------------------------------------------------

  onEditEnabledChanged: { resetScanControl(); updateEditMode(true); }
  onBeatMarkersChanged: { updateEditMode(false);  }

  function updateEditMode(initialSetup) 
  { 
    if (view.editEnabled && !view.isAnalyzing) 
    {      
      var startPos  = initialSetup ? waveformPosition.playheadPos : posOnEdit + samplesPerBeat
      var grid      = getRelevantGridMarkerForSamplePos(startPos);
      var pos       = 0;
      var beatCounter = 0

      for (var i=0; i < beatMarkers.length; ++i)
      {
        if (beatMarkers[i] > startPos) {
          break; // beatMarkers are sorted... so we can break here
        }
        else if (beatMarkers[i] >= grid)
        {
          if (beatMarkers[i] <= startPos  && beatCounter%4 == 0 ) {
            pos = i;
          }
          ++beatCounter;
        }
      }

      scanBeatsOffset.value = pos;
      firstBeatPosOnEdit = beatMarkers[pos];

      if ( (firstBeatPosOnEdit + 2*samplesPerBeat) >  trackLength)
        decreaseWaveformPos();
    }
  }


  function getRelevantGridMarkerForSamplePos(smplPos) {
    // NOTE: the gridMarkers array might not be sorted!
    var numMarkers = gridMarkers.length;
    var gridPos    = (numMarkers > 0) ? gridMarkers[0] : 0;
    for (var i=0; i<numMarkers; ++i)
    {
      if (gridMarkers[i] <= smplPos && gridMarkers[i] > gridPos ) {
        gridPos = gridMarkers[i];
      }
    }
    return gridPos;
  }


  //-------------------------------------------------------------------------------------------------------------------- 
  // Scrolling in the Waveform while in BeatgridEdit Mode
  //-------------------------------------------------------------------------------------------------------------------- 

  onCurMoveKnobValueChanged: {
    if (editEnabled && curMoveKnobValue > 1) {
      var turns = Math.floor(Math.abs(curMoveKnobValue));
      for(var i=0; i<turns; ++i)
        increaseWaveformPos();
      resetScanControl();
    }
    else if(editEnabled && curMoveKnobValue < -1) {
      var turns = Math.floor(Math.abs(curMoveKnobValue));
      for(var i=0; i<turns; ++i)
        decreaseWaveformPos();
      resetScanControl();
    }

    updateEditMode(false);
  }

  function increaseWaveformPos() {
    var newPos = waveformPosition.waveformPos + 4*samplesPerBeat;
    if ( (newPos + 2*samplesPerBeat) < trackLength )
    {
      firstBeatPosOnEdit = newPos; 
      scanBeatsOffset.value += 4;
    }
  }

  function decreaseWaveformPos() {
    var newPos = waveformPosition.waveformPos - 4*samplesPerBeat;
    if (newPos >= (-2*samplesPerBeat))
    {
      firstBeatPosOnEdit = newPos;
      scanBeatsOffset.value -= 4;
    }
  }

  function resetScanControl() {
    scanControl.value = 0.0;
    curMoveKnobValue  = 0.0;
  }


  //--------------------------------------------------------------------------------------------------------------------
  // Beat Grid
  //--------------------------------------------------------------------------------------------------------------------

  Traktor.WaveformTranslator {
    x: 0
    y: 0
    height: view.height
    followTarget:  waveformPosition
    visible: (!view.editEnabled && beatMarkers.length > 0)
    pos:     0
    useScaling: true
    
    Traktor.BeatgridLines
    {
      anchors.top:          parent.top
      anchors.bottom:       parent.bottom
      anchors.left:         parent.left
      anchors.right:        parent.right
      
      beatMarkerList: beatMarkers
      color:  colors.colorWhite09
    }
  }


  //--------------------------------------------------------------------------------------------------------------------
  // Black Waveform-Overlays in Beatgrid Edit Mode
  //--------------------------------------------------------------------------------------------------------------------

  Repeater {
    model: 2
    Rectangle {
      anchors.bottom: parent.bottom
      anchors.top:    parent.top
      color:          colors.colorBlack75
      
      visible: view.editEnabled && !isAnalyzing
      width:   overlayWidth
      x:       (index == 0) ? 0 : view.width - overlayWidth + 1
    }
  }


  //--------------------------------------------------------------------------------------------------------------------
  // Beat Grid in Edit Mode!
  //
  // Use a seperate GUI, indipendent from Traktor.WaveformTranslator for the Beatgrid in EditMode. This Waveform-Overlays
  // we can avoid jitter of the markers while editing (offset/bpm).
  //--------------------------------------------------------------------------------------------------------------------

  Repeater { 
    model: focusedNumberOfBeats

    Item {
      anchors.bottom:    view.bottom
      anchors.top:       view.top
      width:             1
      visible: view.editEnabled && !isAnalyzing
      x:       overlayWidth + index * (beatWidth + 1)

      // beat grid
      Rectangle {
        x: 0; y: 0; width: 1
        height: view.height - 2
        color:  colors.colorWhite25 
      }

      // flags
      Rectangle {
        color: colors.colorGrey40 // if downbeat should be highlighted in future:  ((index%4) != 0) ? colors.colorGrey40 : colors.colorWhite  
        x: 4; y: 0; width: 21; height: 15
        radius: 1
        Text { 
          anchors.fill:        parent
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment:   Text.AlignVCenter          
          text:  index + 1
          font.pixelSize: fonts.smallFontSize    
          color: colors.colorGrey192
          style: Text.Outline
          styleColor: colors.colorGrey24
        }
      }
    }
  }


  //--------------------------------------------------------------------------------------------------------------------
  // Ghost Marker (Playmarker for Edit Mode)
  //--------------------------------------------------------------------------------------------------------------------
  
  Traktor.WaveformTranslator {
    id: ghostMarker 
    followTarget:   waveformPosition
    width:          1
    anchors.bottom: view.bottom
    anchors.top:    view.top 
    pos:            ghostMarkerPos(waveformPosition.playheadPos)
    visible:        (view.editEnabled && !isAnalyzing && !isPosInsideEditBeats(waveformPosition.playheadPos))

    Rectangle {
      anchors.fill: ghostMarker
      color:        colors.colorWhite 
    }
  }

  function ghostMarkerPos(playPos) {
    var offset   = 0.5*samplesPerBeat + waveformPosition.waveformPos;
    var ghostPos = ((playPos - offset) % (4*samplesPerBeat) );
    
    ghostPos = (playPos < offset) ? (4*samplesPerBeat + ghostPos) : ghostPos;
    return ghostPos + offset;
  }

  function isPosInsideEditBeats(pos) {
    return (pos < Math.floor(waveformPosition.waveformPos+4.5*samplesPerBeat) && pos > Math.floor(waveformPosition.waveformPos+0.5*samplesPerBeat));
  }

}
