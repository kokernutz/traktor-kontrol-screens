pragma Singleton

import QtQuick 2.0

// Constants to use in enables based on active overlay
QtObject {
    readonly property int none:               0
    readonly property int bpm:                1
    readonly property int key:                2
    readonly property int fx:                 3
    readonly property int quantize:           4
    readonly property int slice:              5
    readonly property int sorting:            6
    readonly property int capture:            7
    readonly property int browserWarnings:    8
    readonly property int swing:              9


    readonly property variant states:       [ "none"
                                            , "bpm"
                                            , "key"
                                            , "fx"
                                            , "quantize"
                                            , "slice"
                                            , "sorting"
                                            , "capture"
                                            , "browserWarnings"
                                            , "swing"
                                            ]
}

  
