import QtQuick 2.0
import CSI 1.0

Item {

	id: slice_view

	property int    deckId
	property real   zoom_factor:  0.9 // 90%
	property string slicer_path:  "app.traktor.decks." + (deckId+1) + ".freeze"
  
  property int    stemStyle:    StemStyle.track

	property bool   enabled: 	    propEnabled.value
	property real   slice_start: 	propSliceStart.value // in seconds
	property real   slice_width:  propSliceWidth.value  // in seconds
	property int    slice_count: 	propSliceCount.value

	AppProperty { id: propEnabled; 	  path: slicer_path + ".enabled" }
	AppProperty { id: propSliceCount; path: slicer_path + ".slice_count" }
	AppProperty { id: propSliceStart; path: slicer_path + ".slice_start_in_sec" }
	AppProperty { id: propSliceWidth; path: slicer_path + ".slice_width_in_sec" }
	
  //--------------------------------------------------------------------------------------------------------------------

	Row {
		id: slices
		property real boxWidth: width / slice_count
		property real margins: parent.width * ((1.0-parent.zoom_factor)/2.0) 

		opacity: parent.enabled
		anchors.fill: parent
    anchors.topMargin: -1
		anchors.leftMargin:  margins - 1
		anchors.rightMargin: margins

		Repeater {
			id: slice_repeater
			model: slice_view.slice_count
			Slice {
				height:      slices.height
				width:       slices.boxWidth
				slice_index: index
				last_slice:  index + 1 == slice_count
				slicer_path: slice_view.slicer_path
        stemStyle:   slice_view.stemStyle
			}
		}
	}
}
