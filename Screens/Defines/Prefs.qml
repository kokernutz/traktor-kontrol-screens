import QtQuick 2.0

QtObject {

// change the behavior of the mods by setting the following items to true or false

// global preferences
readonly property bool camelotKey: 				true

// browser preferences
readonly property bool displayMatchGuides:		true
readonly property bool displayMoreItems:		true // toggle between 7 and 9 items on screen

// deck preferences
readonly property bool displayAlbumCover:		true
readonly property int  displayBeatCounter:		1    // 0 = off, 1 = Count Down To Next Cue Point, 2 = Count From Grid Start
readonly property bool displayPhaseMeter:		true
readonly property bool displayTimeLeft:			true
readonly property bool displayTrackComment:		true
readonly property bool spectrumWaveformColors:	true

}