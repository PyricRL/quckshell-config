import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.services
import qs.modules.widgets
import qs.themes

Scope {
  id: root

  PanelWindow {
    id: window

    implicitWidth: 550
    visible: true

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Normal

    color: "transparent"

    anchors {
      right: true
      left: false
      top: true
      bottom: true
    }

    Item {
      id: notificationList

      anchors.left: parent.left
      anchors.right: parent.right

      Repeater {
        id: rep

        model: Notif.popups

        NotificationChild {
          width: notificationList.width - 80
          anchors.horizontalCenter: notificationList.horizontalCenter

          y: {
            var pos = 0
            for (let i = 0; i < index; i++) {
              var prev = rep.itemAt(i);
              if (prev) {
                pos += prev.height + 3
              }
            }
            return pos + 20;
          }

          Behavior on y {
            NumberAnimation {
              duration: 150
              easing.type: Easing.InOutExpo
            }
          }

          Component.onCompleted: {
            if (!modelData.shown)
              modelData.shown = true
          }

          rawNotif: modelData
          title: modelData.summary
          content: modelData.body
          tracked: modelData.shown

        }
      }
    }
    mask: Region {
      width: window.width
      height: {
        var total = 0;
        for (let i = 0; i < rep.count; i++) {
          var child = rep.itemAt(i);
          if (child)
            total += child.height + (i < rep.count - 1 ? 3 : 0)
        }

        return total;
      }
    }
  }
}
