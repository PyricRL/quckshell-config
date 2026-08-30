import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.Services
import qs.Items

import qs.Items.Styled

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

    implicitWidth: 320
    implicitHeight: column.implicitHeight

    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    visible: Visibilities.currentActiveModule !== "notificationmenu"

    ColumnLayout {
        id: column

        width: parent.width

        Repeater {
            model: NotificationService.server.trackedNotifications

            NotificationItem {
                required property var modelData

                notification: modelData
            }
        }
    }
}
