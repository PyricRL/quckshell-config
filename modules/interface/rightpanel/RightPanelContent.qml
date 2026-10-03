import Quickshell
import QtQuick.Layouts

import qs.modules.widgets
import qs.themes

StyledRect {
    id: root

    anchors.fill: parent

    color: Colors.background
    radius: 6

    ColumnLayout {
        AudioContent {}
    }
}
