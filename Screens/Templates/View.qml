import QtQuick 2.0

Rectangle {
  id: root

  property alias viewState: showHideState.state
  property bool  active: false
  
  readonly property int transitionTime: 180

  anchors.margins: 0
  anchors.fill: parent
  color: "black"
  Item {
    id: showHideState  
    states: [
      State { name: "up";    PropertyChanges { target: root; opacity: 0; active: false } },
      State { name: "current"; PropertyChanges { target: root; opacity: 1; active: true  } },
      State { name: "down";   PropertyChanges { target: root; opacity: 0; active: false } }
    ]

    transitions: [
      Transition {
        from: "current"; to: "up";
        SequentialAnimation {
          ParallelAnimation {
            NumberAnimation { target: root; property: "anchors.topMargin"; from: 0; to: -parent.width; duration: transitionTime;}
            NumberAnimation { target: root; property: "anchors.bottomMargin"; from: 0; to: parent.width; duration: transitionTime;}
          }
          PropertyAction { target: root; property: "opacity"}
          PropertyAction { target: root; property: "active"}
          PropertyAction { target: root; property: "anchors.topMargin";  value: 0}
          PropertyAction { target: root; property: "anchors.bottomMargin"; value: 0}
        }
      },
      Transition {
        from: "current"; to: "down";
        SequentialAnimation {
          ParallelAnimation {
            NumberAnimation{ target: root; property: "anchors.topMargin"; from: 0; to:   parent.width; duration: transitionTime;}
            NumberAnimation{ target: root; property: "anchors.bottomMargin"; from: 0; to: -parent.width; duration: transitionTime;}
          }
          PropertyAction { target: root; property: "opacity"}
          PropertyAction { target: root; property: "active"}
          PropertyAction { target: root; property: "anchors.topMargin";  value: 0}
          PropertyAction { target: root; property: "anchors.bottomMargin"; value: 0}
        }
      },
      Transition {
        from: "down"; to: "current";
        SequentialAnimation {
          PropertyAction { target: root; property: "opacity"}
          PropertyAction { target: root; property: "active"}
          ParallelAnimation {
            NumberAnimation { target: root; property: "anchors.topMargin"; from: parent.width; to: 0; duration: transitionTime;}
            NumberAnimation { target: root; property: "anchors.bottomMargin"; from: -parent.width; to: 0; duration: transitionTime;}
          }
        }
      },
      Transition {
        from: "up"; to: "current";
        SequentialAnimation {
          PropertyAction { target: root; property: "opacity"}
          PropertyAction { target: root; property: "active"}
          ParallelAnimation {
            NumberAnimation { target: root; property: "anchors.topMargin"; from: -parent.width; to: 0; duration: transitionTime;}
            NumberAnimation { target: root; property: "anchors.bottomMargin"; from: parent.width; to: 0; duration: transitionTime;}
          }
        }
      }
    ]
  }
}
