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
        anchors.fill: parent

        anchors.margins: 10
        spacing: 10

        AudioContent {}

        Rectangle {
            Text {
                text: "hi"
            }
        }
    }
}
