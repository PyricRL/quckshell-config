import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import qs.Items
import qs.Services
import qs.Modules.Notifications

PanelWindow {
  id: root

  implicitWidth: 400
  implicitHeight: 600

  visible: Visibilities.currentActiveModule === "notificationmenu"

  anchors.right: true
  anchors.top: true

  margins.top: 20

  exclusionMode: ExclusionMode.Ignore

  color: "transparent"

  Rectangle {
    id: panel

    anchors.fill: parent

    radius: 4
    color: "#ffffff"

    ScrollView {
      id: scroll

      anchors.fill: parent
      anchors.margins: 8

      ListView {
        id: notificationList

        model: NotificationService.history
        clip: true
        spacing: 8
        interactive: true

        width: scroll.availableWidth

        header: Column {
          width: notificationList.width
          spacing: 8

          Row {
            width: parent.width
            
            Text {
              width: parent.width - 80 
              text: "Notifications"
              font.pixelSize: 20
              font.bold: true
            }

            Text {
              text: "Clear All"
              color: "#ff0000"
              font.pixelSize: 16

              MouseArea {
                anchors.fill: parent
                onClicked: NotificationService.history.clear()
              }
            }
          }

          Rectangle {
            width: parent.width
            height: 1
            color: "#dddddd"
          }
        }

        footer: Text {
          width: notificationList.width
          height: 40
          visible: NotificationService.history.count === 0
          text: "No Notifications"
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          font.pixelSize: 18
        }

        delegate: HistoryItem {
          required property var modelData
          notification: modelData
          index: index
          width: notificationList.width
        }
      }
    }
  }
}

