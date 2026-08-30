import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.Items
import qs.Items.Styled
import qs.Services
import qs.Modules.Notifications

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
        text: "Audio"
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
        text: "Clear All"
        small: true
        visible: NotificationService.history.count > 0

        onClicked: NotificationService.history.clear()
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
        anchors.centerIn: parent
        spacing: Theme.sizes.spacingSmall
        visible: NotificationService.history.count === 0

        Text {
          text: "󰂛"
          color: Theme.colors.textMuted
          font.family: Theme.bar.fontFamily
          font.pixelSize: 32
          Layout.alignment: Qt.AlignHCenter
        }

        Text {
          text: "No Notifications"
          color: Theme.colors.textMuted
          font.family: Theme.bar.fontFamily
          font.pixelSize: Theme.bar.fontSizeSmall
          Layout.alignment: Qt.AlignHCenter
        }
      }

      ScrollView {
        id: scroll
        anchors.fill: parent
        clip: true
        visible: NotificationService.history.count > 0

        ListView {
          id: notificationList
          width: scroll.availableWidth
          model: NotificationService.history
          spacing: Theme.sizes.spacingSmall
          interactive: true

          delegate: HistoryItem {
            required property var modelData

            width: notificationList.width
            notification: modelData
          }
        }
      }
    }
  }
}
