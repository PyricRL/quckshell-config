import QtQuick

import Quickshell

import qs.modules.widgets

Scope {
  id: root

  PanelWindow {
    id: bar

    required property var modelData

    screen: Quickshell.screens.find(screen => screen.name === "DP-3")

    anchors {
      top: true
      left: true
      right: true
    }

    margins {
      top: 4
      left: 4
      right: 4
      bottom: 0
    }

    implicitHeight: 32

    color: "transparent"

    BarContent {
      anchors.fill: parent
    }
  }
}
