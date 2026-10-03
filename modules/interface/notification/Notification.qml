import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.services

Scope {
    id: root

    PanelWindow {
        id: window

        implicitWidth: 400
        visible: Notif.popups.count > 0
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.exclusionMode: ExclusionMode.Normal

        anchors {
            right: true
            left: false
            top: true
            bottom: true
        }

        ListView {
            id: notificationList

            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 40
            height: contentHeight

            spacing: 8
            interactive: false
            model: Notif.popups

            add: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        property: "x"
                        from: 100
                        to: 0
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }
            }

            displaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            removeDisplaced: displaced

            delegate: NotificationChild {
                width: ListView.view.width
            }
        }

        mask: Region {
            item: notificationList
        }
    }
}
