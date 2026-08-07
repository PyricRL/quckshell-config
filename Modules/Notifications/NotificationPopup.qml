import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.Services
import qs.Items

PanelWindow {
    anchors {
        top: true
        right: true
    }

    WlrLayershell.layer: WlrLayer.Overlay

    margins {
        top: 30
        right: 4
    }

    implicitWidth: 380
    implicitHeight: column.implicitHeight

    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    visible: Visibilities.currentActiveModule !== "notificationmenu"

    ColumnLayout {
        id: column

        width: parent.width
        spacing: 10

        Repeater {
            model: NotificationService.server.trackedNotifications

            NotificationItem {
                required property var modelData

                notification: modelData
            }
        }
    }
}
