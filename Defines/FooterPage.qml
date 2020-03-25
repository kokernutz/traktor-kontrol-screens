pragma Singleton

import QtQuick 2.0

// Constants to use in enables based on active footer page
QtObject {
    readonly property int empty:            0
  	readonly property int filter:          	1
  	readonly property int pitch:           	2
  	readonly property int fxSend:          	3
  	readonly property int fx:              	4
  	readonly property int midi:           	5
    readonly property int volume:           6
    readonly property int slot1:            7
    readonly property int slot2:            8
    readonly property int slot3:            9
    readonly property int slot4:            10

    readonly property variant states:       [ "EMPTY"
        , "FILTER"
        , "PITCH"
        , "FX SEND"
        , "FX"
        , "MIDI"
        , "VOLUME"
        , "SLOT 1"
        , "SLOT 2"
        , "SLOT 3"
        , "SLOT 4"
                                            ]
}

  
