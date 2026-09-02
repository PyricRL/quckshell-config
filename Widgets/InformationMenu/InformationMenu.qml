import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.Items
import qs.Items.Styled

import "../../config.js" as Theme

PanelWindow {
  id: root

  visible: Visibilities.currentActiveModule === "informationmenu"
  implicitWidth: 400
  implicitHeight: 900

  anchors.right: true
  anchors.top: true

  margins.top: Theme.bar.height + Theme.sizes.spacingSmall
  margins.right: Theme.sizes.spacingSmall

  exclusionMode: ExclusionMode.Ignore
  color: "transparent"

  Rectangle {
    anchors.fill: parent
    radius: Theme.sizes.radiusLarge
    color: Theme.colors.backgroundDark
    border.color: Theme.colors.border
    border.width: Theme.sizes.borderWidth

    RowLayout {
      anchors.fill: parent
      anchors.margins: Theme.sizes.paddingMedium
      spacing: Theme.sizes.spacingMedium

      ColumnLayout {
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignTop
        spacing: Theme.sizes.spacingSmall

        StyledCheckbox {
          implicitWidth: 32
          implicitHeight: 32
          radius: Theme.sizes.radiusMedium
          text: "N"
          small: true

          selected: Visibilities.currentActiveTab === "network"

          onClicked: Visibilities.setActiveTab("network")
        }

        StyledCheckbox {
          implicitWidth: 32
          implicitHeight: 32
          radius: Theme.sizes.radiusMedium
          text: "A"
          small: true

          selected: Visibilities.currentActiveTab === "audio"

          onClicked: Visibilities.setActiveTab("audio")
        }

        StyledCheckbox {
          implicitWidth: 32
          implicitHeight: 32
          radius: Theme.sizes.radiusMedium
          text: "S"
          small: true

          selected: Visibilities.currentActiveTab === "system"

          onClicked: Visibilities.setActiveTab("system")
        }

        StyledCheckbox {
          implicitWidth: 32
          implicitHeight: 32
          radius: Theme.sizes.radiusMedium
          text: "No"
          small: true

          selected: Visibilities.currentActiveTab === "notification"

          onClicked: Visibilities.setActiveTab("notification")
        }

        Item {
          Layout.fillHeight: true
        }

        StyledButton {
          implicitWidth: 32
          implicitHeight: 32
          radius: Theme.sizes.radiusMedium
          text: "󰐥"
          small: true

          onClicked: Visibilities.setActiveModule("powermenu")
        }
      }

      Rectangle {
        Layout.fillHeight: true
        implicitWidth: 2
        color: Theme.colors.border
      }

      Loader {
        id: contentLoader
        Layout.fillWidth: true
        Layout.fillHeight: true

        source: {
          switch (Visibilities.currentActiveTab) {
            case "network":
              return "NetworkMenu.qml"
            case "audio":
              return "AudioMenu.qml"
            case "system":
              return "SystemMenu.qml"
            case "notification":
              return "NotificationMenu.qml"
            default:
              return "NetworkMenu.qml"
          }
        }
      }
    }
  }
}
