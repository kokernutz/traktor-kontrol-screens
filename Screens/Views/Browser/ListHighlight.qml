import QtQuick 2.0

import './../Definitions' as Definitions

Item { 
  Rectangle {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 1
    color: (screen.focusDeckId < 2) ? colors.colorBrowserBlueBright56Full : colors.colorGrey64
  }

  Rectangle {
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 1
    color: (screen.focusDeckId < 2) ? colors.colorBrowserBlueBright56Full : colors.colorGrey64
  }
 }   
