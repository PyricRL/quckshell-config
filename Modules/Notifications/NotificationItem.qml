import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications

import qs.Items.Styled
import "../../config.js" as Theme

Rectangle {
  id: card

  required property var notification

  Timer {
    running: notification.urgency !== NotificationUrgency.Critical
    interval: Theme.notification.time

    onTriggered: notification.dismiss()
  }

  width: 320
  Layout.preferredHeight: layout.implicitHeight + (Theme.sizes.paddingLarge * 3)

  radius: Theme.sizes.radiusMedium
  color: Theme.colors.backgroundDark

  border.width: 1
  border.color: {
    switch (notification.urgency) {
      case NotificationUrgency.Critical:
        return Theme.colors.error
      case NotificationUrgency.Low:
        return Theme.colors.warning
      default:
        return Theme.colors.border
    }
  }

  RowLayout {
    id: layout

    anchors {
      left: parent.left
      right: parent.right
      top: parent.top
      margins: Theme.sizes.paddingLarge
    }

    spacing: Theme.sizes.spacingLarge

    Image {
      Layout.preferredWidth: 32
      Layout.preferredHeight: 32
      Layout.alignment: Qt.AlignTop
      fillMode: Image.PreserveAspectFit
      visible: source.toString() !== ""
      source: notification.image || notification.appIcon || ""
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: Theme.sizes.spacingMedium

      StyledText {
        Layout.fillWidth: true
        text: notification.summary || ""
        color: Theme.colors.text
        font.family: Theme.bar.fontFamily
        font.pixelSize: Theme.bar.fontSize
        font.bold: true
        elide: Text.ElideRight
      }

      StyledText {
        Layout.fillWidth: true
        visible: text !== ""
        text: notification.body || ""
        color: Theme.colors.textMuted
        font.family: Theme.bar.fontFamily
        font.pixelSize: Theme.bar.fontSizeSmall + 2
        wrapMode: Text.WordWrap
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: notification.dismiss()
  }
}
