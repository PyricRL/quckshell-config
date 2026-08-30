import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications

import qs.Services
import "../../config.js" as Theme

Rectangle {
  id: card

  required property var notification
  required property int index

  implicitHeight: layout.implicitHeight + (Theme.sizes.paddingMedium * 2)
  width: parent ? parent.width : 0

  radius: Theme.sizes.radiusMedium
  color: Theme.colors.surfaceInteractive

  border.width: 1
  border.color: notification.urgency === NotificationUrgency.Critical
    ? Theme.colors.error
    : Theme.colors.border

  RowLayout {
    id: layout

    anchors {
      left: parent.left
      right: parent.right
      top: parent.top
      margins: Theme.sizes.paddingMedium
    }

    spacing: Theme.sizes.spacingMedium

    Image {
      Layout.preferredHeight: Theme.sizes.iconLarge
      Layout.preferredWidth: Theme.sizes.iconLarge
      Layout.alignment: Qt.AlignTop
      fillMode: Image.PreserveAspectFit
      visible: source.toString() !== ""
      source: card.notification.image || card.notification.appIcon || ""
    }

    ColumnLayout {
      id: column
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop
      spacing: Theme.sizes.spacingSmall

      RowLayout {
        Layout.fillWidth: true

        Text {
          Layout.fillWidth: true
          text: card.notification.summary || ""
          color: Theme.colors.text
          font.family: Theme.bar.fontFamily
          font.pixelSize: Theme.bar.fontSizeSmall
          font.bold: true
          elide: Text.ElideRight
        }

        Rectangle {
          Layout.alignment: Qt.AlignRight
          width: Theme.sizes.iconMedium
          height: Theme.sizes.iconMedium
          radius: Theme.sizes.radiusSmall
          color: closeArea.containsMouse ? Theme.colors.surfaceHover : "transparent"

          Text {
            anchors.centerIn: parent
            text: "✕"
            color: closeArea.containsMouse ? Theme.colors.contentHover : Theme.colors.textMuted
            font.family: Theme.bar.fontFamily
            font.pixelSize: 10
          }

          MouseArea {
            id: closeArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              NotificationService.history.remove(card.index)
            }
          }
        }
      }

      Rectangle {
        Layout.fillWidth: true
        implicitHeight: 1
        color: Theme.colors.border
      }

      Text {
        Layout.fillWidth: true
        text: card.notification.body || ""
        color: Theme.colors.textMuted
        font.family: Theme.bar.fontFamily
        font.pixelSize: Theme.bar.fontSizeSmall
        wrapMode: Text.WordWrap
      }

      Text {
        Layout.alignment: Qt.AlignRight
        text: card.notification.time || ""
        color: Theme.colors.textDisabled
        font.family: Theme.bar.fontFamily
        font.pixelSize: Theme.bar.fontSizeSmall - 2
      }
    }
  }
}
