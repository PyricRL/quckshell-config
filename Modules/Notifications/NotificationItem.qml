import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

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

    radius: 4

    color: "#ffffff"

    border.width: 2
    border.color: notification.urgency === NotificationUrgency.Critical
        ? "#ff0000"
        : "#00ff00"

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

            Text {
                Layout.fillWidth: true

                text: notification.summary

                font.pixelSize: 20
                font.bold: true

                elide: Text.ElideRight
            }

            Text {
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
