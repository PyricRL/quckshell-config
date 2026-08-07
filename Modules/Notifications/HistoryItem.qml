import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import qs.Services

Rectangle {
  id: card

  required property var notification
  required property int index

  implicitHeight: layout.implicitHeight + 20

  radius: 4

  color: "#ffffff"

  border.width: 2
  border.color: notification.urgency === NotificationUrgency.Critical
    ? "#ff0000" : "#00ff00"


  RowLayout {
    id: layout

    anchors.fill: parent

    anchors.margins: 10
    spacing: 4

    Image {
      Layout.preferredHeight: 36
      Layout.preferredWidth: 36
      Layout.alignment: Qt.AlignTop
      fillMode: Image.PreserveAspectFit
      visible: source.toString() !== ""
      source: card.notification.image || card.notification.appIcon || ""
    }

    ColumnLayout {
      id: column
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop
      spacing: 2

      RowLayout {
        Layout.fillWidth: true

        Text {
          Layout.fillWidth: true
          text: card.notification.summary
          font.pixelSize: 20
          font.bold: true
          elide: Text.ElideRight
        }

        Rectangle {
          Layout.alignment: Qt.AlignRight
          width: 20
          height: 20
          radius: 4
          color: "#ff0000"

          Text {
            anchors.centerIn: parent
            text: "X"
          }

          MouseArea {
            anchors.fill: parent
            onClicked: {
              NotificationService.history.remove(index)
            }
          }
        }
      }

      Rectangle {
        Layout.fillWidth: true
        height: 1
        color: "#000000"
      }

      Text {
        Layout.fillWidth: true
        Layout.preferredWidth: column.width
        width: column.width

        text: card.notification.body
        font.pixelSize: 16
        wrapMode: Text.WordWrap
      }

      Text {
          Layout.alignment: Qt.AlignRight
          text: notification.time
          font.pixelSize: 15
        }
    }
  }
}
