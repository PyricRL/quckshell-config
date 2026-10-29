import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.modules.widgets
import qs.themes

StyledRect {
    id: root

    color: Colors.background
    radius: 6
    clip: true

    ColumnLayout {
        id: layout
        width: parent.width
        height: deviceAudio.height + appAudio.height

        anchors.margins: 10
        spacing: 10

        DeviceAudioContent {
            id: deviceAudio
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
        }

        AppAudioContent {
            id: appAudio
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
        }
    }
}
