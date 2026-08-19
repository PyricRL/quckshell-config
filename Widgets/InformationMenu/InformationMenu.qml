import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.Items

PanelWindow {
  id: root

  visible: Visibilities.currentActiveModule === "informationmenu"
  implicitWidth: 400
  implicitHeight: 900

  anchors.right: true
  anchors.top: true

  margins.top: 28
  margins.right: 2

  exclusionMode: ExclusionMode.Ignore

  color: "transparent"

  Rectangle {
    anchors.fill: parent

    radius: 4

    RowLayout {
      anchors.fill: parent

      ColumnLayout {
        Layout.fillHeight: true
        Layout.preferredHeight: 10 

        Rectangle {
          width: 20
          height: 20
          color: "#ff0000"
          Text {
            text: "N"
          }
          MouseArea {
            anchors.fill: parent
            onClicked: Visibilities.setActiveTab("network")
          }
        }
        Rectangle {
          width: 20
          height: 20
          color: "#ff0000"
          Text {
            text: "A"
          }
          MouseArea {
            anchors.fill: parent
            onClicked: Visibilities.setActiveTab("audio")
          }
        }

        Rectangle {
          width: 20
          height: 20
          color: "#ff0000"
          Text {
            text: "S"
          }
          MouseArea {
            anchors.fill: parent
            onClicked: Visibilities.setActiveTab("system")
          }
        }

        Rectangle {
          width: 20
          height: 20
          color: "#ff0000"
          Text {
            text: "No"
          }
          MouseArea {
            anchors.fill: parent
            onClicked: Visibilities.setActiveTab("notification")
          }
        }
      }

      StackLayout {
        currentIndex: {
          if (Visibilities.currentActiveTab === "network") return 0;
          if (Visibilities.currentActiveTab === "audio") return 1;
          if (Visibilities.currentActiveTab === "system") return 2;
          if (Visibilities.currentActiveTab === "notification") return 3;
          return 0;
        }

        Item {
          Text {
            text: "network/default"
          }
        }

        Item {
          Text {
            text: "audio"
          }
        }

        Item {
          Text {
            text: "system"
          }
        }

        Item {
          Text {
            text: "notification"
          }
        }
      }
    }
  }
}
