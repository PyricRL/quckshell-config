import QtQuick

import Quickshell

import qs.modules.widgets

Scope {
  id: root

  PanelWindow {
    id: bar

    required property var modelData

    screen: Quickshell.screens[1]

    anchors {
      top: true
      left: true
      right: true
    }

    margins {
      top: 2
      left: 4
      right: 4
      bottom: 2
    }

    implicitHeight: 32

    color: "transparent"

    BarContent {
      anchors.fill: parent
    }
  }
}
