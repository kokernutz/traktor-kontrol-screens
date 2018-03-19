import QtQuick 2.0

QtObject {

// browser preferences coming soon (morelines)

// deck preferences
readonly property bool displayAlbumCover:      true
readonly property bool displayBeatCountdown:   true
readonly property bool displayPhaseMeter:      true // caveat: there's a bug where it won't sometimes won't properly update if you manually switch master tracks
readonly property bool displayTimeLeft: 	   true
readonly property bool displayTrackComment:    true
readonly property bool spectrumWaveformColors: true

}