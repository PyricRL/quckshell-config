import QtQuick.Layouts
import QtQuick
import Quickshell

import qs.Items

PanelWindow {
  id: root
  implicitWidth: 400
  implicitHeight: 200
  visible: Visibilities.currentActiveModule === "powermenu"
  Rectangle {
    id: powermenu
    implicitWidth: 400
    implicitHeight: 200

    color: "#ffffff"


    RowLayout {
      anchors.fill: parent

      Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        Text {
          text: "Power 1"
        }
      }
      Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        Text {
          text: "Power 2"
        }
      }
      Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        Text {
          text: "Power 3"
        }
      }
      Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        Text {
          text: "Power 4"
        }
      }
    }
  }
}
