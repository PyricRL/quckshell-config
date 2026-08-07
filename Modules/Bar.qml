import Quickshell
import QtQuick
import QtQuick.Layouts

import "../Items/" as Items

PanelWindow {
  id: root

  anchors {
    top: true
    left: true
    right: true
  }

  color: "transparent"

  implicitHeight: 24

  RowLayout {
    anchors.fill: parent

    RowLayout {
      Items.Pill {
        Power {}
        Text {
          text: "|"
        }
        Workspaces {}
      }
    }
    Item {
      Layout.fillWidth: true
    }
    RowLayout {
      Media {}
    }
    Item {
      Layout.fillWidth: true
    }
    RowLayout {
      Items.Pill {
        Time {}
        Text {
          text: "|"
        }
        Notifications {}
      }
    }
  }
}
