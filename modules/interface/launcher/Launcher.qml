import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import qs.modules.widgets
import qs.services
import qs.extras
import qs.themes

PanelWindow {
  id: root

  property var monitor: Niri.focusedMonitor

  property real launcherWidth: 700
  property real launcherHeight: 500

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  color: "transparent"
  exclusiveZone: 0

  visible: States.currentActiveModule === "launcher"

  implicitWidth: launcherWidth
  implicitHeight: launcherHeight

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  Shortcut {
    sequence: "Escape" 
    onActivated: States.setActiveModule("")
  }

  MouseArea {
    anchors.fill: parent
    onClicked: States.setActiveModule("")
  }

  StyledRect {
    id: bgRect

    anchors.centerIn: parent

    color: Colors.background
    implicitWidth: launcherWidth
    implicitHeight: launcherHeight
    radius: 6
  }

  LauncherContent {
    anchors.fill: bgRect
  }
}
