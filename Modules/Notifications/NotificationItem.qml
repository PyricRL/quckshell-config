import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "../../config.js" as Theme
import qs.Items.Styled

Rectangle {
    id: card

    required property var notification

    Timer {
        running: notification.urgency !== NotificationUrgency.Critical
        interval: 5000

        onTriggered: notification.dismiss()
    }

    Layout.fillWidth: true
    Layout.preferredHeight: layout.implicitHeight + 20

    radius: Theme.sizes.radiusSmall

    color: Theme.colors.background

    border.width: 2 + Theme.sizes.borderWidth
    border.color: notification.urgency === NotificationUrgency.Critical
        ? Theme.colors.urgent
        : Theme.colors.border

    RowLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        Image {
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            Layout.alignment: Qt.AlignTop

            fillMode: Image.PreserveAspectFit


            visible: source.toString() !== ""

            source: notification.image || notification.appIcon || ""
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            StyledText {
                Layout.fillWidth: true

                text: notification.summary

                font.pixelSize: 20
                font.bold: true

                elide: Text.ElideRight
            }

            StyledText {
                Layout.fillWidth: true

                visible: text !== ""

                text: notification.body

                font.pixelSize: 16

                wrapMode: Text.WordWrap
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: notification.dismiss()
    }
}
