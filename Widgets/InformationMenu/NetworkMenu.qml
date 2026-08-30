import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell.Networking

import qs.Items
import qs.Items.Styled
import "../../config.js" as Theme

Item {
  id: root

  ColumnLayout {
    anchors.fill: parent
    spacing: Theme.sizes.spacingSmall

    RowLayout {
      Layout.fillWidth: true
      Layout.preferredHeight: Theme.bar.height

      Text {
        text: "Network"
        color: Theme.colors.text
        font.family: Theme.bar.fontFamily
        font.pixelSize: Theme.bar.fontSize
        font.bold: true
        Layout.fillWidth: true
      }

      StyledButton {
        implicitWidth: 65
        implicitHeight: 22
        radius: Theme.sizes.radiusSmall
        text: "Check"
        small: true

        onClicked: Networking.checkConnectivity()
      }
    }

    Rectangle {
      Layout.fillWidth: true
      implicitHeight: 2
      color: Theme.colors.border
    }

    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true

      ColumnLayout {
        anchors.fill: parent
        spacing: Theme.sizes.spacingMedium

        Rectangle {
          Layout.fillWidth: true
          implicitHeight: 48
          radius: Theme.sizes.radiusMedium
          color: Theme.colors.surfaceInteractive
          border.width: Theme.sizes.borderWidth
          border.color: Theme.colors.border

          RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.sizes.paddingMedium
            spacing: Theme.sizes.spacingMedium

            Text {
              text: "󰈀" 
              color: Theme.colors.accent
              font.family: Theme.bar.fontFamily
              font.pixelSize: Theme.bar.fontSize
            }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 0

              StyledText {
                text: "Wired Connection"
                color: Theme.colors.text
                font.family: Theme.bar.fontFamily
                font.pixelSize: Theme.bar.fontSizeSmall
                font.bold: true
              }

              StyledText {
                text: "Ethernet Active"
                color: Theme.colors.success
                font.family: Theme.bar.fontFamily
                font.pixelSize: Theme.bar.fontSizeSmall - 2
              }
            }
          }
        }

        StyledText {
          text: "Interfaces"
          color: Theme.colors.textMuted
          font.family: Theme.bar.fontFamily
          font.pixelSize: Theme.bar.fontSizeSmall
        }

        ScrollView {
          Layout.fillWidth: true
          Layout.fillHeight: true
          clip: true

          ListView {
            id: deviceList
            anchors.fill: parent
            model: Networking.devices
            spacing: Theme.sizes.spacingSmall

            delegate: Rectangle {
              required property var modelData

              width: deviceList.width
              implicitHeight: 36
              radius: Theme.sizes.radiusSmall
              color: Theme.colors.surfaceInteractive

              RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.sizes.paddingMedium
                spacing: Theme.sizes.spacingMedium

                Text {
                  text: "󰈀"
                  color: Theme.colors.contentInteractive
                  font.family: Theme.bar.fontFamily
                  font.pixelSize: Theme.bar.fontSizeSmall
                }

                StyledText {
                  Layout.fillWidth: true
                  text: modelData.name || "Interface"
                  color: Theme.colors.text
                  font.family: Theme.bar.fontFamily
                  font.pixelSize: Theme.bar.fontSizeSmall
                  elide: Text.ElideRight
                }
              }
            }
          }
        }
      }
    }
  }
}
