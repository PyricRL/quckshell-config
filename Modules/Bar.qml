import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.Items
import qs.Items.Styled

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
      Pill {
        Power {}
        StyledText {
          text: "|"
          small: true
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
      Pill {
        Time {}
        StyledText {
          text: "|"
          small: true
        }
        Audio {}
        Mic {}
        Notifications {}
      }
    }
  }
}
